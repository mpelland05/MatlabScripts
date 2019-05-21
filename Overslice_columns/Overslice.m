function Overslice(files_in,opt),
%script will do an overslice image in columns instead of a row. Especially
%interesting to look only at th eoccipital lobe. the input file should be
%an overslice from mricron.
%files_in
%       .path   string, full path to image of interest
%       .perc
%       .numcol integer, number of columns 
%opt
%       .imask string, full path to image which can be suppressed from
%                       overslice image
fs = filesep;

ima = imread(files_in.path);

if isfield(opt,'imask'), %looks for a mask of uninteresting regiosn in the image
    itemp = imread(opt.imask);
    ima(find(itemp~=0)) = 0;
end

if isfield(opt,'gmask'), %makes nice gray borders
   itemp = imread(opt.gmask);
   ima(find(ima == 0)) = itemp(find(ima == 0));
end

[aa bb cc] = size(ima);
ima = [zeros(233,1,3) ima zeros(233,1,3)];

sepw = find(sum(sum(ima,3),1)==0);%limit images
wid = diff(sepw);

sepw = sepw(end:-1:1);
wid = wid(end:-1:1);

counter = 0;
for col = 1:files_in.numcol,
    
    nim = ceil(length(wid)./files_in.numcol);%number of images in colum
    if length(wid) < (nim.*col), nim = length(wid) - (nim.*(col-1));end;%check whether its the last column, if so, recalculat the number of images in it
    
    if nim > 0,
        oim{col} = zeros(4000,max(wid)+2,cc);%outpout image
        [ai bi ci] = size(oim{col});
        
        for ro = 1:nim,
            counter = counter+1;
            tnew = ima(:,sepw(counter+1):sepw(counter),:);
            
            %find out the hight of the current wide part
            seph = find(sum(sum(tnew,3),2)==0);;%find limit of high
            hig = diff(seph); tloc = find(hig == max(hig)); %find the high of each image
            limh = seph(tloc);
            liml = seph(tloc+1);
            hig = hig(tloc);

            %find overlap in pixels
            perc = round(hig.*(files_in.perc));
            
            %loop to add images
            if ro == 1,
                oim{col}(1:hig+1,(bi-wid(counter))/2:((bi-wid(counter))/2)+wid(counter),:) = tnew(limh:liml,:,:);
            else
                %find the lowest non-white voxel
                t2d = sum(oim{col},3);
                tloc = find(t2d > 0);
                [xx yy]=ind2sub(size(t2d),tloc); 
                curow = max(xx); %find where we are at in the rows
                
                
                temp1 = oim{col}(curow-perc:(curow-perc)+hig,:,:);
                temp2 = zeros(size(temp1)); 
                temp2(:,(bi-wid(counter))/2:((bi-wid(counter))/2)+wid(counter),:) = tnew(limh:liml,:,:);
                
                tloc = find(temp1 == 0);
                temp1(tloc) = temp2(tloc);
                
                oim{col}(curow-perc:(curow-perc)+hig,:,:)=temp1;
            end
        end
    end
    
    t2d = sum(oim{col},3);
    tloc = find(t2d > 0);
    [xx yy]=ind2sub(size(t2d),tloc); 
    lastrow = max(xx);
    
    oim{col} = oim{col}(1:lastrow+2,:,:)./255;
    
    %if opt.back == 1,
    %    d1 = (squeeze(oim{col}(:,:,1)) < (2/255)).*(squeeze(oim{col}(:,:,2))<(2/255)).*(squeeze(oim{col}(:,:,3))<(2/255));
    %    rd1 = repmat(d1, [1 1 3]);
    %    oim{col} = oim{col}+rd1; 
    %end
    
    [pathstr, name, ext] = fileparts(files_in.path);
    mkdir(pathstr,'ColumnImages');
    imwrite(oim{col},strcat(pathstr,fs,'ColumnImages',fs,name,'_',num2str(col),ext),'png');
end



end