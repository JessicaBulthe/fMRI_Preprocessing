%% Load scan file for parameters
raw_scanfile = load_untouch_nii([DataDir name_scans num2str(name_of_runs(1)) '_1.nii']);

number_slices = raw_scanfile.hdr.dime.dim(1,4);
number_scans = raw_scanfile.hdr.dime.dim(1,5);
TR = raw_scanfile.hdr.dime.pixdim(1,5);
TA = TR-(TR/number_slices);
VoxelSizes = raw_scanfile.hdr.dime.pixdim(1,2:4);

%% Remove unnecessary sessions
for i = size(name_of_runs,2)+1:size(matlabbatch{1}.spm.temporal.st.scans,2)
    matlabbatch{1}.spm.temporal.st.scans{1,i} = [];
    matlabbatch{2}.spm.spatial.realign.estwrite.data{i} = [];
end
matlabbatch{1}.spm.temporal.st.scans(cellfun(@isempty, matlabbatch{1}.spm.temporal.st.scans)) = [];
matlabbatch{2}.spm.spatial.realign.estwrite.data(cellfun(@isempty,  matlabbatch{2}.spm.spatial.realign.estwrite.data)) = [];

% depending on the version of SPM you are using, other structure
[v, r] = spm('Ver', '',1);
if strcmp(v, 'SPM8')
    matlabbatch{4}.spm.spatial.normalise.estwrite.subj.resample = matlabbatch{4}.spm.spatial.normalise.estwrite.subj.resample(1,[1:size(name_of_runs,2) size(matlabbatch{4}.spm.spatial.normalise.estwrite.subj.resample,2)]);
else
    matlabbatch{4}.spm.tools.oldnorm.estwrite.subj.resample = matlabbatch{4}.spm.tools.oldnorm.estwrite.subj.resample(1,[1:size(name_of_runs,2) size(matlabbatch{4}.spm.tools.oldnorm.estwrite.subj.resample,2)]);
end

%% 1. Slice Timing
% load scans => data tab in batch
for session = 1:size(name_of_runs,2)
    % inladen info van de scan-doc
    information_scan = load_untouch_nii([DataDir name_scans num2str(name_of_runs(session)) '_1.nii']);

    for scans = 1:number_scans
        matlabbatch{1}.spm.temporal.st.scans{session}(scans) = cellstr([DataDir name_scans num2str(name_of_runs(session)) '_1.nii,' num2str(scans)]);
    end
end

% give in parameters
matlabbatch{1}.spm.temporal.st.nslices = number_slices;
matlabbatch{1}.spm.temporal.st.tr = TR;
matlabbatch{1}.spm.temporal.st.ta = TA;
matlabbatch{1}.spm.temporal.st.so = 1:number_slices;

%% 3. Coregister 
% search for anatomy file
file = dir([DataDir name_anatomy '*.nii']);

% anatomy file
 matlabbatch{3}.spm.spatial.coreg.estwrite.source = cellstr([DataDir file.name]);
 
%% 4. Normalise
if strcmp(v, 'SPM8')
    matlabbatch{4}.spm.spatial.normalise.estwrite.eoptions.template = cellstr([SPMTemplateDir 'T1.nii,1']);
    matlabbatch{4}.spm.spatial.normalise.estwrite.roptions.vox = VoxelSizes;    
else
    matlabbatch{4}.spm.tools.oldnorm.estwrite.eoptions.template = cellstr([SPMTemplateDir 'T1.nii,1']);
    matlabbatch{4}.spm.tools.oldnorm.estwrite.roptions.vox = VoxelSizes;
end

%% 5. Smoothing
matlabbatch{5}.spm.spatial.smooth.fwhm = Smoothinglevel;

%% 6. Save 
save([ResultDir 'preprocessingbatch_Subject' num2str(SubjectID) '.mat'], 'matlabbatch');
