%% Preprocessing Batch
%
% Will automatically create a batch-file for the preprocessing in SPM. 
% Only adjust couple of values below (check comments for which variables
% and when you need to adjust them). 
%
% TR, TA, number of slices, number of scans, voxelsize are read in from
% your scan-nifti file, so these parameters are always up to date. 
%
% Important for ideal use: name your anatomical and functional scans the
% same for every subject. And name your folders for every subject identical.
%
% Open SPM in command Window before running this script by >> SPM fmri. The
% scripts keep into account which version you are using of SPM (either SPM8
% or SPM12). 
%
% JB - 03/11/2014

%% Values to adjust for every new subject
SubjectID = 'C3';
name_of_runs = [3 4 5 6 8 9 10 11 13 14 15 16]; % the numbers behind your scanname (for example: if scanname is 'S02_16_1.nii' => name_of_runs is then [16])

%% Values to adjust only once for every new study
% directories
MainDir = ['E:' filesep 'Research' filesep 'Dyscalculie Studie' filesep 'fMRI' filesep]; % dir for your study
HomeDir = [MainDir 'Scripts' filesep 'Automatic Preprocessing' filesep]; % dir with scripts
DataDir = [MainDir 'Ruwe Data' filesep num2str(SubjectID) filesep]; % dir with scandata
ResultDir = [MainDir 'Preprocessed Data' filesep num2str(SubjectID) filesep]; % dir where you want the preprocessed scans
SPMTemplateDir = ['C:\Program Files\spm12\toolbox\OldNorm\'];

% name of scans and anatomy
name_scans = [num2str(SubjectID) '_'];
name_anatomy = [num2str(SubjectID) '_ANATOMIE_'];

% your parameters of choice
Smoothinglevel = [4 4 4];

%% Do not adjust anything (unless you know what you are doing)
% add script directory 
addpath(genpath(HomeDir));

% make preprocessing batch and save in data directory
load([HomeDir 'PREP_BATCH.mat']);
adjust_settings;

% start batch
spm fmri;
spm_jobman('initcfg');
output_list = spm_jobman('run', matlabbatch);
