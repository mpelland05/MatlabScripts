%Will launch max_visu_surf repeatedly. This file should include the load of
%ssurf, loading of data and seeds to be plotted. 

%Launch_max_visu_surf_4tvrStudy

'Select output path!!!!'

ssurf = niak_read_surf({'Inflated_035_mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_left.obj','Inflated_035_mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_right.obj'});
%ssurf = niak_read_surf({'mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_left.obj','mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_right.obj'});


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Rest CB vs Sc FDR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('F:\Connectivity\glm_connectome_aout_2013\Discussion\Dec2013\V11\Vols_whole_brain_q05\ss2\T_part96_surf.mat');

Seedss = [96];

Opti.sName = 'CBvsSC_Rest_';
Opti.CoType = [2 3];
Opti.Limits = [4 7; -7 -4];
Opti.Rot = [15 5; -15 5; 0 -30; 0 -30];

for ii = 1:length(Seedss),
    max_visu_surf(data, ssurf, Seedss(ii), 'yes',Opti);
    strcat('Seed number ',num2str(Seedss(ii)),' done')
end
