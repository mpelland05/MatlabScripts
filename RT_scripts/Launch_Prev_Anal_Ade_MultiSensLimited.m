%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Multi by A
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Cataract Eff Mod %%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%    1'VR'    2'VL'    3'AR'    4'AL'    5'VLAL'    6'VLAR'    7'VRAL'    8'VRAR'
Labels = {'Prev'};
SavePath = 'C:\Users\Maxime Pelland\Desktop\RTData\Maxime\AdelaideData\Remove25SD\Results\';

CondAnal = 5:8;

PreCond{5} = [3 4];
PreCond{6} = [3 4];
PreCond{7} = [3 4];
PreCond{8} = [3 4];

%Data to be loaded:
load('C:\Users\Maxime Pelland\Desktop\RTData\Maxime\AdelaideData\Remove25SD\Results\PreProcessed_Data_Cataract.mat');
SaveName = 'PrevMod_Cataract_GenStyle_MultiPreceded_by_Aud';

%Launch
Averaged_PrevCond = Average_by_PrevCond_v2(NoOutliers,CondAnal,PreCond,Labels);

%Save results
save([SavePath,'\',SaveName],'Averaged_PrevCond');
write2xls_Gen(Averaged_PrevCond,[SavePath,'\',SaveName],CondAnal);

clear Averaged_PrevCond; clear NoOutliers;


%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Controls Eff Mod %%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%Data to be loaded:
load('C:\Users\Maxime Pelland\Desktop\RTData\Maxime\AdelaideData\Remove25SD\Results\PreProcessed_Data_Controls.mat');
SaveName = 'PrevMod_Controls_GenStyle_MultiPreceded_by__Aud';

%Launch
Averaged_PrevCond = Average_by_PrevCond_v2(NoOutliers,CondAnal,PreCond,Labels);

%Save results
save([SavePath,'\',SaveName],'Averaged_PrevCond');
write2xls_Gen(Averaged_PrevCond,[SavePath,'\',SaveName],CondAnal);

clear Averaged_PrevCond; clear NoOutliers;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Multi by V
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Cataract Eff Mod %%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%    1'VR'    2'VL'    3'AR'    4'AL'    5'VLAL'    6'VLAR'    7'VRAL'    8'VRAR'
Labels = {'Prev'};
SavePath = 'C:\Users\Maxime Pelland\Desktop\RTData\Maxime\AdelaideData\Remove25SD\Results\';

CondAnal = 5:8;

PreCond{5} = [1 2];
PreCond{6} = [1 2];
PreCond{7} = [1 2];
PreCond{8} = [1 2];

%Data to be loaded:
load('C:\Users\Maxime Pelland\Desktop\RTData\Maxime\AdelaideData\Remove25SD\Results\PreProcessed_Data_Cataract.mat');
SaveName = 'PrevMod_Cataract_GenStyle_MultiPreceded_by__Vis';

%Launch
Averaged_PrevCond = Average_by_PrevCond_v2(NoOutliers,CondAnal,PreCond,Labels);

%Save results
save([SavePath,'\',SaveName],'Averaged_PrevCond');
write2xls_Gen(Averaged_PrevCond,[SavePath,'\',SaveName],CondAnal);

clear Averaged_PrevCond; clear NoOutliers;


%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Controls Eff Mod %%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%Data to be loaded:
load('C:\Users\Maxime Pelland\Desktop\RTData\Maxime\AdelaideData\Remove25SD\Results\PreProcessed_Data_Controls.mat');
SaveName = 'PrevMod_Controls_GenStyle_MultiPreceded_by_Vis';

%Launch
Averaged_PrevCond = Average_by_PrevCond_v2(NoOutliers,CondAnal,PreCond,Labels);

%Save results
save([SavePath,'\',SaveName],'Averaged_PrevCond');
write2xls_Gen(Averaged_PrevCond,[SavePath,'\',SaveName],CondAnal);

clear Averaged_PrevCond; clear NoOutliers;





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Multi by Multi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Cataract Eff Mod %%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%    1'VR'    2'VL'    3'AR'    4'AL'    5'VLAL'    6'VLAR'    7'VRAL'    8'VRAR'
Labels = {'Prev'};
SavePath = 'C:\Users\Maxime Pelland\Desktop\RTData\Maxime\AdelaideData\Remove25SD\Results\';

CondAnal = 5:8;

PreCond{5} = 5:8;
PreCond{6} = 5:8;
PreCond{7} = 5:8;
PreCond{8} = 5:8;

%Data to be loaded:
load('C:\Users\Maxime Pelland\Desktop\RTData\Maxime\AdelaideData\Remove25SD\Results\PreProcessed_Data_Cataract.mat');
SaveName = 'PrevMod_Cataract_GenStyle_MultiPreceded_by_Multi';

%Launch
Averaged_PrevCond = Average_by_PrevCond_v2(NoOutliers,CondAnal,PreCond,Labels);

%Save results
save([SavePath,'\',SaveName],'Averaged_PrevCond');
write2xls_Gen(Averaged_PrevCond,[SavePath,'\',SaveName],CondAnal);

clear Averaged_PrevCond; clear NoOutliers;


%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Controls Eff Mod %%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%Data to be loaded:
load('C:\Users\Maxime Pelland\Desktop\RTData\Maxime\AdelaideData\Remove25SD\Results\PreProcessed_Data_Controls.mat');
SaveName = 'PrevMod_Controls_GenStyle_MultiPreceded_by_Multi';

%Launch
Averaged_PrevCond = Average_by_PrevCond_v2(NoOutliers,CondAnal,PreCond,Labels);

%Save results
save([SavePath,'\',SaveName],'Averaged_PrevCond');
write2xls_Gen(Averaged_PrevCond,[SavePath,'\',SaveName],CondAnal);

clear Averaged_PrevCond; clear NoOutliers;

