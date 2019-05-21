%Launches script that will create effect list. That is, it will find the
%effect for each group and put them in a matrix. The same is done for the
%standard deviation. 
fs = filesep;

rPath = 'F:\Connectivity\glm_connectome_aout_2013\GLM01_complete_nosex\';

tScales = [100];

for ii = 1:length(tScales),
    tNum = num2str(tScales(ii));
    Scales{ii} = strcat('sci',tNum,'_scg',tNum,'_scf',tNum);
end

Groups = {'CB'};
Conds = {'task'};

for ss = 1:length(Scales),
    for gg = 1:length(Groups),
        for cc = 1:length(Conds),
            
            pPath = strcat(rPath,Scales{ss},fs,'individual')
            
            %%%%%%%%
            %find list of files names using  files_in.path
            %%%%%%%%
            tdir = dir(pPath);
            tnam = find(vertcat(tdir.isdir) == 0);
    
            for tt = 1:length(tnam),
                tpnames{tt} = tdir(tnam(tt)).name;
            end
            
            ll = 1;
            for ii = 1:length(tpnames),
                if ~isempty(strfind(tpnames{ii},'CBxxx')),%makes sure this is the file of a participant
                    
                    Name = strcat(pPath,fs,tpnames{ii});
                    load(Name);
                    temp = niak_lvec2mat(tvr_CB.connectome);
                    
                    Comp.mat(:,:,ll) = niak_lvec2mat(tvr_CB.connectome);
                    ll = ll+1;
                end
            end

            Name = strcat(pPath,fs,'CB_tvr_corr_compiled.mat');
            save(Name,'Comp');
            
        end
    end
end

