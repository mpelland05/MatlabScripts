function CompareCores(Group1,Group2),
%Script will obtain a matrix of the percentage of a partition belonging to 
%another partition for every pairs of partitions found in two different 
%volumes. Rows represent each partition and columns the partition they are
%compared to.

[hdr,g1] = niak_read_vol(Group1);
[hdr,g2] = niak_read_vol(Group2);

nNets = unique(g1); nNets = nNets(2:length(nNets));

Comparison.Group1 = zeros(length(nNets));
Comparison.Group2 = zeros(length(nNets));

for ii=1:length(nNets),
    for jj=1:length(nNets),
        Loc1 = find(g1 == ii);
        Loc2 = find(g2 ==jj);
        Comparison.Group1(ii,jj) = length(intersect(Loc1,Loc2))/length(Loc1);
    end
end

for ii=1:length(nNets),
    for jj=1:length(nNets),
        Loc1 = find(g1 == ii);
        Loc2 = find(g2 ==jj);
        Comparison.Group2(ii,jj) = length(intersect(Loc1,Loc2))/length(Loc2);
    end
end

end
%Group1 = 'C:\Users\Maxime Pelland\Desktop\CompCores\CB.nii'
%Group2 = 'C:\Users\Maxime Pelland\Desktop\CompCores\SC.nii'