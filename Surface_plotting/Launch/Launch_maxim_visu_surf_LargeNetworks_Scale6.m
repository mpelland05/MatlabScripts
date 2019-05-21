%Model script for launching maxime_visu_surf, three files are being put on
%the same surfaced brain, one of them as a purple contour. 
%inputs for each data
clear

bpath = 'H:\MyStudies\Modularity\Modularity_Pierre_Corrections_2017\FutureFigures\CompareMaps\Groups\';
%%%%%%%%%
% Pierre's way of getting rid of folders or files
%%%%%%%%%
dir_files = dir(bpath);
mask_dir = [dir_files.isdir];
list_all = {dir_files.name};
mask_dot = ismember(list_all,{'.','..'});
dir_files = dir_files(~mask_dot);
mask_dir = mask_dir(~mask_dot);
list_all = list_all(~mask_dot);
list_files = list_all(~mask_dir);





%files_in.data{1} = 'C:\Users\Maxime\Desktop\Research\Modularity\Figures_organized\LargeNetworks_consensus\Vols\CB_Consensus_S6_L_new.nii';
opt.coType(1,1) = 2;
opt.contour.show(1,1) = 0;
opt.contour.color(1,:) = [1 0 1];
opt.limits.minmax(1,:) = [0.1 1];
opt.limits.over(1,:) = [0 0];
opt.volRefs.vol{1} = 'H:\MatlabToolboxes\Surface_plotting\Models\Vol2Surf\Vol_3mm_NiakBoldOutput.nii'; 
opt.volRefs.surf{1} = 'H:\MatlabToolboxes\Surface_plotting\Models\Vol2Surf\Vol_3mm_NiakBoldOutput_surf.mat';

%this is useful because I only use one volume
%files_in.data{2} = 'H:\MatlabToolboxes\Surface_plotting\Models\Vol2Surf\Empty_surf.mat';
%opt.coType(2,1) = 5;
%opt.contour.show(2,1) = 0;
%opt.contour.color(2,:) = [1 0 1];
%opt.limits.minmax(2,:) = [0.1 100];
%opt.limits.over(2,:) = [0 0];
%opt.volRefs.vol{2} = ''; 
%opt.volRefs.surf{2} = '';

%inputs for all files
files_in.ssurf = ({'mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_left.obj','mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_right.obj'});

files_out = '';

opt.numView = [1 2 3 4];
opt.out.append = '_wsurfed';
opt.out.subfold = 'Surfaced1min';
opt.seed.show = 0;
opt.rot = [30 0; -30 0; -30 0;30 0];
%opt.seed.color = [1 0 1];
%opt.seed.num = 1;
%opt.seed.file = ''; %enter patht to file

%Other way of inputing stuff for all data at once, might become confusing
%though
%opt.coType = [8 0 10];
%opt.contour.show [0 1 0];
%opt.contour.coler(1,:) = [1 0 1; 1 0 1; 1 0 1];

%maxime_visu_surf(files_in, files_out, opt)


for ii = 1:length(list_files),
    
files_in.data{1} = strcat(bpath,list_files{ii});
maxime_visu_surf(files_in, files_out, opt)

end