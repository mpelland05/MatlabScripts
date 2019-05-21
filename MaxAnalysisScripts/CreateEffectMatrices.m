%Launches script that will create effect list. That is, it will find the
%effect for each group and put them in a matrix. The same is done for the
%standard deviation. 

rPath = 'G:\Connectivity\glm_connectome_aout_2013\GLM01_complete_nosex\';

tScales = [3:20 50 100 200];

for ii = 1:length(tScales),
    tNum = num2str(tScales(ii));
    Scales{ii} = strcat('sci',tNum,'_scg',tNum,'_scf',tNum);
end

Groups = {'CB' 'LB' 'SC'};
Conds = {'rest' 'task'};

for ss = 1:length(Scales),
    for gg = 1:length(Groups),
        for cc = 1:length(Conds),
            Name = strcat(rPath,Scales{ss},filesep,Conds{cc},'_',Groups{gg},filesep,'glm_',Conds{cc},'_',Groups{gg},'_',Scales{ss},'.mat');
            load(Name);
            Data.(Scales{ss}).(Conds{cc}).Groups{gg}.Effect = SquareAnArray2(eff,tScales(ss));
            Data.(Scales{ss}).(Conds{cc}).Groups{gg}.Std = SquareAnArray2(std_eff,tScales(ss));
        end
    end
    Name = strcat(rPath,filesep,Scales{ss},filesep,'EffectsList.mat');
    save(Name,'Data');
end

