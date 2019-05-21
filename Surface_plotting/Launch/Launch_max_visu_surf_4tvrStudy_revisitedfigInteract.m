%Will launch max_visu_surf repeatedly. This file should include the load of
%ssurf, loading of data and seeds to be plotted. 

%Launch_max_visu_surf_4tvrStudy

'Select output path!!!!'

ssurf = niak_read_surf({'Inflated_035_mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_left.obj','Inflated_035_mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_right.obj'});
%ssurf = niak_read_surf({'mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_left.obj','mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_right.obj'});


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Rest CB vs Sc FDR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('C:\Users\Maxime Pelland\Desktop\matrices\surf_figure3.mat');

Seedss = [76];

Opti.sName = 'CBvsSC_Rest_';
Opti.CoType = [2 3];
Opti.Limits = [-3 -2; 2 3];
Opti.Rot = [0 0; 0 0; 0 0; 0 0];

for ii = 1:length(Seedss),
    max_visu_surf(data, ssurf, Seedss(ii), 'yes',Opti);
    strcat('Seed number ',num2str(Seedss(ii)),' done')
end
