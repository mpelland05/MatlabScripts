function data = max_vol2surf(files_in)
%First version of script that will avoid the issue of always having to surf
%stuff. This will only work with ROI data. 
%files_in.
%           surf   .mat file containing a surface map which indexes the
%                   various ROIs using integers. The name of the surface
%                   map should be " data "
%           vol     volume indexing the ROIs with integers. The volume must
%                   match with the surface above.
%           seeds   vector containinng the seeds that must be transferred. 
%           vol2trans   volume that must be transfered to a surface. 

seeds = files_in.seeds;
load(files_in.surf);
odata = data; 
data = zeros(size(odata));

[hdr vol] = niak_read_vol(files_in.vol);
[hdr vol2trans] = niak_read_vol(files_in.vol2trans);

if strcmp(seeds,'all'),		tseeds = seeds; seeds = unique(odata(find(odata>0))); 	end

for ss = 1:length(seeds),
   locv = find(vol == seeds(ss)); 
   locs = find(odata == seeds(ss));
   if ~isempty(locv),
     tval = vol2trans(locv(1));
     data(locs) = tval;
   end   
end

end