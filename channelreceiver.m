function [dataReceived] = channelreceiver(remoteIP,localIPPort,resetUDP, releaseSysObj)
%CHANNELRECEIVER receives channelized data from the channelizer function
%via the specified local IP port from the specified remote IP.
%
%This function is defined to interact with airspyhf_channelizer which
%outputs 1024 samples of IQ with a timestamp for a total of 1025 complex
%single precision values. The remoteIP port is not tunable and is only used
%on the first call to setup the dsp.UDPReceiver object. Changing it on
%subsequent calls will do nothing to change the receiver. The local IP port
%is tunable however. This funtion uses persistant variables and must be
%cleared if subsequent calls are needed to change the remote IP. For
%example call 
%
%   mydata = channelreceiver('127.0.0.1',12345);
%   mynewerdata = channelreceiver('127.0.0.1',12345);
%   mynewerdatafromdifferentport = channelreceiver('127.0.0.1',54321);
%   clear channelreceiver
%   datafromnewip = channelreceiver('127.0.0.2',12345);
%
%INPUTS:
%   remoteIP    A string of the remote IP address from which to accept data
%               Example: '127.0.0.1' - local machine
%                        '0.0.0.0'   - receive from any remote IP
%                        '127.0.0.7' - receive from some other IP on the 
%                                      network
%   localIPPort     Scalar value of the port on which to receive the data.
%   resetUDP        Logic to reset the persistant udp object
%   releaseSysObj   Logical to release the dsp.UDPReceiver system object 
%
%OUTPUTS:
%   dataReceived    A vector of received  complex single precision values.
%                   Maximum length is 1025
%
%
%Author:    Michael W. Shafer
%Date:      2022-02-14
%--------------------------------------------------------------------------
   
persistent udpRx
%Reset to clear the buffer of stale data.
if isempty(udpRx) 
    udpRx = dsp.UDPReceiver('RemoteIPAddress',remoteIP,...%127.0.0.1',... %Accept all
                            'ReceiveBufferSize',2^18,...%2^16 = 65536, 2^18
                            'MaximumMessageLength',1025,...
                            'MessageDataType','single',...
                            'IsMessageComplex',true);
end


if resetUDP
    reset(udpRx)
end


if ~releaseSysObj
   if udpRx.LocalIPPort ~= localIPPort
        udpRx.release();
        udpRx.LocalIPPort = localIPPort;
   end
    dataReceived      = udpRx();
else
    release(udpRx);
    dataReceived = 1;
end

end

