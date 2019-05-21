function RandomAtomGen(files_in,files_out),
%This script will take a volume containing partitions of interest, seed them, 
%and grow atoms from them.
%
%files_in
%	.part		string, full path to fmri volume containgin partitions
%				suggest using 
%	.mask		string, full path to volume containing a mask of the 
%				brain to con... the regions growing
%	.nAtm		int, number of atoms that must be found
%files_in.part = 'roi_aal_3mm.nii';
%files_in.mask = 'Mask_AAL_Occ_wBASC6_Right.nii';
%files_in.nAtm = 100;
%files_out = 'Atoms_AAL_Occ_wBASC6_Right.nii';

%Set varialbes
nAtm = files_in.nAtm;

[hdr,part] = niak_read_vol(files_in.part);
[hdr,mask] = niak_read_vol(files_in.mask);

part = part.*mask;

nampart = unique(part(:)); nampart(1) = [];
npart = length(nampart);

idxVol =  zeros( length(part(:)) , 3);%This is a matrix which will contain the coordinates of every voxel within the brain volume

for vv = 1:length(part(:)),
	[aa bb cc] = ind2sub(size(part),vv);
    idxVol(vv,:) = [aa bb cc];
end


%%%%
% Find number of seeds per parts
%%%%

%% Find how many voxel per part
sizpart = zeros(1,npart);
for pp = 1:npart,
	sizpart(pp) = sum(part(:) == nampart(pp));
end

perpart = sizpart./sum(sizpart);
nAtmPart = round(perpart.*nAtm);
%add a minimu of 1 to all
nAtmPart(find(nAtmPart == 0)) = 1;

nAtm = sum(nAtmPart);


%%%%
% Select the starting seeds of the atoms
%%%%
cAtm = 0; %count number of seeds
vOwn = zeros(length(part(:)),1);%vector of part ownership

for aa = 1:npart,
	ntemp = nAtmPart(aa);%find number of atm per part
	loc = find(part == nampart(aa)); 
	
	tatmloc = randperm(length(loc));
	
	for tt = 1:ntemp,
		cAtm = cAtm +1;
		
		vOwn(loc(tatmloc(tt))) = cAtm;
	end	
end


%%%%%
% Big loop ending only all seeds within the mask are assigned to an atom
%%%%%
lcounter = 0;
vAss = sum(vOwn > 0);%number of assigned voxels
vOwn(find(mask == 0)) = -1;
NewVol = zeros(size(mask));

n2Ass = sum(mask(:));

while vAss < n2Ass,
	%makes sure the loop does not run forever
	lcounter = lcounter+1;
	if lcounter > length(part(:)), error('could not parse everything into atoms');end
    
    %Report advancement
    if (lcounter/10) == round(lcounter/10), 
        strcat('Currently_at_loop_',num2str(lcounter),'_with_',num2str(100*vAss/n2Ass),'_percent done')
    end
        
	%Calculate the center of mass of each atom
	AtmCent = zeros(3,nAtm);
	for nn =1:nAtm,
		tsiz = sum(vOwn == nn);
		AtmCent(:,nn) = sum(repmat(vOwn == nn,1,3).*idxVol)./tsiz;
	end

	
	for nn = 1:nAtm,
        NewVol(find(vOwn == nn)) = nn;%update volume containing atoms
        
        %Find closest voxel to center of mass of each atom
		tdist = idxVol - repmat(AtmCent(:,nn)',size(idxVol,1),1 );
		tdist = sqrt( (tdist(:,1).^2) + (tdist(:,2).^2) + (tdist(:,3).^2) );
        tdist(find(vOwn ~= 0)) = 1000;
        
        %If any voxels are still left
        if min(tdist) < 1000,
            
            %sort and select acceptable candidates
            [B,I] = sort(tdist);
            lastdist = find(B == 1000);
            B = B(1:lastdist(1)); %ne garder que les distances acceptables
            
            %Big loop only taken when there are at least one choice
            if length(B) > 1, 
                ii = 1; %serves as a counter on all the loop here
                
                %if there ise a tie between closest voxels
                dd = find(diff(B) > 0);%all all lowest equal values
                if ~isempty(dd) && dd(1) > 1,
                    newVox = randperm(dd(1)); %basically randomly pick equally distant voxels
            
                     while ii <= dd, %loop through the closest voxels to see wether they are contiguous to the atom or not
                        [aa bb cc] = ind2sub(size(mask),I(newVox(ii)));
                        tcub = NewVol(aa-1:aa+1,bb-1:bb+1,cc-1:cc+1);
                
                        IsAdjacent = find(tcub == nn);
                    
                        if ~isempty(IsAdjacent),
                            vOwn(I(newVox(ii))) = nn;
                            ii = length(B) + 2;
                        end
                        ii = ii +1;
                     end
                end  
                
                %loop for when the equally clossed ones are inexistent or
                %unacceptable
                while ii < length(B), %loop trhough closest voxel to verify contiguousness
                    [aa bb cc] = ind2sub(size(mask),I(ii));
                    tcub = NewVol(aa-1:aa+1,bb-1:bb+1,cc-1:cc+1);
                
                    IsAdjacent = find(tcub == nn);
                    
                    if ~isempty(IsAdjacent),
                        vOwn(I(ii)) = nn;
                        ii = length(B) + 2;
                    end
                    ii = ii +1;
                end
                
            end
        end
    end
    vAss = sum(vOwn > 0);%number of assigned voxels
end

%Smoothing volume to remove weird alone voxels
%opt.mask = NewVol > 0;
%opt.voxel_size = hdr.info.voxel_size;
%opt.fwhm = hdr.info.voxel_size;

hdr.file_name = files_out;
niak_write_vol(hdr,NewVol);



end