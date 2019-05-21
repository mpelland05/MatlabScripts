function Launch_max_visu_surf_4Graph_pval(basePath),
%This script will go through all the files of a folder, create a map of
%them and save the map.

ImType = 'Mea';

fs = filesep;

cd(basePath);

Mes = {'Betweenness' 'Closeness' 'Clustering' 'Degrees' 'Efficiency' 'SizeComp'};
MesLim = [7 400; 0.65 1.4; 0.2 0.55; 5 50; 0.23 0.63; 0.1 1];

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
        Opti.NumView = [2 4];
    %else
    %    Opti.NumView = [1 2 3 4];
    %end
    
    
        for ii = 1:length(Mes),
           if ~isempty(strfind( pnames{pp}, Mes{ii} )),
               Loc = ii;
           end
        end
        Opti.sName = regexprep(pnames{pp},'.mat','');
        Opti.CoType = [2];
        Opti.Limits = [MesLim(Loc,:)];
        
        info = max_visu_surf(data, ssurf, 1, 'no', Opti);
        strcat(pnames{pp},' done')
   
    
 
end
end

%   clf(info([1 3]))