clear all

root_path = '/home/mpelland/database/blindModularity/fmri/';

files_in = niak_grab_fmri_preprocess('/home/mpelland/database/blindtvr/fmri/fmri_preprocess_01');

%%%%%
%Grab
%%%%%%
t_in = niak_grab_region_growing([root_path 'region_growing_RestOnly_CBSCMixed_OccMask/rois/']);

files_in.atoms = t_in.atoms;
files_in.data = t_in.data;

%%%%%%
%Basc
%%%%%%
opt.folder_out = [root_path 'basc_RestOnly_CBSCMixed_OccMask_f_v2/']; 

opt.grid_scales = [3 5 10 13 20 22 26 40]; 
opt.scales_maps = [3 3 3; 5 5 5 ; 13 10 10; 20 22 26; 40 40 40];
opt.stability_tseries.nb_samps = 100; 
opt.stability_group.nb_samps = 500; 

%opt.filter.session = 'Rest';

opt.flag_tseries_network = 1; 

files_in.infos = '/home/mpelland/database/blindModularity/models/BascModel.csv';

%opt.psom.qsub_options = '-q qwork@ms -l walltime=05:00:00';

%%%%%%%%%%%%%%%%%%%%%%
%% Run the pipeline %%
%%%%%%%%%%%%%%%%%%%%%%
opt.flag_test = false;
[pipeline,opt] = niak_pipeline_stability_rest(files_in,opt);

