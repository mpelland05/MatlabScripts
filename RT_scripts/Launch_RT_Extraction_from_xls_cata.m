%This script will start a series of function which will start by extracting
%the data from the .log file up to removing outliers. The results are
%stored in the specified file. If you want more information on each
%process, open the relevant functions
%
%The user simply needs to fil in the input section. The later must contain:
%
%
%files_in           full path to a xls file containing the data(see Extract
%                   Xls.m for precisions
%
%SavePath           The folder in which to save your results
%
%SaveName           Name of the file in which your data will be saved
%
%Event2Num.Event    Name of all the events of interest.
%
%Event2Num.Num      Numerical codes which will be assigned to different
%                   conditions
%
%MinRT              Minimum reaction time which is deemed acceptable
%
%MaxRT              Maximum reaction time which is deemed acceptable
%
%NumSTD             Number of standard deviation defining outliers
%
%OutByParticipants  Way of removing outliers, it can be done by
%                   participants (all blocks together) or for every block.
%                   Note that conditions are never mixed
%
%Input example:
%
%files_in = 'C:\Users\Maxime Pelland\Desktop\RTData\Maxime\AdelaideData\RawData\Cataract.xls';
%SavePath = 'C:\Users\Maxime Pelland\Desktop\RTData\Maxime\AdelaideData\Results\';
%SaveName = 'PreProcessed_Data';
%Event2Num.Event = {'T1' 'T2' 'T3' 'T4' 'V1' 'V2' 'V3' 'V4' 'T12' 'T34' 'T13' 'T24' 'V12' 'V34' 'V13' 'V24' 'V1T2' 'V3T4' 'V1T3' 'V2T4' 'V2T1' 'V4T3' 'V3T1' 'V4T2' 'CatchTrial'};    
%Event2Num.Num = [1:length(Event2Num.Event)];
%MinRT = 130;           %Min RT not considered an outlier
%MaxRT = 1000;          %Max RT not considered an outlier
%NumSTD = 3;            %Number of standard deviations where we consider that the data is an outlier. 
%OutByParticipants = 1; %Calculates Standard deviations and outliers based
%                       %on all trials from a condition
%
%
%IMPORTANT NOTES
%Note that the code for response is '2' and '3'; If this is not the case in your
%experiment, modify the function Modify2Matrices where the green arrow is.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%
%Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%
files_in = 'C:\Users\Maxime Pelland\Desktop\RTData\Maxime\AdelaideData\RawData\Cataract.xls';
SavePath = 'C:\Users\Maxime Pelland\Desktop\RTData\Maxime\AdelaideData\Remove25SD\Results';
SaveName = 'PreProcessed_Data_Cataract';

Event2Num.Event = {'VR' 'VL' 'AR' 'AL' ...
                    'VLAL' 'VLAR' 'VRAL' 'VRAR'}; 
    
Event2Num.Num = [1:length(Event2Num.Event)];

MinRT = 100;%Min RT not considered an outlier
MaxRT = 1000; %Max RT not considered an outlier
NumSTD = 2.5; %Number of standard deviations where we consider that the data is an outlier. 

OutByParticipants = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Legend = Event2Num.Event;

%Launches first function to extract data from the Presentation Log
display('Step 1, extraction: Start')
Original = ExtractXls(files_in);
display('Step 1, extraction: Done')

%Launches the second function to modify the extracted data into matrices.
%The data is rearranged to simplify its analysis. 
display('Step2, modify to matrices: Start')
Modified = Modify2Matrices_xls(Original,Event2Num,Legend);
display('Step2, modify to matrices: Done')

%Launches the third function which will separate the different conditions
%into different matrices
display('Step3, Separate Conditions: Start')
Separated = SeparateConditions(Modified,Event2Num);
display('Step3, Separate Conditions: Done')

%Launches the fourth function which will remove Reaction times that are
%anormal (too fast or too short)
display('Step3, Separate Conditions: Start')
NoOutliers = RemoveOutliers(Separated,Event2Num,MinRT,MaxRT,NumSTD,OutByParticipants);
display('Step3, Separate Conditions: Done')

%Saves the resulting structure
mkdir(SavePath);
save([SavePath,'\',SaveName],'NoOutliers');

%Launches a fourth function which will find how many trials lacked a
%response and how many 

display('Step4, Computing misses and removed outliers: Start')
MissAndOutliers = CalculateMissAndOutliers(NoOutliers,Separated);
display('Step4, Computing misses and removed outliers: Done')

save([SavePath,'\',SaveName,'Misses_and_Outliers'],'MissAndOutliers');