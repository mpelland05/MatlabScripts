%Will launch max_visu_surf repeatedly. This file should include the load of
%ssurf, loading of data and seeds to be plotted. 

Seedss = [96 40 65 88 21 80 84];

%ssurf = niak_read_surf({'mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_left.obj','mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_right.obj'});
ssurf = niak_read_surf({'Inflated_025_mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_left.obj','Inflated_025_mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_right.obj'});

Opti.sName = 'CBvsSC_tvr_';
Opti.CoType = [2 3];
Opti.Limits = [2 5; -5 -2];
Opti.Rot = [25 0; -25 0; 0 0; 0 0];


for ii = 1:length(Seedss),
    max_visu_surf(data, ssurf, Seedss(ii), 'yes',Opti);
    strcat('Seed number ',num2str(Seedss(ii)),' done')
end