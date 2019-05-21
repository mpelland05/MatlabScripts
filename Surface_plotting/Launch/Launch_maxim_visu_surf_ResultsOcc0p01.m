%Model script for launching maxime_visu_surf, three files are being put on
%the same surfaced brain, one of them as a purple contour. 
%inputs for each data
clear



im = 1;
files_in.data{im} = 'C:\Users\Maxime\Desktop\Research\Modularity\Added_analyses\Redone_OccBlind_FDR\SummaryUncorrAtoms_0p01.nii';
opt.coType(im,1) = 18;
opt.contour.show(im,1) = 0;
opt.contour.color(im,:) = [1 0 1];
opt.limits.minmax(im,:) = [0.3 4];
opt.limits.over(im,:) = [0 1];
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
  