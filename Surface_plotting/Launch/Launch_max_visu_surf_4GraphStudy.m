function Launch_max_visu_surf_4ModularityStudy(basePath),
%This script will go through all the files of a folder, create a map of
%them and save the map.

%basePath = 'F:\GraphAnalysis\results\Occ_X_90\Smooth\MST\sci190_scg190_scf190\P005\Surf\';
basePath = 'F:\GraphAnalysis\results\Occ_X_90\NoSmooth\Mst\sci202_scg202_scf202\P005\Surf\';

addpath(genpath('F:\MatlabToolboxes\Surface_plotting'))

fs = filesep;

%Get file names %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tdir = dir(basePath);
for tt = 3:length(tdir),
    pnames{tt-2} = tdir(tt).name;
end

%Set default parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Seeds = 1;
Opti.Rot = [35 0; -35 0; -30 0; 30 0];

Opti.NumView = [1 2 3 4];

ssurf = niak_read_surf({'mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_left.obj','mni_icbm152_t1_tal_nlin_sym_09a_surface_mid_right.obj'});


%Loop for creating maps%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for pp = 1:length(pnames),

    load(strcat( basePath,pnames{pp} ));
    
    
    %Load file for other participants to have a the same maximum
    if ~isempty(strfind(pnames{pp},'CB')),
        bb = load(strcat( basePath , regexprep(pnames{pp},'CB','SC' )));
    end
    if ~isempty(strfind(pnames{pp},'SC')),
        bb = load(strcat( basePath , regexprep(pnames{pp},'SC','CB' )));
    end
    
    
    %Find the number of networks
    temp = regexprep(pnames{pp},'_CB','');temp = regexprep(pnames{pp},'_SC','');
    temp = regexprep(temp,'_',' ');
    temp = regexprep(temp,'.mat','');
    nNet = sscanf(temp,'%*s %d %*s %*s %*s' ,[1 Inf]);      %Looks in the name to fin d
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ~isempty(strfind(pnames{pp},'CB')) | ~isempty(strfind(pnames{pp},'SC')), 
        'new'
        Opti.sName = regexprep(pnames{pp},'.mat','');
        Opti.CoType = 2;
        
        %Find limits
        if max((cat(1,data,bb.data))) > 1,
            maxi = round(max(cat(1,data,bb.data)));
            Opti.Limits = sort([0.1 maxi]);
            data(data > maxi) = maxi-0.1;
            data(data == 0) = 0.1;
        else
            maxi = max(cat(1,data,bb.data))
            mini = min(cat(1,data,bb.data));
            data(data > maxi) = maxi-( maxi.*.001 );
            data(data == 0) = 0+mini.*.001;
            Opti.Limits = sort([min(data) maxi])
        end
        if sum(Opti.Limits) == 0, Opti.Limits = [.1 1];end
                
        info = max_visu_surf(data, ssurf, 1, 'no', Opti);
        strcat(pnames{pp},' done')
        
        %Save file with limits in them
        maxistr = strcat('The_limits_for_this_figures_are:_',num2str(Opti.Limits(1)),'_and_',num2str(Opti.Limits(2)) );
        save(strcat(regexprep(pnames{pp},'.mat',''),'Limits.mat' ),'maxistr');
    else
        'new_'
        Opti.sName = regexprep(pnames{pp},'.mat','');
        Opti.CoType = [2 3];
        Opti.Limits = [2 8; -8 -2];
        
        data(data > Opti.Limits(1,2)) = Opti.Limits(1,2)- 0.1;
        data(data < Opti.Limits(2,1)) = Opti.Limits(2,1)+ 0.1;
        
        info = max_visu_surf(data, ssurf, 1, 'no', Opti);
        strcat(pnames{pp},' done')
        
        %Save file with limits in them
        maxistr = strcat('The_limits_for_this_figures_are:_',num2str(Opti.Limits(1,1)),'_and_',num2str(Opti.Limits(1,2)) );
        save(strcat(regexprep(pnames{pp},'.mat',''),'Limits.mat' ),'maxistr');
    end
    
 
end
end

%   clf(info([1 3]))