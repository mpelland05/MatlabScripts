%function Launch_max_visu_surf_GroupConsensusModularity(basePath),
%This script will go through all the files of a folder, create a map of
%them and save the map.

fs = filesep;

file2surf{1} = 'C:\Users\Maxime\Desktop\FigureMakingScripts\VolumesGroups\Whole\Left\stability_group_CBxxx\Scale_8\Consensus.nii';
file2surf{2} = 'C:\Users\Maxime\Desktop\FigureMakingScripts\VolumesGroups\Whole\Left\stability_group_SCxxx\Scale_8\Consensus.nii';
file2surf{3} = 'C:\Users\Maxime\Desktop\FigureMakingScripts\VolumesGroups\Whole\Right\stability_group_CBxxx\Scale_8\Consensus.nii';
file2surf{4} = 'C:\Users\Maxime\Desktop\FigureMakingScripts\VolumesGroups\Whole\Right\stability_group_SCxxx\Scale_8\Consensus.nii';

%Set default visu%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Opti.Seeds = 1;
Opti.Rot = [15 5; -15 5; 0 -30; 0 -30];% [15 5; -15 5; 0 -30; 0 -30];

ssurf = niak_read_surf({'mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_left.obj','mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_right.obj'});

%Set default vol2surf%%%%%%%%%%%%%%%%%%%%%55
v2surf.surf='C:\Users\Maxime\Desktop\FigureMakingScripts\Vol4NiaklessSurface_surf.mat';%files_in for surfaacing
v2surf.vol= 'C:\Users\Maxime\Desktop\FigureMakingScripts\Vol4NiaklessSurface.nii';
v2surf.seeds = 'all';
v2surf.NumView = [1 2 3 4];

%Default that rarely need to be set %%%%%%%%%%%%%%
Opti.seeds_surf = v2surf.seeds;

Fout = 'Surfed2';%Name of output folder



%Loop for creating maps%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for pp = 1:length(file2surf),
    %load(strcat( basePath,pnames{pp} ));
    
    v2surf.vol2trans = file2surf{pp};
    data = max_vol2surf(v2surf);
    
	[pat,nam,eee] = fileparts(file2surf{pp});
    	mkdir(pat,Fout);

        Opti.sName = nam;
        Opti.CoType = [6];
        Opti.Limits = [0.1 max(data(:))];

        Opti.out = strcat(pat,fs,Fout);

        info = max_visu_surf(data, ssurf, 1, 'no', Opti);
        strcat(file2surf{pp},' done')

    
 
end
%end

%   clf(info([1 3]))