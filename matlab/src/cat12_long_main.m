function cat12_long_main(inp)

% Created with cat12 version: 'CAT12.8-Beta' (r1856)


% Check input t1 files 
t1list={inp.t1_1_nii
    inp.t1_2_nii
    inp.t1_3_nii
    inp.t1_4_nii};
t1list(strcmp(t1list,'none'),:)=[]; % remove t1 inputs given as 'none'
if(length(t1list)<2) % Need at least 2 T1s for longitudinal processing
    error('Error: Not enough T1 inputs');
end
ntimepts=length(t1list);

% Optional params, need to convert from string to num:
longmodel=str2double(inp.longmodel);% inp.longmodel: longitudinal model - aging vs. plasticity/learning
nproc=str2double(inp.nproc);        % inp.nproc: number of processes/cores available
gcutstr=str2double(inp.gcutstr);    % inp.gcutstr: skull-stripping
vox=str2double(inp.vox);            % inp.vox: output voxel size for normalized images
bb=str2double(inp.bb);              % inp.bb: bounding box for output volume
fwhm=str2double(inp.fwhm);          % inp.fwhm: smoothing kernel fwhm
out_dir=inp.out_dir;                % inp.out_dir: location for output files

% Work in output directory - comment out but leave in case it's needed
% cd(out_dir);


% Setup file lists for input t1 images and smoothing
st1list=cell(ntimepts,1);       % files to be smoothed
centsurflist=cell(ntimepts+1,1);% central surfaces - n time points + avg surface
thicklist=cell(ntimepts+1,1);   % cortical thickness - n time points + avg
gyrilist=cell(ntimepts+1,1);    % gyrification - n time points + avg
depthlist=cell(ntimepts+1,1);   % cortical depth - n time points + avg
fractlist=cell(ntimepts+1,1);   % fractal dimension - n time points + avg

% Construct file names for each time point
for n=1:ntimepts
    [fpath,fname,fext]=fileparts(t1list{n}); % fpath should = out_dir

    st1list{n,1}=fullfile(out_dir,'mri',['mwp1r' fname '.nii']);                % files to be smoothed  
    centsurflist{n,1}=fullfile(out_dir,'surf',['lh.central.r' fname '.gii']);   % central surfaces - n time points
    thicklist{n,1}=fullfile(out_dir,'surf',['lh.thickness.r' fname]);           % cortical thickness - n time points
    gyrilist{n,1}=fullfile(out_dir,'surf',['lh.gyrification.r' fname]);         % gyrification - n time points
    depthlist{n,1}=fullfile(out_dir,'surf',['lh.depth.r' fname]);               % cortical depth - n time points
    fractlist{n,1}=fullfile(out_dir,'surf',['lh.fractaldimension.r' fname]);    % fractal dimension - n time points
end           

% Add file names for average surfaces - these use the base filename of the
% first input t1
[fpath1,fname1,fext1]=fileparts(t1list{1});
centsurflist{ntimepts+1,1}=fullfile(out_dir,'surf',['lh.central.avg_' fname1 '.gii']);  % central surfaces - avg
thicklist{ntimepts+1,1}=fullfile(out_dir,'surf',['lh.thickness.avg_' fname1]);          % cortical thickness - avg
gyrilist{ntimepts+1,1}=fullfile(out_dir,'surf',['lh.gyrification.avg_' fname1]);        % gyrification - avg
depthlist{ntimepts+1,1}=fullfile(out_dir,'surf',['lh.depth.avg_' fname1]);              % cortical depth - avg
fractlist{ntimepts+1,1}=fullfile(out_dir,'surf',['lh.fractaldimension.avg_' fname1]);   % fractal dimension - avg

% Create one list of containing all suface parameters to extract ROI info
nsurffiles=length(thicklist)+length(gyrilist)+length(depthlist)+length(fractlist);
surffiles=cell(nsurffiles,1);

nsurf=ntimepts+1; % number of files per parameter = n time points + avg
surffiles(1:nsurf,1)=thicklist;             % cortical thickness files
surffiles(1+nsurf:nsurf*2,1)=gyrilist;      % gyrification files
surffiles(1+nsurf*2:nsurf*3,1)=depthlist;   % cortical depth files
surffiles(1+nsurf*3:nsurf*4,1)=fractlist;   % fractal dimension files

      
% Start spm
spm_jobman('initcfg');

