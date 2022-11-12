% TAG_SIMULATOR_SCRIPT   Generate MEX-function tag_simulator_mex from
%  tag_simulator.
% 
% Script generated from project 'tag_simulator.prj' on 11-Nov-2022.
% 
% See also CODER, CODER.CONFIG, CODER.TYPEOF, CODEGEN.

%% Create configuration object of class 'coder.MexCodeConfig'.
cfg = coder.config('mex');
cfg.GenerateReport = true;
cfg.EnableJIT = true;
cfg.EnableJITSilentBailOut = true;

%% Define argument types for entry-point 'tag_simulator'.
ARGS = cell(1,1);
ARGS{1} = cell(4,1);
ARGS{1}{1} = coder.typeof(uint32(0));
ARGS{1}{2} = coder.typeof(0,[1 Inf],[0 1]);
ARGS{1}{3} = coder.typeof(0,[1 Inf],[0 1]);
ARGS{1}{4} = coder.typeof(0,[1 Inf],[0 1]);

%% Invoke MATLAB Coder.
codegen -config cfg tag_simulator -args ARGS{1}

