%This script will take network maps and separate them into a different
%dimension so that each seed may be opened individually. 

%RootPaths = {'/home/mpelland/database/blindtvr/results/glm_connectome_005_nii/' '/home/mpelland/database/blindtvr/results/glm_connectome_01_nii/' '/home/mpelland/database/blindtvr/results/glm_connectome_02_nii/'};

RootPaths = {'/home/mpelland/database/blindtvr/results/glm_connectome_01_complete_noSex_2_nii/'};

NumNet = [3:20 50 100 200];
for ii = 1:length(NumNet),
    NameNet{ii} = strcat('sci',num2str(NumNet(ii)),'_scg',num2str(NumNet(ii)),'_scf',num2str(NumNet(ii)));
end

for ii = 1:length(RootPaths),
   for jj = 1:length(NumNet),
      [hdr,Net] = niak_read_vol(strcat(RootPaths{ii},NameNet{jj},filesep,'networks_',NameNet{jj},'.nii.gz')); %Load networks
      
      [aa bb cc] = size(Net);
      NewNet = zeros(aa,bb,cc,NumNet(jj));
      
      for kk = 1:NumNet(jj),
          tempMat = zeros(aa, bb,cc);
          temp = find(Net == kk);
          tempMat(temp) = 1;
          NewNet(:,:,:,kk) = tempMat;
      end
      
      hdr.file_name = strcat(RootPaths{ii},'OutputImages',filesep,'Seeds',filesep,num2str(NumNet(jj)),'Seeds.nii.gz')
      niak_write_vol(hdr,NewNet);
      clear hdr Net aa bb cc NewNet tempMat temp;
   end
end
