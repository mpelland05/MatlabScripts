%Will launch max_visu_surf repeatedly. This file should include the load of
%ssurf, loading of data and seeds to be plotted. 

%Launch_max_visu_surf_4tvrStudy

'Select output path!!!!'

ssurf = niak_read_surf({'mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_left.obj','mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_right.obj'});
%ssurf = niak_read_surf({'mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_left.obj','mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_right.obj'});


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Rest CB vs Sc FDR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('F:\MyStudies\Modularity\Modularity_OC_2016\fmri\region_growing_rand_OccMaskAALetBASC_RL\SurfecAtoms\Atoms_rand_OccBasc6_RL_surf.mat');

Seedss = [25];

Opti.sName = 'Maskedseeds_';
Opti.CoType = [6];
Opti.Limits = [.001 103];
Opti.Rot = [0 0; 0 0; 0 0; 0 0];

for ii = 1:length(Seedss),
    max_visu_surf(data, ssurf, Seedss(ii), 'no',Opti);
    strcat('Seed number ',num2str(Seedss(ii)),' done')
end
