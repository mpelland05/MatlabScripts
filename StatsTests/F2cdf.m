function pce = F2cdf(Fvalue,df1,df2),

pce = zeros(size(Fvalue));

for ii = 1:length(pce),
    
    pce(ii) = betainc( ( (df1.*Fvalue(ii))./((df1.*Fvalue(ii))+df2)  ) ,df1/2,df2/2);

    if pce(ii) > .5,
        pce(ii) = 1 - pce(ii);
    end
end