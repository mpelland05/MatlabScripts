%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Rest CB vs Sc Disc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('F:\Connectivity\glm_connectome_aout_2013\Discussion\Dec2013\V11\Vols_whole_brain_q05\ss2\Percent_disc_surf.mat');

ssurf = niak_read_surf({'Inflated_035_mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_left.obj','Inflated_035_mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_right.obj'});
%ssurf = niak_read_surf({'mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_left.obj','mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_right.obj'});

Seedss = 1;

Opti.sName = 'CBvsSC_TVR_Disc_';
Opti.CoType = [2];
Opti.Limits = [0 .05];

for ii = 1:length(Seedss),
    max_visu_surf(data, ssurf, Seedss(ii), 'no',Opti);
    strcat('Seed number ',num2str(Seedss(ii)),' done')
end