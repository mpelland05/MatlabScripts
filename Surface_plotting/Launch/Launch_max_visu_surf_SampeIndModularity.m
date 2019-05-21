%function Launch_max_visu_surf_GroupConsensusModularity(basePath),
%This script will go through all the files of a folder, create a map of
%them and save the map.

fs = filesep;

file2surf{1} = 'C:\Users\Maxime\Desktop\OHBM2018\IndividualExamples\brain_partition_consensus_ind_SCxxxVDMaSa_sci8_scf8_surf.mat';
file2surf{2} = 'C:\Users\Maxime\Desktop\OHBM2018\IndividualExamples\brain_partition_consensus_ind_SCxxxVDMaSa_sci22_scf22_surf.mat';
file2surf{3} = 'C:\Users\Maxime\Desktop\OHBM2018\IndividualExamples\brain_partition_consensus_ind_SCxxxVDOL_sci8_scf8_surf.mat';
file2surf{4} = 'C:\Users\Maxime\Desktop\OHBM2018\IndividualExamples\brain_partition_consensus_ind_SCxxxVDOL_sci22_scf22_surf.mat';


%Set default visu%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Opti.Seeds = 1;
Opti.Rot = [15 5; -15 5; 0 -30; 0 -30];% [15 5; -15 5; 0 -30; 0 -30];

ssurf = niak_read_surf({'mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_left.obj','mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_right.obj'});

%Default that rarely need to be set %%%%%%%%%%%%%%
Opti.seeds_surf = 'all';

Fout = 'Surfed';%Name of output folder


ll=0
if ll ==1,
%Loop for creating maps%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for pp = 1:length(file2surf),
    %load(strcat( basePath,pnames{pp} ));
    
    	load(file2surf{pp});    
        [pat,nam,eee] = fileparts(file2surf{pp});
    	mkdir(pat,Fout);

        Opti.sName = nam;
        Opti.CoType = [6];
        Opti.Limits = [0.1 max(data(:))];

        Opti.out = strcat(pat,fs,Fout);

        info = max_visu_surf(data, ssurf, 1, 'no', Opti);
        strcat(file2surf{pp},' done')
end
end

aa = load(file2surf{2});bb = load(file2surf{4});
data = (aa.data == 15) + (2.*(bb.data == 14));

%Loop for creating maps%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for pp = 1,
    %load(strcat( basePath,pnames{pp} ));
    
        [pat,nam,eee] = fileparts(file2surf{2});
    	mkdir(pat,Fout);

        Opti.sName = 'Comp22';
        Opti.CoType = [7];
        Opti.Limits = [0 3];

        Opti.out = strcat(pat,fs,Fout);

        info = max_visu_surf(data, ssurf, 1, 'no', Opti);
        strcat(file2surf{pp},' done')
end

%14 (ol22)
%15 (masa22)

%7-8(ol8)
%4 (masa8)

