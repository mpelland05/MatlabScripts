function zval = max_wilcox(x1,x2)
%This script will perforce the wilcoxon signed rank test on data. The output is a simpe z-value
%Positive values means x2 > x1
%Test is done on multiple sample at once. Rows represent different tests
%Columns represent data within the tests.
% so NumData x NumTest

%Basic calculations
diff = x2-x1;
adiff = abs(diff);
adiff(find(adiff == 0)) = [];
len = size(adiff);
nr = len(1);

%Finding order of data
[sadiff so] = sort(adiff);
sso = so + len(1)*repmat((0:len(2)-1),len(1),1);% % Allows to reorder two dimensional matrix

sdiff = diff(sso);

%Calculating test value
rks = repmat((1:len(1)),len(2),1 )';
ww = sum(rks.*sign(sdiff));


%calculating z score
sw = sqrt( ( nr*(nr+1)*((2*nr)+1) )/6 );
zval = ww./sw;


end