% Create the inputs of and launch the NIAK_PIPELINE_FMRI_PREPROCESS on the
% specified dataset (RECONSOLIDATION dataset)
%See http://www.nitrc.org/plugins/mwiki/index.php/niak:FmriPreprocessing
%for informations

clear
path_raw_fmri   = '/home/mpelland/database/blindtvr/fmri/RawMncData';
path_preprocess = '/home/mpelland/database/blindtvr/fmri/fmri_preprocess_01_RestOnly_NoSmooth/';

conditions = {'Anat','Rest'};

%%%%%%%%%
%Files_in
%%%%%%%%%
    groups_list = dir([path_raw_fmri]);
    groups_list = groups_list(3:end);
    groups_list = char(groups_list.name);
    
    for group_n = 1:size(groups_list,1)
        group_n
        group = groups_list(group_n,:);
        subjects_list = dir([path_raw_fmri,filesep,group]);
        subjects_list = subjects_list(3:end);
        
        for num_s = 1:size(subjects_list,1)
		
            %% Subject file names
            subject = subjects_list(num_s).name

            path_anat = [path_raw_fmri filesep group filesep subject filesep conditions{1} filesep];
            anat_file = dir(path_anat);
            anat_file = anat_file(3:end);
            anat = [path_anat anat_file.name];
            
            path_fmri = [path_raw_fmri filesep group filesep subject filesep conditions{2} filesep];
            fmri_file = dir(path_fmri);
            fmri_file = fmri_file(3:end);
            fmri.rest.run=[path_fmri fmri_file.name];
            
            %path_fmri2 = [path_raw_fmri filesep group filesep subject filesep conditions{3} filesep];
            %fmri_file2 = dir(path_fmri2);
            %fmri_file2 = fmri_file2(3:end);
            %fmri.task.run=[path_fmri2 fmri_file2.name];
           
            %% Adding the subject to the list of files that need to be preprocessed

            files_in.([group 'xxx' strrep(subject,'_','')]).fmri = fmri;
            files_in.([group 'xxx' strrep(subject,'_','')]).anat = anat;
            clear fmri anat;
        end
    end
    
%%%%%%%%%%%%%%
%Generalities
%%%%%%%%%%%%%%%
opt.folder_out = path_preprocess; 
opt.size_output = 'all';

%%%%%%%%%%%%%%%
% Slice timing
%%%%%%%%%%%%%%
opt.slice_timing.type_acquisition = 'interleaved ascending'; 
opt.slice_timing.type_scanner     = 'Siemens';               
opt.slice_timing.delay_in_tr      = 0;                       

%%%%%%%%
%motion
%%%%%%%%
opt.regress_confounds.flag_wm = true;
opt.regress_confounds.flag_vent = true;
opt.regress_confounds.flag_motion_params = true;
opt.regress_confounds.flag_scrubbing = true;
opt.regress_confounds.thre_fd = 0.5;
opt.regress_confounds.flag_gsc = false;

%opt.motion_correction.suppress_vol = 0;          

%%%%%%%%%%%%%%%%%%%
%Anat normalization
%%%%%%%%%%%%%%%%%%%
opt.t1_preprocess.nu_correct.arg = '-distance 50'; 

%%%%%%%%%%%%%%%%%%%%%%
% T1-T2 coregistration 
%%%%%%%%%%%%%%%%%%%%%%
opt.anat2func.init = 'identity'; 

%%%%%%%%%%%%%%%%%%%%
% Temporal filetring
%%%%%%%%%%%%%%%%%%%
opt.time_filter.hp = 0.01; 
opt.time_filter.lp = Inf;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Correction of physiological noise
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
opt.corsica.flag_skip = true; %<---------------------------------------- Should we keep this? It seems Pierre did not use it. 
opt.corsica.sica.nb_comp = 60;
opt.corsica.component_supp.threshold = 0.15;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Resampling in the stereotaxic space
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%opt.resample_vol.interpolation       = 'tricubic';%<----------------------- Which one should I use?
opt.resample_vol.voxel_size          = [3 3 3];   

%%%%%%%%%%%%%%%%%%
%Spatial smoothing 
%%%%%%%%%%%%%%%%%%
%opt.bricks.smooth_vol.fwhm = 6; 

%%%%%%%%%%%%%%%%
% Region growing
%%%%%%%%%%%%%%%%
 opt.region_growing.flag_skip = 1; % Turn on/off the region growing

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generation of the pipeline %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
opt.flag_test = 0;
%opt.psom.max_queued = 15; % <--------------------------------------------------How many am I allowed?


[pipeline,opt] = niak_pipeline_fmri_preprocess(files_in,opt);

