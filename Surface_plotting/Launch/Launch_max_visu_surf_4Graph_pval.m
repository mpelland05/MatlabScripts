function Launch_max_visu_surf_4Graph_pval(basePath),
%This script will go through all the files of a folder, create a map of
%them and save the map.

ImType = 'Stat';

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

ssurf = niak_read_surf({'mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_left.obj','mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_right.obj'});


%Loop for creating maps%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for pp = 1:length(pnames),
    pnames{pp}
    load(strcat( basePath,pnames{pp} ));
    %Make sure that the data is not 1 or -1
    
    %Find the number of networks
    nNet = max(unique(data));
    
    %if pnames{pp}(1) == 'L',
    %    Opti.NumView = [1 3];
    %elseif pnames{pp}(1) == 'R',
    %    Opti.NumView = [1 3];
    %else
        Opti.NumView = [1 2 3 4];
    %end
    
    if strcmp(ImType,'Stat'), 
        %data(data > .999) = 0.999;
        %data(data < -.999) = -0.999;
        Loc = find(data ~= 0);
        ssign = ((data < 0).*-1) + (data > 0); 
        data(Loc) = abs(log10(abs(data(Loc)))); 
        data = data.*ssign;
        
        Opti.sName = regexprep(pnames{pp},'.mat','');
        Opti.CoType = [2 3];
        %Opti.Limits = [.95 1; -1 -.95];
        Opti.Limits = [3 5; -5 -3];
        
        info = max_visu_surf(data, ssurf, 1, 'no', Opti);
        strcat(pnames{pp},' done')
    else
        Opti.sName = regexprep(pnames{pp},'.mat','');
        Opti.CoType = [5];
        Opti.Limits = [1 nNet+1];
        
        info = max_visu_surf(data, ssurf, 1, 'no', Opti);
        strcat(pnames{pp},' done')
    end
    
    
end

save('OptionsForFigures.mat','Opti');
end

%   clf(info([1 3]))