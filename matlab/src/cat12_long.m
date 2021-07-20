function cat12_long(varargin)


%% Just quit, if requested - needed for Singularity build?
if numel(varargin)==1 && strcmp(varargin{1},'quit') && isdeployed
	disp('Exiting as requested')
	exit
end

%% Parse inputs
P = inputParser;

% T1 images (.nii) - take max number of T1s, for now max=4, min=2
addOptional(P,'t1_1_nii','');
addOptional(P,'t1_2_nii','');
addOptional(P,'t1_3_nii','none'); % default is none since min=2
addOptional(P,'t1_4_nii','none'); % default is none since min=2

% Model for longitudinal preprocessing
%   1: plasticity/learning, small changes (default)
%   2: detect large changes, e.g., atrophy with aging or developmental effects
addOptional(P,'longmodel','1');

% Number of cores/processors available for parallel processing
%   0: don't run in background (default)
addOptional(P,'nproc','0');

% Skull-stripping method
%   2: adaptive probability region growing (default)
%   0.5: GCUT
%   0: SPM 
%   -1: none, already skull-stripped
addOptional(P,'gcutstr','2');

% Voxel size for normalized images 
%   spider default: 1
%   CAT12 default: 1.5
addOptional(P,'vox','1');

% Bounding box for dimensions of output volumes 
%   12: MNI CAT [-84 -120 -72; 84 84 96] [113x139x113]
%   16: MNI SPM [-90 -126 -72; 90 90 108] [121x145x121]
addOptional(P,'bb','12');

% FWHM of spatial smoothing kernel in mm applied to MNORM GM images 
addOptional(P,'fwhm','4');

% Subject info if on XNAT
addOptional(P,'label_info','UNKNOWN_SCAN');

% Change paths to match test environment if needed - NOT SURE ABOUT THIS
% addOptional(P,'src_dir','/opt/cat12/src');

% Where to store outputs
addOptional(P,'out_dir','/OUTPUTS');

% Parse and display command line arguments
parse(P,varargin{:});
disp(P.Results)


%% Process
cat12_long_main(P.Results);


%% Exit if running compiled executable
if isdeployed
	exit
end