% Get cat defaults
cat_defaults;

% Setup batch structure
clear matlabbatch;

matlabbatch{1}.spm.tools.cat.long.datalong.subjects = {t1list}'; %t1list;
matlabbatch{1}.spm.tools.cat.long.longmodel =longmodel; % 1;
matlabbatch{1}.spm.tools.cat.long.enablepriors = 1;
matlabbatch{1}.spm.tools.cat.long.bstr = 0;
matlabbatch{1}.spm.tools.cat.long.nproc = nproc; % 18;
matlabbatch{1}.spm.tools.cat.long.opts.tpm = {fullfile(spm('dir'),'tpm','TPM.nii')}; %{'/home/parallels/github/spm12/tpm/TPM.nii'};
matlabbatch{1}.spm.tools.cat.long.opts.affreg = 'mni';
matlabbatch{1}.spm.tools.cat.long.opts.biasstr = 0.5;
matlabbatch{1}.spm.tools.cat.long.opts.accstr = 0.5;
matlabbatch{1}.spm.tools.cat.long.extopts.segmentation.restypes.optimal = [1 0.3];
matlabbatch{1}.spm.tools.cat.long.extopts.segmentation.setCOM = 1;
matlabbatch{1}.spm.tools.cat.long.extopts.segmentation.APP = 1070;
matlabbatch{1}.spm.tools.cat.long.extopts.segmentation.affmod = 0;
matlabbatch{1}.spm.tools.cat.long.extopts.segmentation.NCstr = -Inf;
matlabbatch{1}.spm.tools.cat.long.extopts.segmentation.spm_kamap = 0;
matlabbatch{1}.spm.tools.cat.long.extopts.segmentation.LASstr = 0.5;
matlabbatch{1}.spm.tools.cat.long.extopts.segmentation.LASmyostr = 0;
matlabbatch{1}.spm.tools.cat.long.extopts.segmentation.gcutstr = gcutstr; % 2;
matlabbatch{1}.spm.tools.cat.long.extopts.segmentation.cleanupstr = 0.5;
matlabbatch{1}.spm.tools.cat.long.extopts.segmentation.BVCstr = 0.5;
matlabbatch{1}.spm.tools.cat.long.extopts.segmentation.WMHC = 2;
matlabbatch{1}.spm.tools.cat.long.extopts.segmentation.SLC = 0;
matlabbatch{1}.spm.tools.cat.long.extopts.segmentation.mrf = 1;
matlabbatch{1}.spm.tools.cat.long.extopts.registration.regmethod.shooting.shootingtpm ={fullfile(spm('dir'),'toolbox','cat12','templates_MNI152NLin2009cAsym','Template_0_GS.nii')}; % {'/home/parallels/github/spm12/toolbox/cat12/templates_MNI152NLin2009cAsym/Template_0_GS.nii'};
matlabbatch{1}.spm.tools.cat.long.extopts.registration.regmethod.shooting.regstr = 0.5;
matlabbatch{1}.spm.tools.cat.long.extopts.registration.vox = vox; % 1;
matlabbatch{1}.spm.tools.cat.long.extopts.registration.bb = bb; % 12;
matlabbatch{1}.spm.tools.cat.long.extopts.surface.pbtres = 0.5;
matlabbatch{1}.spm.tools.cat.long.extopts.surface.pbtmethod = 'pbt2x';
matlabbatch{1}.spm.tools.cat.long.extopts.surface.SRP = 22;
matlabbatch{1}.spm.tools.cat.long.extopts.surface.reduce_mesh = 1;
matlabbatch{1}.spm.tools.cat.long.extopts.surface.vdist = 2;
matlabbatch{1}.spm.tools.cat.long.extopts.surface.scale_cortex = 0.7;
matlabbatch{1}.spm.tools.cat.long.extopts.surface.add_parahipp = 0.1;
matlabbatch{1}.spm.tools.cat.long.extopts.surface.close_parahipp = 0;
matlabbatch{1}.spm.tools.cat.long.extopts.admin.experimental = 0;
matlabbatch{1}.spm.tools.cat.long.extopts.admin.new_release = 0;
matlabbatch{1}.spm.tools.cat.long.extopts.admin.lazy = 0;
matlabbatch{1}.spm.tools.cat.long.extopts.admin.ignoreErrors = 0;
matlabbatch{1}.spm.tools.cat.long.extopts.admin.verb = 2;
matlabbatch{1}.spm.tools.cat.long.extopts.admin.print = 2;
matlabbatch{1}.spm.tools.cat.long.output.BIDS.BIDSno = 1;
matlabbatch{1}.spm.tools.cat.long.output.surface = 1;
matlabbatch{1}.spm.tools.cat.long.ROImenu.atlases.neuromorphometrics = 1;
matlabbatch{1}.spm.tools.cat.long.ROImenu.atlases.lpba40 = 1;
matlabbatch{1}.spm.tools.cat.long.ROImenu.atlases.cobra = 1;
matlabbatch{1}.spm.tools.cat.long.ROImenu.atlases.hammers = 1;
matlabbatch{1}.spm.tools.cat.long.ROImenu.atlases.thalamus = 1;
matlabbatch{1}.spm.tools.cat.long.ROImenu.atlases.ibsr = 1;
matlabbatch{1}.spm.tools.cat.long.ROImenu.atlases.aal3 = 1;
matlabbatch{1}.spm.tools.cat.long.ROImenu.atlases.mori = 1;
matlabbatch{1}.spm.tools.cat.long.ROImenu.atlases.anatomy3 = 1;
matlabbatch{1}.spm.tools.cat.long.ROImenu.atlases.julichbrain = 1;
matlabbatch{1}.spm.tools.cat.long.ROImenu.atlases.Schaefer2018_100Parcels_17Networks_order = 1;
matlabbatch{1}.spm.tools.cat.long.ROImenu.atlases.Schaefer2018_200Parcels_17Networks_order = 1;
matlabbatch{1}.spm.tools.cat.long.ROImenu.atlases.Schaefer2018_400Parcels_17Networks_order = 1;
matlabbatch{1}.spm.tools.cat.long.ROImenu.atlases.Schaefer2018_600Parcels_17Networks_order = 1;
matlabbatch{1}.spm.tools.cat.long.ROImenu.atlases.ownatlas = {''};
matlabbatch{1}.spm.tools.cat.long.longTPM = 1;
matlabbatch{1}.spm.tools.cat.long.modulate = 1;
matlabbatch{1}.spm.tools.cat.long.dartel = 0;
matlabbatch{1}.spm.tools.cat.long.delete_temp = 0;
matlabbatch{2}.spm.tools.cat.tools.calcvol.data_xml = {fullfile(out_dir,'report','cat_avg_t1_1.xml')}; % {'/home/parallels/github/cat12_long/OUTPUTS_MANUALBATCH/report/cat_avg_t1_1.xml'};
matlabbatch{2}.spm.tools.cat.tools.calcvol.calcvol_TIV = 0;
matlabbatch{2}.spm.tools.cat.tools.calcvol.calcvol_name = fullfile(out_dir,'TIV.txt'); % '../../OUTPUTS_MANUALBATCH/TIV.txt';
matlabbatch{3}.spm.spatial.smooth.data = st1list;
matlabbatch{3}.spm.spatial.smooth.fwhm = [fwhm fwhm fwhm]; % [4 4 4];
matlabbatch{3}.spm.spatial.smooth.dtype = 0;
matlabbatch{3}.spm.spatial.smooth.im = 0;
matlabbatch{3}.spm.spatial.smooth.prefix = ['s' num2str(fwhm)]; % 's4';
matlabbatch{4}.spm.tools.cat.stools.surfextract.data_surf = centsurflist;
matlabbatch{4}.spm.tools.cat.stools.surfextract.area = 0;
matlabbatch{4}.spm.tools.cat.stools.surfextract.gmv = 0;
matlabbatch{4}.spm.tools.cat.stools.surfextract.GI = 1;
matlabbatch{4}.spm.tools.cat.stools.surfextract.SD = 1;
matlabbatch{4}.spm.tools.cat.stools.surfextract.FD = 1;
matlabbatch{4}.spm.tools.cat.stools.surfextract.tGI = 0;
matlabbatch{4}.spm.tools.cat.stools.surfextract.lGI = 0;
matlabbatch{4}.spm.tools.cat.stools.surfextract.GIL = 0;
matlabbatch{4}.spm.tools.cat.stools.surfextract.surfaces.IS = 0;
matlabbatch{4}.spm.tools.cat.stools.surfextract.surfaces.OS = 0;
matlabbatch{4}.spm.tools.cat.stools.surfextract.norm = 0;
matlabbatch{4}.spm.tools.cat.stools.surfextract.FS_HOME = '<UNDEFINED>';
matlabbatch{4}.spm.tools.cat.stools.surfextract.nproc = nproc; % 2;
matlabbatch{4}.spm.tools.cat.stools.surfextract.lazy = 0;
%%
matlabbatch{5}.spm.tools.cat.stools.surf2roi.cdata = {surffiles}'; % surffiles;
%%
matlabbatch{5}.spm.tools.cat.stools.surf2roi.rdata = {fullfile(spm('dir'),'toolbox','cat12','atlases_surfaces','lh.Schaefer2018_100Parcels_17Networks_order.annot')
                                                      fullfile(spm('dir'),'toolbox','cat12','atlases_surfaces','lh.Schaefer2018_200Parcels_17Networks_order.annot')
                                                      fullfile(spm('dir'),'toolbox','cat12','atlases_surfaces','lh.Schaefer2018_400Parcels_17Networks_order.annot')
                                                      fullfile(spm('dir'),'toolbox','cat12','atlases_surfaces','lh.Schaefer2018_600Parcels_17Networks_order.annot')
                                                      fullfile(spm('dir'),'toolbox','cat12','atlases_surfaces','lh.aparc_DK40.freesurfer.annot')
                                                      fullfile(spm('dir'),'toolbox','cat12','atlases_surfaces','lh.aparc_HCP_MMP1.freesurfer.annot')
                                                      fullfile(spm('dir'),'toolbox','cat12','atlases_surfaces','lh.aparc_a2009s.freesurfer.annot')
                                                      };

