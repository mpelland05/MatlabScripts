function Launch_max_visu_surf_file(basePath),

%%%%%%%%%Important, this script was never completed%%%%%%%%%%%%

%This script will go through all the files of a folder, create a map of
%them and save the map.

fs = filesep;

%Set default parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Opti.Seeds = 1;
Opti.Rot = [-15 20; 15 20; 180 -30; 180 -30];%[35 0; -35 0; -45 -15; 45 -15];% [15 5; -15 5; 0 -30; 0 -30];

%ssurf = niak_read_surf({'mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_left.obj','mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_right.obj'});
ssurf = niak_read_surf({'Inflated_025_mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_left.obj','Inflated_025_mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_right.obj'});

    fis.seeds = 76;
    Opti.NumView = [1 2];

Opti.seeds_surf = 'F:\MyStudies\Modularity\Modularity_OC_2016\mask\Occipital\Atoms_rand_OccBASC6_Right_surf.mat';%files_in for surfaacing

Fout = 'Surfed';%Name of output folder
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
    load(strcat( basePath,pnames{pp} ));
    
    nNet = max(data);
    %data(find(data ~= 94)) = 0;
    %Find the number of networks

        data(find(data < 5)) = 0; 
        Opti.sName = regexprep(pnames{pp},'.mat','');
        rp = randperm(35);
        ndata = zeros(size(data));
        for ii = 1:35, ndata(find(data == ii+4)) = rp(ii);end
        data = ndata;
        Opti.CoType = [6];
        Opti.Limits = [1 35];
        
        info = max_visu_surf(data, ssurf, 1, 'no', Opti);
        strcat(pnames{pp},' done')

    
 
end
end

%   clf(info([1 3]))