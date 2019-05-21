%This script will launch various measures of graph analysis 
%Put script in folder with "Comp_MST.m", "MimimumSpanningTree.m" and the "CompliedeConnectivityMatrices.mat.
%Transfer all files to /mnt/parallel_scratch_ms2_wipe_on_april_2015/bellec/bellec_group/blindModularity/temp/
%LaunchScript


%SubScales = {'sci190_scg190_scf190'};

%use if you did not subdivide the connectome
ext{1} = 'mat';

%for susu = 1:length(SubScales),
%BaseP = strcat('F:\GraphAnalysis\raw\Occ190\',SubScales{susu},'\');
%OutP = strcat('F:\GraphAnalysis\results\Jan11_2015_Occ190',SubScales{susu},'\');
%mkdir(OutP);
Cond = {'rest'};
Groups = {'CB','SC'};
%ext = {'Occ' 'Cerebellum' 'DMN' 'Auditory' 'Thalamus' 'Sensorimotor' 'Temporal_ventroFrontal' 'Fronto_Parietal'};
MakeBinar = 'no';

%load(strcat(BaseP,'CompiledConnectivityMatrices.mat'));
load('CompiledConnectivityMatrices.mat');

%if strcmp(ext{1}, 'See_Next'),
%    for gu = 1:length(Groups),
%        for cu = 1:length(Cond),
%            ConnMatrix.(Cond{cu}).(Groups{gu}).(ext{1}).mat = ConnMatrix.(Cond{cu}).(Groups{gu}).mat;
%        end
%    end
%end

Comp_MST;
%end
