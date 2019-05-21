%Model script for launching maxime_visu_surf, three files are being put on
%the same surfaced brain, one of them as a purple contour. 
%inputs for each data
clear

files_in.data{1} = 'C:\Users\Maxime\Desktop\Research\Modularity\Figures_organized\Newregion\Surfed\V1_higherthan_V23.mat';
opt.coType(1,1) = 11;
opt.contour.show(1,1) = 0;
opt.contour.color(1,:) = [1 0 1];
opt.limits.minmax(1,:) = [1 90];
opt.limits.over(1,:) = [0 1];
opt.volRefs.vol{1} = 'H:\MatlabToolboxes\Surface_plotting\Models\Vol2Surf\Vol_1mm_MNI.nii'; 
opt.volRefs.surf{1} = 'H:\MatlabToolboxes\Surface_plotting\Models\Vol2Surf\Vol_1mm_MNI_surf.mat';

files_in.data{2} = 'C:\Users\Maxime\Desktop\Research\Modularity\Figures_organized\Newregion\Surfed\V2_higherthan_V13.mat';
opt.coType(2,1) = 13;
opt.contour.show(2,1) = 0;
opt.contour.color(2,:) = [1 0 1];
opt.limits.minmax(2,:) = [1 110];
opt.limits.over(2,:) = [0 1];
opt.volRefs.vol{2} = ''; 
opt.volRefs.surf{2} = '';

files_in.data{3} = 'C:\Users\Maxime\Desktop\Research\Modularity\Figures_organized\Newregion\Surfed\V3_higherthan_V12.mat';
opt.coType(3,1) = 12;
opt.contour.show(3,1) = 0;
opt.contour.color(3,:) = [1 0 1];
opt.limits.minmax(3,:) = [1 110];
opt.limits.over(3,:) = [0 1];
opt.volRefs.vol{3} = ''; 
opt.volRefs.surf{3} = '';

%inputs for all files
files_in.ssurf = ({'mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_left.obj','mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_right.obj'});

files_out = '';

opt.NumView = [1 2 3 4];
opt.out.append = '_wsurfed';
opt.out.subfold = 'Surfaced';
opt.seed.show = 0;
opt.rot = [60 0; -60 0; -60 0;45 0];
%opt.seed.color = [1 0 1];
%opt.seed.num = 1;
%opt.seed.file = ''; %enter patht to file

%Other way of inputing stuff for all data at once, might become confusing
%though
%opt.coType = [8 0 10];
%opt.contour.show [0 1 0];
%opt.contour.coler(1,:) = [1 0 1; 1 0 1; 1 0 1];

maxime_visu_surf(files_in, files_out, opt)