function [ndata limits] = maxime_vol2surfVoxels(data, vol, msurf, contour)
%This script will take a 3d nii volume, and extract a surface from it based
%on a volume and surface of reference. Basically, this avoids using
%minctools to surf data, but it is dependent on the fact that the volume to
%surf(data) is in a specific space (vol) that was surface to (surf)
%already. 
%
%data   string, path to a .nii volume
%vol    string, path to a .nii volume that has previously been surface
%surf   string, path to the .mat file containing the surf of the previous
%       volume
%contour
%       .show   boolean, whether the data in the volume should be
%               transformed into a contour
%       .limits
%           .minmax matrix, a X 2, with lower and upper limit
%                  . Note that the upper vallue of [-4 -2] is -2!
%           .over   boolean, should numbers over or above the limits be
%                   shown. number of data X 2, (1 number below data, 2
%                   number above data) for each
%
fs =filesep;

limits = contour.limits;

[hdr ovol] = niak_read_vol(data); %original volume
[hdr mvol] = niak_read_vol(vol); %model volume
ss = load(msurf); msurf = ss.data;
ndata = zeros(size(msurf)); %new data

%Deal with negative/set negative to positive
if limits.minmax(1) < 0, 
    ovol = ovol.*-1; 
    limits.minmax = abs(limits.minmax);
    limits.over = rot90(limits.over,2);
end

%%%%%%%%%%%%%
% Transform volume into contour if needed
%%%%%%%%%%%
if contour.show,
    
    %Set limits
    uloc = find( (ovol > 0).*(ovol < min(limits.minmax)) );
    oloc = find( ovol > max(limits.minmax) );
    if limits.over(1), ovol(uloc) = min(limits.minmax);else ovol(uloc) = 0;end
    if limits.over(2), ovol(oloc) = max(limits.minmax);else ovol(oloc) = 0;end
    
    %Make into a mask
    ovol = ovol > 0; 
    
    %Convolve to get contour
    ovol = convn(ovol,(ones(3,3,3)),'same');
    ovol = (ovol < 27).*(ovol > 0);
end

ovol = ovol.*(ovol > 0);

%%%%%%%%%%%%
% Main loop
%%%%%%%%%%%%
uni = unique(msurf); if uni(1) == 0, uni(1) = [];end

for uu = 1:length(uni),
    vloc = find(mvol == uni(uu));
    sloc = find(msurf == uni(uu));
    ndata(sloc) = ovol(vloc(1));
end