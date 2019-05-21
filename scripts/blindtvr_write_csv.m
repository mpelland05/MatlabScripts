clear all

data.dir_raw                =   '/home/mpelland/database/blindtvr/';
data.dir_models             =   'models/';
data.name_csv_group         =   'blind_model_group';

data.group      = {'CBxxx','LBxxx','SCxxx'};
data.subs_CB    = {'VDAlCh','VDAnBe','VDBeMe','VDDiCe','VDFrCo','VDLL','VDMaLa','VDMaDu','VDMoBe','VDNaTe','VDSePo','VDSoSa','VDYP','VDYvLa'}; % n = 14                                     
data.subs_LB    = {'VDCaMa','VDDeBe','VDGiCo','VDJoBi','VDJoBo','VDJoGa','VDLiJo','VDLiVe','VDMoLa','VDRaDe','VDSeBe'}; % n = 11
data.subs_SC    = {'VDCJ','VDChJa','VDClDe','VDGeAl','VDJM','VDJeRe','VDJoFr','VDKaFo','VDLALH','VDMaSa','VDNiLe','VDNiMi','VDOL','VDPG','VDSC','VDSG','VDTJ'}; % n = 17


%%%%%%%%%%%%%%
%Column labels
%%%%%%%%%%%%%%%
data.covariates_group_names       	=   {'SelCBSC','SelLBSC','SelCBLB','SelCB','SelLB','SelSC','CBvsSC','LBvsSC','CBvsLB','age','sex','blindness','FDrest','FDtask'};
opt.labels_y = data.covariates_group_names;

%%%%%%%%%%%%%%
%Row labels
%%%%%%%%%%%%
ll = 1; %incrementation variable.
for n1 = 1:length(data.subs_CB)
    data.subs_names{ll} = strcat(data.group{1},data.subs_CB{n1});
    ll = ll +1;
end

for n1 = 1:length(data.subs_LB)
    data.subs_names{ll} = strcat(data.group{2},data.subs_LB{n1});
    ll = ll +1;
end

for n1 = 1:length(data.subs_SC)
    data.subs_names{ll} = strcat(data.group{3},data.subs_SC{n1});
    ll = ll +1;
end

data.covariates_group_subs = data.subs_names; 
opt.labels_x = data.covariates_group_subs;


%%%%%%%%%%%%%%%%%
%Covariate values
%%%%%%%%%%%%%%%%%
data.covariates_group_values(:,1)   =   [ones(14,1);zeros(11,1);ones(17,1)]; 
data.covariates_group_values(:,2)   =   [zeros(14,1);ones(11,1);ones(17,1)]; 
data.covariates_group_values(:,3)   =   [ones(14,1);ones(11,1);zeros(17,1)];                                    
data.covariates_group_values(:,4)   =   [ones(14,1);zeros(28,1)];  
data.covariates_group_values(:,5)   =   [zeros(14,1);ones(11,1);zeros(17,1)];  
data.covariates_group_values(:,6)   =   [zeros(25,1);ones(17,1)];  
data.covariates_group_values(:,7)   =   [ones(14,1);zeros(28,1)];  
data.covariates_group_values(:,8)   =   [zeros(14,1);ones(11,1);zeros(17,1)];                                    
data.covariates_group_values(:,9)   =   [ones(14,1);zeros(28,1)];                                    
data.covariates_group_values(:,10)   =   [40;61;56;26;54;38;39;27;56;32;48;31;43;46;...
                                        55;53;53;60;42;46;48;53;58;48;55
                                        56;30;28;30;60;25;34;40;23;60;55;56;30;34;51;25;29]; 
data.covariates_group_values(:,11)   =   [0;0;0;0;0;0;0;1;1;1;0;1;0;0;...    % F = 1, M = 1
                                        1;1;0;1;1;1;1;1;1;0;0;...
                                        1;1;1;1;1;0;0;0;1;1;1;0;0;0;1;0;0]; 
data.covariates_group_values(:,12)   =   [ones(14,1);ones(11,1).*2;ones(17,1).*3]; 

data.covariates_group_values(:,13) = [0.09;0.24;0.19;0.14;0.25;0.12;0.13;0.11;0.29;0.17;0.24;0.12;0.20;0.25;...
                        0.17;0.22;0.12;0.13;0.20;0.23;0.17;0.10;0.25;0.22;0.15;...
                        0.08;0.13;0.08;0.08;0.10;0.17;0.09;0.14;0.08;0.19;0.19;0.17;0.13;0.16;0.15;0.20;0.09];

data.covariates_group_values(:,14) = [0.15;0.19;0.14;0.18;0.13;0.12;0.18;0.09;0.19;0.14;0.17;0.12;0.16;0.19;...
			0.17;0.14;0.15;0.15;0.09;0.13;0.15;0.09;0.22;0.2;0.21;...
			0.08;0.15;0.09;0.07;0.12;0.17;0.1;0.15;0.09;0.1;0.16;0.13;0.11;0.12;0.19;0.16;0.07];

%%%%%%%%%%%
% write group csv
%%%%%%%%%%%
opt.precision = 2;
niak_write_csv(strcat(data.dir_raw,data.dir_models,data.name_csv_group,'.csv'),data.covariates_group_values,opt);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------------------------------------------Single subjects csv. --------------------------------------------------------------
clear opt;

%%%%%%%%%%%%%%
%Column labels
%%%%%%%%%%%%%%%
ColLabels = {'TVR'};
opt.labels_y = ColLabels;

%%%%%%%%%%%%%%
%Row labels
%%%%%%%%%%%%%%%
RowLabels = {'rest_run' 'task_run'};
opt.labels_x = RowLabels;

%%%%%%%%%%%%%%%%%
%Covariate values
%%%%%%%%%%%%%%%%%
CovaVal = zeros(2,1);
CovaVal(2,1) = 1; 
%CovaVal(1,1) = -1; %code rest as -1

%%%%%%%%%%%
% write subject csv
%%%%%%%%%%%
opt.precision = 2;
for ii = 1:length(data.subs_names),
    Sname = strcat(data.dir_raw,data.dir_models,data.covariates_group_subs{ii},'.csv');
    niak_write_csv(Sname,CovaVal,opt);
end
