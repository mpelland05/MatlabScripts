%Grabbing preprocess
path_g = '/home/mpelland/database/blindtvr/fmri/fmri_preprocess_01/';
opt_g.flag_areas = 0;
opt_g.type_files = 'glm_connectome';
files_in = niak_grab_fmri_preprocess(path_g,opt_g);

files_in.seeds = strcat('SeedsForShow3.csv');

gin = '/home/mpelland/database/blindModularity/fmri/basc_RestOnly_CBSCMixed_OccMask_f/stability_group/';
gout = '/home/mpelland/database/blindModularity/connectomes/RestOnly_CBSCMixed_OccMask_f/Fisher/';

subfol = [3 3 3; 5 5 5 ; 13 10 10; 20 22 26; 40 40 40]

%Setting up the options of the connectome
opt.flag_global_prop = 1;
opt.flag_local_prop = 0;

opt.connectome.type = 'Z';
opt.connectome.thresh.type = 'sparsity';
opt.connectome.thresh.param = 1;

%Starting analysis loop
for ii = 1:length(subfol),
	
    scale = strcat('sci',num2str(subfol(ii,1)),'_scg',num2str(subfol(ii,2)),'_scf',num2str(subfol(ii,3)))
    
	files_in.network = strcat( gin,scale,filesep,'brain_partition_consensus_group_',scale,'.nii.gz' );

	opt.folder_out = strcat( gout, scale);

	%Launching the analysis
	niak_pipeline_connectome(files_in,opt);
end
