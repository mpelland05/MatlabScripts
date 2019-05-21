function Launch_max_visu_surf_4ModularityStudy_Basc6(basePath),
%This script will go through all the files of a folder, create a map of
%them and save the map.
%

%Side to Analyze
side = 'l';%or 'l'

%stats or not
stats = 0;

Seeds = 59;

fs = filesep;

%Set default parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if stats,
    Opti.Limits = abs(log10([0.00049 0.0000009]));
    Opti.CoType = 2;
else
    Opti.Limits = [.01 1;-1 -.01];%Opti.Limits = [.01 0.35;-.35 -.01];
    Opti.CoType = [2 3];
end
Opti.Rot = [35 0; -35 0; -45 -15; 45 -15];
Fout = 'Surfed';%Name of output folder



ssurf = niak_read_surf({'mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_left.obj','mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_right.obj'});


if strcmp(side,'r')
    fis.surf='F:\MyStudies\Modularity\Modularity_OC_2016\mask\Occipital\Atoms_rand_OccBASC6_Right_surf.mat';%files_in for surfaacing
    fis.vol='F:\MyStudies\Modularity\Modularity_OC_2016\fmri\region_growing_rand_OccMaskAALetBASC_RL\Atoms_rand_OccBASC6_Right.nii';
    fis.seeds = 1:103;
    Opti.NumView = [2 4];
else
    fis.surf='F:\MyStudies\Modularity\Modularity_OC_2016\mask\Occipital\Atoms_rand_OccBASC6_Left_surf.mat';%files_in for surfaacing
    fis.vol='F:\MyStudies\Modularity\Modularity_OC_2016\fmri\region_growing_rand_OccMaskAALetBASC_RL\Atoms_rand_OccBASC6_Left.nii';
    fis.seeds = 1:101;
    Opti.NumView = [1 3];
end
Opti.seeds_surf = fis.surf;

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

%%%%%
% Prep output dir
%%%%
mkdir(basePath,Fout);
Opti.out = strcat(basePath,fs,Fout);

%%%%%%
%Loop for creating maps%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%
for pp = 1:length(pnames),
    pnames{pp}
    
    %takes the nii volumes and makes a surface out of them
    fis.vol2trans = strcat(basePath,fs,pnames{pp});
    data = max_vol2surf(fis);
    
        lili = Opti.Limits;
        %data(data > .999) = 0.999;
        %data(data < -.999) = -0.999;
        
        %Puts the data on a log scale if p values
        if stats,
            ssign = data > 0; %ssign = ssign - (data < 0);
            data2 = abs(log10(data)).*ssign;
            data2(find(data == 0)) = 0;
            data = data2;
            
            Opti.sName = regexprep(pnames{pp},'.nii','');
        
            info = max_visu_surf(data, ssurf, 1, 'no', Opti);
            strcat(pnames{pp},' done')
        else
            data = ( data.*(data>lili(1,1)) ) + ( data.*(data < lili(2,2)) );%Makes sure you don't see stuff under the limit
            
            Opti.sName = regexprep(pnames{pp},'.nii','');
        
            info = max_visu_surf(data, ssurf, Seeds, 'yes', Opti);
            strcat(pnames{pp},' done')
        end
        
        
        
end