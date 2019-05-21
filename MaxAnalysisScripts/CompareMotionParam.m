%This script takes all the names in the directory and goes in the relevant
%folder to obtain motion parameters. Then, it does the average of the
%absolute value of movement for each participants. Note that if
%participants have more than one run, you have to hard code that into the
%script. The output is a .mat that can readily be writtent to a .xls file
%(until xls is implemented in octave). 
files_in.path = '/home/mpelland/database/blindtvr/fmri/fmri_preprocess_01/intermediate';
tdir = dir(files_in.path);
tnam = find(vertcat(tdir.isdir));

fs = filesep;

for tt = tnam(3:length(tnam))',
    tpnames{tt-2} = tdir(tt).name;
end


Results.Matrix = zeros(length(tpnames),13); %Results matrix of #participants x group + conditions
Results.Legend = {'Rows are Participant. Colums are: Group, 3 rotations of Cond1, 3 translations of Cond1, 3 rotations of Cond2, 3 translations of Cond2'};

for ii = 1:length(tpnames),
    temp = strcat(files_in.path,fs,tpnames{ii},fs,'motion_correction',fs,'motion_parameters_',tpnames{ii},'_rest_run.mat');
    load(temp);
    [rot,tsl] = niak_transf2param(transf);
    
    %rot = rot - repmat(mean(rot,2),1,length(rot)); %remove mean of rot to make sure no super high values will be obtained. 
    %tsl = tsl - repmat(mean(tsl,2),1,length(tsl)); %same but for tsl
    
    rot = diff(rot,1,2);
    tsl = diff(tsl,1,2);
    
    Results.Matrix(ii,2:7) = [mean(abs(rot),2)' mean(abs(tsl),2)'];
    
    clear transf;
    
    %second conditon
    temp = strcat(files_in.path,fs,tpnames{ii},fs,'motion_correction',fs,'motion_parameters_',tpnames{ii},'_task_run.mat');
    load(temp);
    [rot,tsl] = niak_transf2param(transf);
    
    %rot = rot - repmat(mean(rot,2),1,length(rot)); %remove mean of rot to make sure no super high values will be obtained. 
    %tsl = tsl - repmat(mean(tsl,2),1,length(tsl)); %same but for tsl
    
    rot = diff(rot,1,2);
    tsl = diff(tsl,1,2);
    
    Results.Matrix(ii,8:13) = [mean(abs(rot),2)' mean(abs(tsl),2)'];
      
end

Results.Matrix(:,1) = [ones(1,14) ones(1,11).*2 ones(1,17).*3];

sname = strcat(files_in.path,fs,'MaximeSummary_Motion.mat');
save(sname,'Results')