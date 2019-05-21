%Model script for launching maxime_visu_surf, three files are being put on
%the same surfaced brain, one of them as a purple contour. 
%inputs for each data
clear

im = 1;
files_in.data{im} = 'E:\MammouthSave\Modularity_PierreCorrections_2017\ICA\Vol4Figures\Left_Log10Pos7_1.nii';
opt.coType(im,1) = 2;
opt.contour.show(im,1) = 0;
opt.contour.color(im,:) = [1 0 1];
opt.limits.minmax(im,:) = [1.3010 4];
opt.limits.over(im,:) = [0 1];
opt.volRefs.vol{im} = 'H:\MatlabToolboxes\Surface_plotting\Models\Vol2Surf\Vol_3mm_NiakBoldOutput.nii'; 
opt.volRefs.surf{im} = 'H:\MatlabToolboxes\Surface_plotting\Models\Vol2Surf\Vol_3mm_NiakBoldOutput_surf.mat';

im = 2;
files_in.data{im} = 'E:\MammouthSave\Modularity_PierreCorrections_2017\ICA\Vol4Figures\Right_Log10Pos6_1.nii';
opt.coType(im,1) = 2;
opt.contour.show(im,1) = 0;
opt.contour.color(im,:) = [1 0 1];
opt.limits.minmax(im,:) = [1.3010 4];
opt.limits.over(im,:) = [0 1];
opt.volRefs.vol{im} = 'H:\MatlabToolboxes\Surface_plotting\Models\Vol2Surf\Vol_3mm_NiakBoldOutput.nii'; 
opt.volRefs.surf{im} = 'H:\MatlabToolboxes\Surface_plotting\Models\Vol2Surf\Vol_3mm_NiakBoldOutput_surf.mat';

im=3;
files_in.data{im} = 'E:\MammouthSave\Modularity_PierreCorrections_2017\ICA\Vol4Figures\Left_Log10Neg7_1.nii';
opt.coType(im,1) = 3;
opt.contour.show(im,1) = 0;
opt.contour.color(im,:) = [1 0 1];
opt.limits.minmax(im,:) = [1.3010 4];
opt.limits.over(im,:) = [0 1];
opt.volRefs.vol{im} = 'H:\MatlabToolboxes\Surface_plotting\Models\Vol2Surf\Vol_3mm_NiakBoldOutput.nii'; 
opt.volRefs.surf{im} = 'H:\MatlabToolboxes\Surface_plotting\Models\Vol2Surf\Vol_3mm_NiakBoldOutput_surf.mat';

im=4;
files_in.data{im} = 'E:\MammouthSave\Modularity_PierreCorrections_2017\ICA\Vol4Figures\Right_Log10Neg6_1.nii';
opt.coType(im,1) = 3;
opt.contour.show(im,1) = 0;
opt.contour.color(im,:) = [1 0 1];
opt.limits.minmax(im,:) = [1.3010 4];
opt.limits.over(im,:) = [0 1];
opt.volRefs.vol{im} = 'H:\MatlabToolboxes\Surface_plotting\Models\Vol2Surf\Vol_3mm_NiakBoldOutput.nii'; 
opt.volRefs.surf{im} = 'H:\MatlabToolboxes\Surface_plotting\Models\Vol2Surf\Vol_3mm_NiakBoldOutput_surf.mat';

im = 5;
files_in.data{im} = 'E:\MammouthSave\Modularity_PierreCorrections_2017\ICA\Vol4Figures\Left_Net7_1.nii';
opt.coType(im,1) = 14;
opt.contour.show(im,1) = 0;
opt.contour.color(im,:) = [1 0 1];
opt.limits.minmax(im,:) = [0.5 1.5];
opt.limits.over(im,:) = [0 0];
opt.volRefs.vol{im} = 'H:\MatlabToolboxes\Surface_plotting\Models\Vol2Surf\Vol_3mm_NiakBoldOutput.nii'; 
opt.volRefs.surf{im} = 'H:\MatlabToolboxes\Surface_plotting\Models\Vol2Surf\Vol_3mm_NiakBoldOutput_surf.mat';

im = 6;
files_in.data{im} = 'E:\MammouthSave\Modularity_PierreCorrections_2017\ICA\Vol4Figures\Right_Net6_1.nii';
opt.coType(im,1) = 14;
opt.contour.show(im,1) = 0;
opt.contour.color(im,:) = [1 0 1];
opt.limits.minmax(im,:) = [0.5 1.5];
opt.limits.over(im,:) = [0 0];
opt.volRefs.vol{im} = 'H:\MatlabToolboxes\Surface_plotting\Models\Vol2Surf\Vol_3mm_NiakBoldOutput.nii'; 
opt.volRefs.surf{im} = 'H:\MatlabToolboxes\Surface_plotting\Models\Vol2Surf\Vol_3mm_NiakBoldOutput_surf.mat';

%inputs for all files
files_in.ssurf = ({'mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_left.obj','mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_right.obj'});

files_out = '';

opt.NumView = [1 2 3 4];
opt.out.append = '_wsurfed';
opt.out.subfold = 'Surfaced';
opt.seed.show = 0;
opt.rot = [0 0; 0 0; 0 0;0 0];
%opt.seed.color = [1 0 1];
%opt.seed.num = 1;
%opt.seed.file = ''; %enter patht to file

%Other way of inputing stuff for all data at once, might become confusing
%though
%opt.coType = [8 0 10];
%opt.contour.show [0 1 0];
%opt.contour.coler(1,:) = [1 0 1; 1 0 1; 1 0 1];

maxime_visu_surf(files_in, files_out, opt)