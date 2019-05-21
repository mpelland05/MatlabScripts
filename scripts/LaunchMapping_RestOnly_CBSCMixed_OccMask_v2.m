%This script will take group stability results and create group stability
%maps from them. 
fs = filesep;

mfiles_in.path = 'F:\Modularity\fmri\basc_RestOnly_CBSCMixed_OccMask_f\';
mfiles_in.groups = {'CBxxx' 'SCxxx'};
scales = [3 3 3; 5 5 5 ; 13 10 10; 20 22 26; 40 40 40]';
files_in.atoms = 'F:\Modularity\fmri\region_growing_RestOnly_CBSCMixed_OccMask\rois\brain_rois.nii.gz';

for gg = 1:length(mfiles_in.groups),
   for ss = 1:size(scales,2),
       
       if size(scales,1) == 1,
            files_in.stability = strcat(mfiles_in.path,'stability_group',fs,'stability_group_sci',num2str(scales(3,ss)),'.mat');
            files_in.hierarchy = files_in.stability;
            
            opt.scales_maps = repmat(scales(ss),1,3);
            opt.folder_out =  strcat(mfiles_in.path,'stability_group',fs,'Scale_',num2str(scales(1,ss)),fs);
            mkdir( strcat(mfiles_in.path,'stability_group',fs) , strcat('Scale_',num2str(scales(1,ss))) );
       else
           files_in.stability = strcat(mfiles_in.path,'stability_group',fs,'stability_group_sci',num2str(scales(1,ss)),'.mat');
           files_in.hierarchy = files_in.stability;
            
           opt.scales_maps = [repmat(scales(3,ss),1,2) scales(2,ss)];
           opt.folder_out =  strcat(mfiles_in.path,'stability_group',fs,'Scale_',num2str(scales(1,ss)),fs);
           mkdir( strcat(mfiles_in.path,'stability_group',fs) , strcat('Scale_',num2str(scales(1,ss))) );
       end
       
       
       files_out.partition_consensus{1} = strcat(opt.folder_out,'Consensus.mnc.gz');
       files_out.partition_core{1} = strcat(opt.folder_out,'Core.mnc.gz');
       files_out.partition_adjusted{1} = strcat(opt.folder_out,'Adjusted.mnc.gz');
       files_out.partition_threshold{1} = strcat(opt.folder_out,'Threshold.mnc.gz');
       files_out.stability_maps{1} = strcat(opt.folder_out,'Stab_Maps.mnc.gz');
       files_out.stability_maps_all{1} = strcat(opt.folder_out,'Stab_Maps_All.mnc.gz');
       
       niak_brick_stability_maps(files_in,files_out,opt);
   end
end

niak_brick_mnc2nii(mfiles_in.path,mfiles_in.path);