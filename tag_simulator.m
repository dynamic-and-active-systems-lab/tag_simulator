function []= tag_simulator(sampleRate, basebandFreq, tip, SNRdB) %#codegen

%
%   INPUTS:
%       rawSampleRate   A single integer sample rate. Valid entries
%                       correspond to those available for the Airspy HF+
%                       radio: [912 768 456 384 256 192] kS/s
%
%   OUTPUTS:
%       none
%
%
%
%-------------------------------------------------------------------------
%Author:    Michael Shafer
%Date:      2022-01-18
%-------------------------------------------------------------------------
fprintf('Tag Simulator: Starting up...\n')

sampleRate = double(sampleRate);%Redefine for coder since it will be a uint
basebandFreq = basebandFreq(:); %Force to vector
tip          = tip(:); %Force to vector
SNRdB        = SNRdB(:); %Force to vector
freqsSize    = size(basebandFreq);

fprintf(' SampleRate %f\n',sampleRate)

fprintf('numel basebandFreq %f\n',numel(basebandFreq))
fprintf('numel tip %f\n',numel(tip))
fprintf('numel SNRdB %f\n',numel(SNRdB))

for i = 1:numel(basebandFreq)
fprintf(' basebandFreq %f\n',basebandFreq(i))
fprintf(' tip %f\n', tip(i))
fprintf(' SNRdB %f\n', SNRdB(i))
end

if freqsSize ~= size(tip) | freqsSize ~= size(SNRdB) 
    errorMsg = 'UAV-RT Error: frequency, interpulse time, and SNRdB inputs must be the same size.';
    if coder.target('MATLAB')
        error(errorMsg);
    else
        fprintf(errorMsg);
        return
    end
end

numTags = max(freqsSize);

%% SETUP UDP OUTPUT OBJECTS
fprintf('Tag Simulator: Setting up output channel UDP ports...\n')

%Outgoing UDP Parameters
udpServerPort     = 10000;
frameLength       = 2048; % Must be a multiple of 128
frameTime         = frameLength/sampleRate;
bytesPerSample    = 8;
frameSize         = frameLength*bytesPerSample;
timePerBufferGoal = 0.25;
framesPerBuffer   = ceil(timePerBufferGoal / frameTime);
timePerBuffer     = framesPerBuffer * frameTime;
samplesPerBuffer  = framesPerBuffer * frameLength; 
udpBufferSize     = 2^nextpow2(10*frameSize);

udpSender = dsp.UDPSender('RemoteIPAddress','127.0.0.1',...%127.0.0.1',... %Accept all
        'RemoteIPPort',udpServerPort,...
        'SendBufferSize',udpBufferSize);

%Make initial call to udps. First call is very slow and can cause missed
%samples if left within the while loop
singleZeros = complex(single(zeros(1,1)));
nullPacket  = singleZeros;
udpSender(nullPacket);%Add one for blank time stamp

%% Setup remaining tag parameter
t0   = tip;%.*rand(numTags,1); %Randomize initial start time between 0 and tip
tp   = 0.02*ones(numTags,1);%TODO - add capacity to change tp for each tag
tipj = 0.001*ones(numTags,1);%TODO - add capacity to change tipj for each tag

fprintf('Tag Simulator: Setup complete...\n')
maxPulsesPerBuffer = zeros(numTags,1);
for i = 1:numTags
    maxPulsesPerBuffer(i) = ceil( 1 + timePerBuffer/(tip(i)+10*tipj(i)));
end

%Setup a time vector for each buffer;
tBase     = 1/sampleRate*transpose(1:samplesPerBuffer);
t         = tBase;
tPrevious = t0-tip;
tStart    = posixtime(datetime('now'));
tRelease  = tStart+timePerBuffer;
loopCount = 0;
nLoopTimeRecord      = 10;
actualLoopTimeRecord = nan(1,nLoopTimeRecord);
frameSendDelayCompensation = 0;
coder.varsize('tPulse', [1 50], [0 1])
if any(tip*5 < timePerBuffer)
    errorMsg = 'UAV-RT Error: Pulse Simulator only supports up to 50 pulses every 0.25 s.';
    if coder.target('MATLAB')
        error(errorMsg);
    else
        fprintf(errorMsg);
        return;
    end
end
tic
yNoisy = complex(zeros(samplesPerBuffer, numTags));
yClean = complex(zeros(samplesPerBuffer, numTags));


while 1
    %Determine when during the current the time block should have 
    %the sine wave turned on
    pulseMask       = zeros(numel(t),numTags);
    pulseMaskPhased = complex(zeros(numel(t),numTags));
    for i = 1:numTags
        %Develop a list of times the next pulses will be since the last. 
        tPulse = tPrevious(i) + (1:maxPulsesPerBuffer(i)).*(tip(i)+normrnd(0,tipj(i),[1 maxPulsesPerBuffer(i)]));

        for j = 1:maxPulsesPerBuffer(i)
            %Use the pulse mask to individually phaseshift each pulse by a
            %random amount.
            pulseMaskPhased( t > tPulse(j) & t < tPulse(j) + tp(i), j) = exp(1i*2*pi*randi(i));
        end
    end
    pulseMask(pulseMaskPhased~=0) = 1;
    %Determine sinewave 
    %SNRdB    = 10; 
    noisePow = 0.001; %Assume 1mW of noise power
    noise    = wgn(samplesPerBuffer,1,noisePow,'linear','complex');
    SNRLin   = 10.^(1/10*SNRdB);
    sinePow  = SNRLin * noisePow;
    sineAmp  = sqrt(sinePow);
    %Build data vectors for each tag
    for i = 1:numTags
        sineWave    = exp(1i*2*pi*basebandFreq(i).*t);
        sinData     = sineAmp(i)*sineWave;
        yClean(:,i) = single(sinData.*pulseMaskPhased(:,i));
        %Find the time for the start of the last pulse in this buffer, if it
        %exists so we can updated the tPrevious for the next loop.
        indLastStart = 1+find(diff(pulseMask(:,i))==1,1,'last');
        if ~isempty(indLastStart)
            tPrevious(i) = t(indLastStart(1));%(1) so that coder knows the output will be only 1 element
        end
    end
    %Combine all tag signals and noise
    yNoisy = sum(yClean,2) + single(noise);

    %Update time vector
    t = tBase+t(end)+1/samplesPerBuffer;
    %Output frames of data to UDP
    
    for i = 1:framesPerBuffer
        %transmitStart = toc;
        udpSender(yNoisy((i-1)*frameLength+(1:frameLength)))
        %TODO:
        % add an additional output for the clean data for reference in
        % testing

%          plot(t((i-1)*frameLength+(1:frameLength)),...
%               real(yNoisy((i-1)*frameLength+(1:frameLength)))); hold on
        %transmitEnd = toc;
        pause(frameTime-frameSendDelayCompensation);
    end

    %Throttle exectution to only moveon after the buffer's duration has
    %elapsed to simulate real-time exectution.
    
    neededHoldTime = tRelease - posixtime(datetime('now'));
    if neededHoldTime > 0
        pause(neededHoldTime);
    end
    %Update tReselease for the next loop. 
    tRelease = posixtime(datetime('now'))+timePerBuffer;
    actualLoopTimeRecord(mod(loopCount,5)+1) = toc;
    averageLoopTime = mean(actualLoopTimeRecord,'omitnan');
    frameSendDelayCompensation = (averageLoopTime - timePerBuffer)/framesPerBuffer
    loopCount = loopCount+1;
    tic
    fprintf('Actual Loop Time: %f \n', actualLoopTimeRecord(mod(loopCount,5)+1));
    
end

end





