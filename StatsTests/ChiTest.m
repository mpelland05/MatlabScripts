function [ChiVal df] = ChiTest(OO,EE),
%Obtain chi value from probabilities
%OO (observed) should be a iixjjxntest matrix
%dime str, 'row' or 'col' when comparing CB and SC, use col

gtot = sum(sum(OO(:,:,1)));
ctot = sum(OO,1);
rtot = sum(OO,2);

if isempty(EE)
    EE = zeros(size(OO));
    for tt = 1:size(EE,3),
        EE(:,:,tt) = rtot(:,:,tt)*ctot(:,:,tt)./gtot;
    end
end

ChiVal = zeros(1,size(OO,3));

for tt = 1:size(OO,3),
    tsum = sum(EE(:,:,tt),2);
    if tsum(1) ~= 0,
        temp = ((OO(:,:,tt) - EE(:,:,tt)).^2) ./EE(:,:,tt);
        temp = sum(sum(temp));
        ChiVal(tt) = temp;
    else
       ChiVal(tt) = 0; 
    end
end

df = (size(OO,1)-1).*(size(OO,2)-1);

clear EE;
end