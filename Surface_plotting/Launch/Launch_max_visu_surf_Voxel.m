function Launch_max_visu_surf_Voxel(basePath),
%This script will go through all the files of a folder, create a map of
%them and save the map.

fs = filesep;

%Set default parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Opti.Seeds = 1;
Opti.Rot = [5 25; 5 25; 0 -30; 0 -30];% [15 5; -15 5; 0 -30; 0 -30];

ssurf = niak_read_surf({'Inflated_025_mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_left.obj','Inflated_025_mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_right.obj'});

    Opti.NumView = [1 2 3 4];

%Opti.seeds_surf = fis.surf;

Fout = 'Surfed_thresh';%Name of output folder
mkdir(basePath,Fout);
Opti.out = strcat(basePath,fs,Fout);

%%%%%%%%%
% Pierre's way of getting rid of folders or files
%%%%%%%%%
dir_files = dir(basePath);
mask_dir = [dir_files.isdir];
list_all = {dir_files.name};
mask_dot = ismember(list_all,{'.','..'});
dir_files = dir_files(~mask_dot);
mask_dir = mask_dir(~mask_dot);
list_all = list_all(~mask_dot);
pnames = list_all(~mask_dir);
list_dir = list_all(mask_dir);


%Loop for creating maps%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for pp = 1:length(pnames),
    pnames{pp}
    %load(strcat( basePath,pnames{pp} ));
    
    data = load(strcat(basePath,fs,pnames{pp}));
    data = data.data;
    data(find(data < 2.05)) = 0;
    %Find the number of networks
    max(data)

    
        Opti.sName = regexprep(pnames{pp},'.mat','');
        Opti.CoType = [2 3];
        Opti.Limits = [0.01 5; -5 -0.01];
        Opti.seeds_surf = 'F:\Connectivity\Discussion\Dec2013\SubmissionNI\NewAnalyses\Voxelwise\AudMask\Volconj_aal_basc100_surf.mat';
        info = max_visu_surf(data, ssurf, 2, 'yes', Opti);
        strcat(pnames{pp},' done')

    
 
end
end

%   clf(info([1 3]))