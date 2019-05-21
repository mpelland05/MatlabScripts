function Launch_max_visu_surf_4OverlapThresh(basePath),
%This script will go through all the files of a folder, create a map of
%them and save the map.

fs = filesep;

cd(basePath);

%Get file names %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tdir = dir(basePath);
for tt = 3:length(tdir),
    pnames{tt-2} = tdir(tt).name;
end

%Set default parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Seeds = 1;
Opti.Rot = [35 0; -35 0; -30 0; 30 0];
Opti.NumView = [1 2 3 4];
Opti.Limits = [3 10; -10 -3];

ssurf = niak_read_surf({'mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_left.obj','mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_right.obj'});


%Loop for creating maps%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for pp = 1:length(pnames),
    pnames{pp}
    load(strcat( basePath,pnames{pp} ));
   
    %Remove values which are below the miminums
    loc = find(data < 0);
    temp = data(loc); 
    tloc = find(temp > Opti.Limits(2,2));
    temp(tloc) = 0;
    data(loc) = temp;
    
    loc = find(data > 0);
    temp = data(loc); 
    tloc = find(temp < Opti.Limits(1,1));
    temp(tloc) = 0;
    data(loc) = temp;    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
        Opti.sName = regexprep(pnames{pp},'.mat','');
        Opti.CoType = [2 3];
        
        info = max_visu_surf(data, ssurf, 1, 'no', Opti);
        strcat(pnames{pp},' done')
    
end

save('OptionsForFigures.mat','Opti');
end

%   clf(info([1 3]))