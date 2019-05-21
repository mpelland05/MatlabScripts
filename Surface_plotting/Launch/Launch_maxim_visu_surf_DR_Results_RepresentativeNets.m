%Model script for launching maxime_visu_surf, three files are being put on
%the same surfaced brain, one of them as a purple contour. 
%inputs for each data
clear

gpatl = 'E:\MammouthSave\Modularity_PierreCorrections_2017\Results\BASCRestOnlyCBSCMixedRandWholeMaskBasc6Only_Left\OverlapMapsBasedOnBestNetworks_SConly\';
gpatr = 'E:\MammouthSave\Modularity_PierreCorrections_2017\Results\BASCRestOnlyCBSCMixedRandWholeMaskBasc6Only_Right\OverlapMapsBasedOnBestNetworks_SConly\';

netl = [7 3; 5 3;10 4; 6 1;17 8;9 6;7 7];
netr = [8 3; 8 6;16 16; 11 9;11 10;8 5;5 5];

grp = {'' '_CBxxx' '_SCxxx'};

for nn = 1:size(netl,1)
    for gg = 1:length(grp)

        fnl= strcat(num2str(netl(nn,1)),'_',num2str(netl(nn,2)),grp{gg},'.nii');
        fnr= strcat(num2str(netr(nn,1)),'_',num2str(netr(nn,2)),grp{gg},'.nii');
        
im = 1;
files_in.data{im} = strcat(gpatl,'OverlapIndNets_withGrpNet_',fnl);%-------------------------------------------------------------------------
opt.coType(im,1) = 2;
opt.contour.show(im,1) = 0;
opt.contour.color(im,:) = [1 0 1];
opt.limits.minmax(im,:) = [0.3 1];
opt.limits.over(im,:) = [0 1];
opt.volRefs.vol{im} = 'H:\MatlabToolboxes\Surface_plotting\Models\Vol2Surf\Vol_3mm_NiakBoldOutput.nii'; 
opt.volRefs.surf{im} = 'H:\MatlabToolboxes\Surface_plotting\Models\Vol2Surf\Vol_3mm_NiakBoldOutput_surf.mat';

im = 2;
files_in.data{im} = strcat(gpatr,'OverlapIndNets_withGrpNet_',fnr);%--------------------------------------------------------------------
opt.coType(im,1) = 2;
opt.contour.show(im,1) = 0;
opt.contour.color(im,:) = [1 0 1];
opt.limits.minmax(im,:) = [0.3 1];
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
    end
end