function [Coordmat Coord] = Obtain_Central_Coord_Of_Roi(files_in,files_out),
%This script wil take a volume, go through all of the rois (identified by
%integer ranging from 1 to infinity (well, close enough I guess) and find
%their center coordinate. After that, it will find the voxel closest to 
%this coordinate that is also part of the ROI and assign it as its center. 
%Also a volume will be created containing all these center coordinates so
%they may be overlaid upon the image of the roi. 
%
%Note that in order to return adequate results, the volume should be in 1mm
%isometric sampled. Use: niak_brick_resample_vol(files_in,files_out,opt)
%                       files_in.source = name of file      %must be .mnc
%                       files_in.target = files_in.source;
%                       opt.interpolation = 'nearest_neighbour';
%                       opt.voxel_size = [1 1 1];
%                       files_out = 'Vol_1mm';
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%files_in
%       .path = string, path to volume to be used.
%
%files_out  String, full path and name of output.
%
%Files are saved in .mat and .xls formats as well as a volume containing
%the centers.

'Warning: make sure your volume is 1mm isometric sampled, otherwise problems will occur!'
'This message is displayed whether or not the volume meets this demand'

[hdr vol] = niak_read_vol(files_in.path);
cent = abs(hdr.info.mat(1:3,4));
siz = size(vol);

rig = 1:cent(1); lef = ceil(siz(1)/2):siz(1); %Finds what is left and what is right.

rvol = vol; rvol(rig,:,:) = 0;
lvol = vol; lvol(lef,:,:) = 0;

Coord = zeros(8,length(unique(vol)) -1);
Coordmat = zeros(size(Coord));

%Loop for right
uni = unique(rvol); uni(1) = []; %find all the unique networks and remove the 0;
for ii = 1:length(uni),
    net = uni(ii);
    [xx yy zz] = ind2sub(size(vol),find(rvol == net));
    temp = round([mean(xx) mean(yy) mean(zz)]);           %find the center
    
    isInROI = sum(xx == temp(1) & yy == temp(2) & zz == temp(3)); %finder whether it is part of the ROI
    
    if isInROI,
        txx = xx - temp(1); tyy = yy -temp(2); tzz = zz - temp(3);
        dist = sqrt( ( (txx.^2)+(tyy.^2) ) + (tzz.^2) );
    else
        txx = xx - temp(1); tyy = yy -temp(2); tzz = zz - temp(3);
        tempdist = sqrt( ( (txx.^2)+(tyy.^2) ) + (tzz.^2) );
        
        loc = find(tempdist == min(tempdist));
        temp = [xx(loc(1)) yy(loc(1)) zz(loc(1))];
        
        txx = xx - temp(1); tyy = yy -temp(2); tzz = zz - temp(3);
        dist = sqrt( ( (txx.^2)+(tyy.^2) ) + (tzz.^2) );
    end
    
    
    Coord(1:4,net) =[(temp - cent') std(dist)];
    Coordmat(1:4,net) =[temp std(dist)];
    
    
end

%Loop for left
uni = unique(lvol); uni(1) = []; %find all the unique networks and remove the 0;
for ii = 1:length(uni),
    net = uni(ii);
    [xx yy zz] = ind2sub(size(vol),find(lvol == net));
    temp = round([mean(xx) mean(yy) mean(zz)]);           %find the center
    
    isInROI = sum(xx == temp(1) & yy == temp(2) & zz == temp(3)); %finder whether it is part of the ROI
    
    if isInROI,
        txx = xx - temp(1); tyy = yy -temp(2); tzz = zz - temp(3);
        dist = sqrt( ( (txx.^2)+(tyy.^2) ) + (tzz.^2) );
    else
        txx = xx - temp(1); tyy = yy -temp(2); tzz = zz - temp(3);
        tempdist = sqrt( ( (txx.^2)+(tyy.^2) ) + (tzz.^2) );
        
        loc = find(tempdist == min(tempdist));
        temp = [xx(loc(1)) yy(loc(1)) zz(loc(1))];
        
        txx = xx - temp(1); tyy = yy -temp(2); tzz = zz - temp(3);
        dist = sqrt( ( (txx.^2)+(tyy.^2) ) + (tzz.^2) );
    end
    
    
    Coord(5:8,net) =[(temp - cent') std(dist)];
    Coordmat(5:8,net) =[temp std(dist)];
    
    
end

%Create volume for centers
volcen = zeros(size(vol));

for ii = 1:size(Coord,2),
    
    if sum(Coordmat(1:3,ii)) ~= 0,
        Co = Coordmat(1:3,ii);
        volcen(Co(1)-1:Co(1)+1,Co(2)-1:Co(2)+1,Co(3)-1:Co(3)+1) = ii;
    end
    
    if sum(Coordmat(5:7,ii)) ~= 0,
        Co = Coordmat(5:7,ii);
        volcen(Co(1)-1:Co(1)+1,Co(2)-1:Co(2)+1,Co(3)-1:Co(3)+1) = ii;
    end
end
   

%save results
%vol
[pp nn ee]=fileparts(files_in.path);
chdr = hdr; chdr.file_name = strcat(files_out,'_Centers',ee); 
niak_write_vol(chdr,volcen);

%.mat file
%save('-mat7-binary',strcat(files_out,'.mat'),'Coord','Coordmat');
save(strcat(files_out,'.mat'),'Coord','Coordmat');

%.xls files
xlswrite(strcat(files_out,'.xls'), Coord', 1);
%xlswrite(strcat(files_out,'.xls'), Coordmat', 2);

end
