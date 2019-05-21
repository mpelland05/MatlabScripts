%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Cataract Eff Mod %%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%    1'VR'    2'VL'    3'AR'    4'AL'    5'VLAL'    6'VLAR'    7'VRAL'    8'VRAR'
Labels = {'Prev'};
SavePath = 'C:\Users\Maxime Pelland\Desktop\RTData\Maxime\AdelaideData\Remove25SD\Results\';

CondAnal = 5:8;

PreCond{5} = 1:8;
PreCond{6} = 1:8;
PreCond{7} = 1:8;
PreCond{8} = 1:8;

%Data to be loaded:
load('C:\Users\Maxime Pelland\Desktop\RTData\Maxime\AdelaideData\Remove25SD\Results\PreProcessed_Data_Cataract.mat');
SaveName = 'PrevMod_Cataract_GenStyle';

%Launch
Averaged_PrevCond = Average_by_PrevCond_v2(NoOutliers,CondAnal,PreCond,Labels);

%Save results
save([SavePath,'\',SaveName],'Averaged_PrevCond_MultiSensLimited');
write2xls_Gen(Averaged_PrevCond,[SavePath,'\',SaveName],CondAnal);

clear Averaged_PrevCond; clear NoOutliers;


%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Controls Eff Mod %%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%Data to be loaded:
load('C:\Users\Maxime Pelland\Desktop\RTData\Maxime\AdelaideData\Remove25SD\Results\PreProcessed_Data_Controls.mat');
SaveName = 'PrevMod_Controls_GenStyle';

%Launch
Averaged_PrevCond = Average_by_PrevCond_v2(NoOutliers,CondAnal,PreCond,Labels);

%Save results
save([SavePath,'\',SaveName],'Averaged_PrevCond_MultiSensLimited');
write2xls_Gen(Averaged_PrevCond,[SavePath,'\',SaveName],CondAnal);

clear Averaged_PrevCond; clear NoOutliers;






%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Cataract Eff Alig %%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%    1'VR'    2'VL'    3'AR'    4'AL'    5'VLAL'    6'VLAR'    7'VRAL'    8'VRAR'
Labels = {'Prev'};
SavePath = 'C:\Users\Maxime Pelland\Desktop\RTData\Maxime\AdelaideData\Remove25SD\Results\';

CondAnal = 1:8;

PreCond{1} = [1 3 8];
PreCond{2} = [2 4 5];
PreCond{3} = [1 3 8];
PreCond{4} = [2 4 5];

PreCond{5} = [2 4 5];
PreCond{6} = 1:8;
PreCond{7} = 1:8;
PreCond{8} = [1 3 8];

%Data to be loaded:
load('C:\Users\Maxime Pelland\Desktop\RTData\Maxime\AdelaideData\Remove25SD\Results\PreProcessed_Data_Cataract.mat');
SaveName = 'PrevAlig_Cataract_GenStyle';

%Launch
Averaged_PrevCond = Average_by_PrevCond_v2(NoOutliers,CondAnal,PreCond,Labels);

%Save results
save([SavePath,'\',SaveName],'Averaged_PrevCond_MultiSensLimited');
write2xls_Gen(Averaged_PrevCond,[SavePath,'\',SaveName],CondAnal);

clear Averaged_PrevCond; clear NoOutliers;


%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Controls Eff Mod %%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%Data to be loaded:
load('C:\Users\Maxime Pelland\Desktop\RTData\Maxime\AdelaideData\Remove25SD\Results\PreProcessed_Data_Controls.mat');
SaveName = 'PrevAlig_Controls_GenStyle';

%Launch
Averaged_PrevCond = Average_by_PrevCond_v2(NoOutliers,CondAnal,PreCond,Labels);

%Save results
%save([SavePath,'\',SaveName],'Averaged_PrevCond_MultiSensLimited');
%write2xls_Gen(Averaged_PrevCond,[SavePath,'\',SaveName],CondAnal);

clear Averaged_PrevCond; clear NoOutliers;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Cataract Eff Mod opposite %%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%    1'VR'    2'VL'    3'AR'    4'AL'    5'VLAL'    6'VLAR'    7'VRAL'    8'VRAR'
Labels = {'Prev'};
SavePath = 'C:\Users\Maxime Pelland\Desktop\RTData\Maxime\AdelaideData\Remove25SD\Results\';

CondAnal = 1:8;

PreCond{1} = [3 4];
PreCond{2} = [3 4];
PreCond{3} = [1 2];
PreCond{4} = [1 2];

PreCond{5} = 1:8;
PreCond{6} = 1:8;
PreCond{7} = 1:8;
PreCond{8} = 1:8;

%Data to be loaded:
load('C:\Users\Maxime Pelland\Desktop\RTData\Maxime\AdelaideData\Remove25SD\Results\PreProcessed_Data_Cataract.mat');
SaveName = 'PrevMod_Cataract_Opposite';

%Launch
Averaged_PrevCond = Average_by_PrevCond_v2(NoOutliers,CondAnal,PreCond,Labels);

%Save results
save([SavePath,'\',SaveName],'Averaged_PrevCond_MultiSensLimited');
write2xls_Gen(Averaged_PrevCond,[SavePath,'\',SaveName],CondAnal);

clear Averaged_PrevCond; clear NoOutliers;


%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Controls Eff Mod %%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%Data to be loaded:
load('C:\Users\Maxime Pelland\Desktop\RTData\Maxime\AdelaideData\Remove25SD\Results\PreProcessed_Data_Controls.mat');
SaveName = 'PrevMod_Controls_Oppposite';

%Launch
Averaged_PrevCond = Average_by_PrevCond_v2(NoOutliers,CondAnal,PreCond,Labels);

%Save results
save([SavePath,'\',SaveName],'Averaged_PrevCond_MultiSensLimited');
write2xls_Gen(Averaged_PrevCond,[SavePath,'\',SaveName],CondAnal);

clear Averaged_PrevCond; clear NoOutliers;






%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Cataract Eff Alig %%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%    1'VR'    2'VL'    3'AR'    4'AL'    5'VLAL'    6'VLAR'    7'VRAL'    8'VRAR'
Labels = {'Prev'};
SavePath = 'C:\Users\Maxime Pelland\Desktop\RTData\Maxime\AdelaideData\Remove25SD\Results\';

CondAnal = 1:8;

PreCond{1} = [2 4 5];
PreCond{2} = [1 3 8];
PreCond{3} = [2 4 5];
PreCond{4} = [1 3 8];

PreCond{5} = [1 3 8];
PreCond{6} = 1:8;
PreCond{7} = 1:8;
PreCond{8} = [2 4 5];

%Data to be loaded:
load('C:\Users\Maxime Pelland\Desktop\RTData\Maxime\AdelaideData\Remove25SD\Results\PreProcessed_Data_Cataract.mat');
SaveName = 'PrevAlig_Cataract_Opposite';

%Launch
Averaged_PrevCond = Average_by_PrevCond_v2(NoOutliers,CondAnal,PreCond,Labels);

%Save results
save([SavePath,'\',SaveName],'Averaged_PrevCond_MultiSensLimited');
write2xls_Gen(Averaged_PrevCond,[SavePath,'\',SaveName],CondAnal);

clear Averaged_PrevCond; clear NoOutliers;


%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Controls Eff Mod %%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%Data to be loaded:
load('C:\Users\Maxime Pelland\Desktop\RTData\Maxime\AdelaideData\Remove25SD\Results\PreProcessed_Data_Controls.mat');
SaveName = 'PrevAlig_Controls_Opposite';

%Launch
Averaged_PrevCond = Average_by_PrevCond_v2(NoOutliers,CondAnal,PreCond,Labels);

%Save results
save([SavePath,'\',SaveName],'Averaged_PrevCond_MultiSensLimited');
write2xls_Gen(Averaged_PrevCond,[SavePath,'\',SaveName],CondAnal);

clear Averaged_PrevCond; clear NoOutliers;