% TAG_SIMULATOR_CODEGENERATION_SCRIPT   Generate executable tag_simulator from
%  tag_simulator.
% 
% Script generated from project 'tag_simulator.prj' on 12-Nov-2022.
% 
% See also CODER, CODER.CONFIG, CODER.TYPEOF, CODEGEN.

%% Create configuration object of class 'coder.CodeConfig'.
cfg = coder.config('exe','ecoder',false);
cfg.CustomInclude = { '/Users/mshafer/Desktop/PLAYGROUND/CODE_TOEPLITZ/tag_simulator/CustomMains' };
cfg.CustomSource = { '/Users/mshafer/Desktop/PLAYGROUND/CODE_TOEPLITZ/tag_simulator/CustomMains/main.c' };
cfg.GenerateReport = true;
cfg.ReportPotentialDifferences = false;

%% Define argument types for entry-point 'tag_simulator'.
ARGS = cell(1,1);
ARGS{1} = cell(4,1);
ARGS{1}{1} = coder.typeof(uint32(0));
ARGS{1}{2} = coder.typeof(0,[1 Inf],[0 1]);
ARGS{1}{3} = coder.typeof(0,[1 Inf],[0 1]);
ARGS{1}{4} = coder.typeof(0,[1 Inf],[0 1]);

%% Invoke MATLAB Coder.
codegen -config cfg tag_simulator -args ARGS{1}

