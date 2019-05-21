function [pvalues Average STDev] = PermutationTest(group1,group2,nperm,gnames),

[tt ng1] = size(group1);
[tt ng2] = size(group2);

g1Loc = 1:ng1;
g2Loc = (ng1+1):(ng1+ng2);

Average.(gnames{1}) = mean(group1,2); 
Average.(gnames{2}) = mean(group2,2); 

STDev.(gnames{1}) = std(group1,0,2); 
STDev.(gnames{2}) = std(group2,0,2);

Diff = Average.(gnames{1}) - Average.(gnames{2});
Pos = find(Diff > 0);
Neg = find(Diff < 0);

ConCat = [group1 group2];

[tt nPart] = size(ConCat);

Count = zeros(tt,1);

for pp = 1:nperm,
    Order = randperm(nPart);
    
    tGroup1 = ConCat(:,Order(g1Loc));
    tGroup2 = ConCat(:,Order(g2Loc));
    
    tDiff = mean(tGroup1,2) - mean(tGroup2,2);
    
    if ~isempty(Pos),
        tPos = tDiff(Pos) >= oDiff(Pos);
        Count(Pos) = Count(Pos) + tPos;
    end
    if ~isempty(Neg),
        tNeg = tDiff(Neg) <= oDiff(Neg);
        Count(Neg) = Count(Neg) + tNeg;
    end
end

pvalues = (Count+1)./(nperm+1);
end