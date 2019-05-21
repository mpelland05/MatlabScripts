%GenPaths = 'G:\Connectivity\glm_connectome_aout_2013\GLM01_complete_nosex';
ScalePath = {'sci50_scg50_scf50', 'sci100_scg100_scf100'};
ContrastPath = {'rest_CBvsSC','task_CBvsSC'};
Nets = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

for ss = length(ScalePath),
    
    %load scales
    [hdrR, fdrR] = niak_read_vol([GenPaths,filesep,ScalePath{ss},filesep,ContrastPath{1},filesep,'fdr_',ContrastPath{1},'_',ScalePath{ss},'.nii.gz']);
    [hdrT, fdrT] = niak_read_vol([GenPaths,filesep,ScalePath{ss},filesep,ContrastPath{2},filesep,'fdr_',ContrastPath{2},'_',ScalePath{ss},'.nii.gz']);
    
    
    for nn = 1:length(Nets),
        %create masks for 
        submask = zeros(size(fdr));

        %find regions showing same trend (positive and negative
        submask(fdr(:,:,:,Nets(nn))>0) = 1;
        submask(fdr(:,:,:,Nets(nn))<0) = - 1;

        %save
        hdrR.file_name = [GenPaths,filesep,ScalePath,'_Overlap_',num2str(Nets(nn)),'.nii.gz'];
        niak_write_vol(hdrR,submask);
        
    end
end