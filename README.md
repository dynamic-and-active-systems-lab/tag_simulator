# tag_simulator

Simulate radio data from up to 20 different tags, as would be generated by the Airspy radio. Arguments to the Matlab function are:
1. A single integer sample rate that the radio would output (ie. 192000, 912000, 3000000, etc.)
2. Vector of tag frequencies in baseband Hz (ie. [100, -500, 1000])
3. Vector of tag interpulse durations in seconds (ie. [1.5, 1, 2.7])
4. Vector of tag SNR values in dB (ie. [5 -2 11]);

The output data will be reported via 127.0.0.1 on port 10000. The program attempts to deploy the radio data in real time, but this can't be guaranteeded and is subject to the precision of Matlab's pause() and timestamping abilities with tic-toc. 

If building this as an exectuable, the tag_simulator_codegeneration_script.m can be used. The CustomMains file contains the main.c that is compiled to an exectuable. You will need to updated the lines:
`
cfg.CustomInclude = { '/Users/mshafer/Desktop/PLAYGROUND/CODE_TOEPLITZ/tag_simulator/CustomMains' };
cfg.CustomSource = { '/Users/mshafer/Desktop/PLAYGROUND/CODE_TOEPLITZ/tag_simulator/CustomMains/main.c' };
`
with the path to the CustomMains file on your system. 

When calling the generated executable from the commandline, the arguments are
1. A single integer sample rate that the radio would output (ie. 192000, 912000, 3000000, etc.)
2. A single tag frequency in baseband Hz (ie. 100)
3. A single tag interpulse duration in seconds (ie. 1.5)
4. A single tag SNR value in dB (ie. 5);

Multiple tags can be entered by continuing the last three entries multiple times. For example, to include two tags in the output radio data the command line entry would be 
`$ ./tag_simulator 192000 100 1.5 5 -500 1 -2 `

