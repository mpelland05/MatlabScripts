%This script will take resuls niak_GLM_connectome (ore whatever I used)
%and make a series of graphs for the interaction note that
%CreateInteractionGraph must also be modified

rCB = load('F:\Connectivity\glm_connectome_Taskless\BS101\sci2_scg2_scf2\rest_CB\glm_rest_CB_sci2_scg2_scf2.mat');
tCB = load('F:\Connectivity\glm_connectome_Taskless\BS101\sci2_scg2_scf2\task_CB\glm_task_CB_sci2_scg2_scf2.mat');
rSC = load('F:\Connectivity\glm_connectome_Taskless\BS101\sci2_scg2_scf2\rest_SC\glm_rest_SC_sci2_scg2_scf2.mat');
tSC = load('F:\Connectivity\glm_connectome_Taskless\BS101\sci2_scg2_scf2\task_SC\glm_task_SC_sci2_scg2_scf2.mat');

Data.sci100_scg100_scf100.rest.Groups{1}.Effect = niak_lvec2mat(rCB.eff);
Data.sci100_scg100_scf100.rest.Groups{1}.Std = niak_lvec2mat(rCB.std_eff);

Data.sci100_scg100_scf100.task.Groups{1}.Effect = niak_lvec2mat(tCB.eff);
Data.sci100_scg100_scf100.task.Groups{1}.Std = niak_lvec2mat(tCB.std_eff);

Data.sci100_scg100_scf100.rest.Groups{3}.Effect = niak_lvec2mat(rSC.eff);
Data.sci100_scg100_scf100.rest.Groups{3}.Std = niak_lvec2mat(rSC.std_eff);

Data.sci100_scg100_scf100.task.Groups{3}.Effect = niak_lvec2mat(tSC.eff);
Data.sci100_scg100_scf100.task.Groups{3}.Std = niak_lvec2mat(tSC.std_eff);

CreateInteractionGraph(Data)