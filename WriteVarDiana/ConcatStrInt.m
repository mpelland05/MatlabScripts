function con = ConcatStrInt(str,nItems,xlsname),
%This script was made for Diana to get list of variables with numbers.
%str:       cell array, string at the beginning of the name 
%nItems:    int or matrix,number of itmes for each string the matrix must
%                       be the same length as the cell array of "str"
%xlsname:   string, full path to the xls in which it will be saved
%
%example input:
%   str = {'id' 'ego'};
%   nItems = [20 12];
%   xlsname = 'C:\Users\Maxime Pelland\Desktop\Results';

cc = 1;
for ss = 1:length(str),
    for ii = 1:nItems(ss),
        con{cc} = strcat(str{ss},num2str(ii));
        cc = cc +1;
    end
end
    
    
xlswrite(strcat(xlsname,'.xls'),cellstr(char(con)));
end