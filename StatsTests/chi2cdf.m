function p = chi2cdf(ChiVal,df),
%Takes value of Chi and finds their probability
%df = int, degrees of freedom 
%ChiVal = int, vector, matrix, the Chi values

p = zeros(size(ChiVal));

for ii = 1:numel(ChiVal),
    x = ChiVal(ii); v = df;
    
    p(ii) = real(gammainc(max(x,0)/2,v/2));
end

p = 1 - p;
end