matlabbatch{6}.spm.tools.cat.stools.surfresamp.sample{1}.data_surf = thicklist;
matlabbatch{6}.spm.tools.cat.stools.surfresamp.merge_hemi = 1;
matlabbatch{6}.spm.tools.cat.stools.surfresamp.mesh32k = 0;
matlabbatch{6}.spm.tools.cat.stools.surfresamp.fwhm_surf = 15;
matlabbatch{6}.spm.tools.cat.stools.surfresamp.lazy = 0;
matlabbatch{6}.spm.tools.cat.stools.surfresamp.nproc = nproc;
matlabbatch{7}.spm.tools.cat.stools.surfresamp.sample{1}.data_surf = gyrilist;
matlabbatch{7}.spm.tools.cat.stools.surfresamp.merge_hemi = 1;
matlabbatch{7}.spm.tools.cat.stools.surfresamp.mesh32k = 0;
matlabbatch{7}.spm.tools.cat.stools.surfresamp.fwhm_surf = 20;
matlabbatch{7}.spm.tools.cat.stools.surfresamp.lazy = 0;
matlabbatch{7}.spm.tools.cat.stools.surfresamp.nproc = nproc; % 18;
matlabbatch{8}.spm.tools.cat.stools.surfresamp.sample{1}.data_surf = depthlist;
matlabbatch{8}.spm.tools.cat.stools.surfresamp.merge_hemi = 1;
matlabbatch{8}.spm.tools.cat.stools.surfresamp.mesh32k = 0;
matlabbatch{8}.spm.tools.cat.stools.surfresamp.fwhm_surf = 20;
matlabbatch{8}.spm.tools.cat.stools.surfresamp.lazy = 0;
matlabbatch{8}.spm.tools.cat.stools.surfresamp.nproc = nproc; % 18;
matlabbatch{9}.spm.tools.cat.stools.surfresamp.sample{1}.data_surf = fractlist;
matlabbatch{9}.spm.tools.cat.stools.surfresamp.merge_hemi = 1;
matlabbatch{9}.spm.tools.cat.stools.surfresamp.mesh32k = 0;
matlabbatch{9}.spm.tools.cat.stools.surfresamp.fwhm_surf = 20;
matlabbatch{9}.spm.tools.cat.stools.surfresamp.lazy = 0;
matlabbatch{9}.spm.tools.cat.stools.surfresamp.nproc = nproc; % 18;

save(fullfile(out_dir,'cat12batch.mat'), 'matlabbatch');
spm_jobman('run', matlabbatch); 




end
