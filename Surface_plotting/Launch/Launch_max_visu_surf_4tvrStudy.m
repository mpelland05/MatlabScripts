%Will launch max_visu_surf repeatedly. This file should include the load of
%ssurf, loading of data and seeds to be plotted. 

%Launch_max_visu_surf_4tvrStudy

'Select output path!!!!'

ssurf = niak_read_surf({'Inflated_035_mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_left.obj','Inflated_035_mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_right.obj'});
%ssurf = niak_read_surf({'mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_left.obj','mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_right.obj'});


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Rest CB vs Sc FDR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('F:\Connectivity\glm_connectome_aout_2013\Surface_plotting\Surfaces\bin_fdr_rest_CBvsSC_100_surf.mat');

Seedss = [21 96 99 82 88 26 80 40 62 65];

Opti.sName = 'CBvsSC_Rest_';
Opti.CoType = [2 3];
Opti.Limits = [2 5; -5 -2];
Opti.Rot = [15 5; -15 5; 0 -30; 0 -30];

for ii = 1:length(Seedss),
    max_visu_surf(data, ssurf, Seedss(ii), 'yes',Opti);
    strcat('Seed number ',num2str(Seedss(ii)),' done')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TVR CB vs Sc FDR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('F:\Connectivity\glm_connectome_aout_2013\Surface_plotting\Surfaces\bin_fdr_tvr_CBvsSC_100_surf.mat');

Seedss = [21 70 64 33 15 96];

Opti.sName = 'CBvsSC_tvr_';

for ii = 1:length(Seedss),
    max_visu_surf(data, ssurf, Seedss(ii), 'yes',Opti);
    strcat('Seed number ',num2str(Seedss(ii)),' done')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TVR CB vs Sc ttest
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('F:\Connectivity\glm_connectome_aout_2013\Surface_plotting\Surfaces\bin_ttest_tvr_CBvsSC_100_surf.mat');

Seedss = [76];

Opti.sName = 'CBvsSC_tvr_Aud_';
Opti.CoType = [2];
Opti.Limits = [2.05 3];

for ii = 1:length(Seedss),
    max_visu_surf(data, ssurf, Seedss(ii), 'yes',Opti);
    strcat('Seed number ',num2str(Seedss(ii)),' done')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Rest CB vs Sc Disc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('F:\Connectivity\glm_connectome_aout_2013\Surface_plotting\Surfaces\bin_perc_disc_rest_CBvsSC_100_surf.mat');

Seedss = 1;

Opti.sName = 'CBvsSC_Rest_Disc_';
Opti.CoType = [2];
Opti.Limits = [0 .1];

for ii = 1:length(Seedss),
    max_visu_surf(data, ssurf, Seedss(ii), 'no',Opti);
    strcat('Seed number ',num2str(Seedss(ii)),' done')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Rest CB vs Sc Disc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('F:\Connectivity\glm_connectome_aout_2013\Surface_plotting\Surfaces\bin_perc_disc_tvr_CBvsSC_100_surf.mat');

Opti.sName = 'CBvsSC_tvr_Disc_';

for ii = 1:length(Seedss),
    max_visu_surf(data, ssurf, Seedss(ii), 'no',Opti);
    strcat('Seed number ',num2str(Seedss(ii)),' done')
end