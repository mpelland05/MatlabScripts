clear all
%This script will launch the left and right version of the script
files_in.mask = '/home/mpelland/database/blindtvr/fmri/region_growing_01_RestOnly_NoSmooth/Rrois/Mask.nii';
files_in.atoms = '/home/mpelland/database/blindtvr/fmri/region_growing_01_RestOnly_NoSmooth/Rrois/brain_rois.nii';                                                                                                            %original parcellation based on CB, LB, SC, rest and task. 
files_in.path= '/home/mpelland/database/blindModularity/fmri/basc_RestOnly_CBSCMixed_OccMask_X_90_f/Rightt/stability_ind';
files_in.pType = 'consensus';
files_in.filter = {'NoFilt'};
%files_in.filter = {'task','LBxxx'};
files_in.groups = {'CBxxx','SCxxx'};
files_in.contrast = {[1 2]};
files_in.scales = repmat(5:5:50,3,1); %Don't forget to put the ' if copy pasted from basc

files_out = '/home/mpelland/database/blindModularity/Results/NoSmooth202_fromGraph_R.mat';

CompareTopographies(files_in,files_out);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all


files_in.mask = '/home/mpelland/database/blindtvr/fmri/region_growing_01_RestOnly_NoSmooth/Lrois/Mask.nii';
files_in.atoms = '/home/mpelland/database/blindtvr/fmri/region_growing_01_RestOnly_NoSmooth/Lrois/brain_rois.nii';                                                                                                            %original parcellation based on CB, LB, SC, rest and task. 
files_in.path= '/home/mpelland/database/blindModularity/fmri/basc_RestOnly_CBSCMixed_OccMask_X_90_f/Left/stability_ind';
files_in.pType = 'consensus';
files_in.filter = {'NoFilt'};
%files_in.filter = {'task','LBxxx'};
files_in.groups = {'CBxxx','SCxxx'};
files_in.contrast = {[1 2]};
files_in.scales = repmat(5:5:50,3,1); %Don't forget to put the ' if copy pasted from basc

files_out = '/home/mpelland/database/blindModularity/Results/NoSmooth202_fromGraph_L.mat';

CompareTopographies(files_in,files_out);
