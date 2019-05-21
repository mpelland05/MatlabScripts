%function Launch_max_visu_surf_GroupConsensusModularity(basePath),
%This script will go through all the files of a folder, create a map of
%them and save the map.

fs = filesep;

fold{1} = 'C:\Users\Maxime\Desktop\Research\OHBM2018\BascBootstrap\ResultsBoot\OccLeft\Surfed';               mask{1} = 'C:\Users\Maxime\Desktop\Research\OHBM2018\FigureMakingScripts\Atoms_rand_OccBASC6_Left_surf.mat';
fold{2} = 'C:\Users\Maxime\Desktop\Research\OHBM2018\BascBootstrap\ResultsBoot\OccRight\Surfaced';            mask{2} = 'C:\Users\Maxime\Desktop\Research\OHBM2018\FigureMakingScripts\Atoms_rand_OccBASC6_Right_surf.mat';
fold{3} = 'C:\Users\Maxime\Desktop\Research\OHBM2018\BascBootstrap\ResultsBoot\WholeLeft\Surfed';             mask{3} = 'C:\Users\Maxime\Desktop\Research\OHBM2018\FigureMakingScripts\Atoms_randWhole_BASC6only_Left_surf.mat';
fold{4} = 'C:\Users\Maxime\Desktop\Research\OHBM2018\BascBootstrap\ResultsBoot\WholeLeft\Averaged\Surfed';    mask{4} = 'C:\Users\Maxime\Desktop\Research\OHBM2018\FigureMakingScripts\Atoms_randWhole_BASC6only_Left_surf.mat';
fold{5} = 'C:\Users\Maxime\Desktop\Research\OHBM2018\BascBootstrap\ResultsBoot\WholeRight\Surfed';            mask{5} = 'C:\Users\Maxime\Desktop\Research\OHBM2018\FigureMakingScripts\Atoms_randWhole_BASC6only_Rigth_surf.mat';
fold{6} = 'C:\Users\Maxime\Desktop\Research\OHBM2018\BascBootstrap\ResultsBoot\WholeRight\Averaged\Surfed';   mask{6} = 'C:\Users\Maxime\Desktop\Research\OHBM2018\FigureMakingScripts\Atoms_randWhole_BASC6only_Rigth_surf.mat';
fold{7} = 'C:\Users\Maxime\Desktop\Research\OHBM2018\BascBootstrap\ResultsBoot\WholeLeftnoOcc\Surfed'; mask{7} = 'C:\Users\Maxime\Desktop\Research\OHBM2018\FigureMakingScripts\Atoms_randWhole_BASC6only_Left_Maskedwith_Atoms_rand_OccBASC6_Left_surf.mat';
fold{8} = 'C:\Users\Maxime\Desktop\Research\OHBM2018\BascBootstrap\ResultsBoot\WholeRightnoOcc\Surfed'; mask{8} = 'C:\Users\Maxime\Desktop\Research\OHBM2018\FigureMakingScripts\Atoms_randWhole_BASC6only_Right_Maskedwith_Atoms_rand_OccBASC6_Right_surf.mat';

%Set default visu%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Opti.Seeds = 1;
Opti.Rot = [15 5; -15 5; 0 -30; 0 -30];% [15 5; -15 5; 0 -30; 0 -30];

ssurf = niak_read_surf({'mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_left.obj','mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_right.obj'});

%Default that rarely need to be set %%%%%%%%%%%%%%
Opti.seeds_surf = 'all';
Fout = 'Surfed';%Name of output folder

for ff = 1:length(fold),

%%%%%%%%%
% Pierre's way of getting rid of folders or files
%%%%%%%%%
dir_files = dir(fold{ff});
mask_dir = [dir_files.isdir];
list_all = {dir_files.name};
mask_dot = ismember(list_all,{'.','..'});
dir_files = dir_files(~mask_dot);
mask_dir = mask_dir(~mask_dot);
list_all = list_all(~mask_dot);
pnames = list_all(~mask_dir);
list_dir = list_all(mask_dir);

%Load mask
tmask = load(mask{ff});
locm = find(tmask.data == 0);

%Loop for creating maps%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for pp = 1:length(pnames),
    
	load(strcat(fold{ff},fs,pnames{pp}));
        data = 1-data;
        lo = find(data < 0.5);
        data(lo) = 0.51;	
        data(locm) = 0;

    	mkdir(fold{ff},Fout);

        Opti.sName = pnames{pp}(1:end-4);
        Opti.CoType = [2];
        Opti.Limits = [.5 1];

        Opti.out = strcat(fold{ff},fs,Fout)

        info = max_visu_surf(data, ssurf, 1, 'no', Opti);
        strcat(pnames{pp},' done')
   
end
end
