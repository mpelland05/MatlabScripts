function [dval pval] = ks_test_max(dat1,dat2,distrib,test)
%This script will run a K-S testand output the statistic value and its
%related pvalue. If compairing two distributions, enter an empty string 
%for the third variable.
%
%dat1   matrix,first set of data
%dat2   matrix, second set of data, skipt with [] if comparing to
%       distribution
%distrib string, type of distribution to test
%               Implemented so far: 
%                            'Uniform' : flat distribution 
%test   string, carry test on shape only or distribution
%           use 'shape' or '' as input 
%
%Enter an empty matrix (i.e.: []) if you want to test against a
%distribution. Then, enter a string (i.e.: 'uniform') as third argurment 
%
%
%examples: [dval pval] = ks_test_max(dat1,[],'uniform','shape'); 
%or 
%          [dval pval] = ks_test_max(dat1,dat2,'',''); 

%%%%%%%%%%%%%%%%%%%%%%%%%
% Formating data
%%%%%%%%%%%%%%%%%%%%%%%%
switch test
    case 'shape'
        if isempty(dat2),
            tdat = dat1-min(dat1);
            mi = 0; ma = max(tdat);
            di = diff(sort(dat1)); di(find(di==0)) = []; mindist = min(di); %count number of steps for xx
            
            xx = mi:mindist:ma;
            cdat1 = zeros(size(xx));
            
            for ii=1:length(xx), cdat1(ii) = sum(tdat <= xx(ii)); end
            cdat1 = cdat1./length(dat1);
        else
            'not implemented yet'
            mi = min([min(dat1) min(dat2)]);
            ma = max([max(dat1) max(dat2)]);
            
        end
            
        for ii = 1:length(dat1),
         % = cumsum();
        end    
    otherwise
        'Not implemented yet'
end

%%%%%%%%%%%%%%%%%%%%%%%
%Creating distribution
%%%%%%%%%%%%%%%%%%%%%%
if isempty(dat2),
   switch distrib
       case 'uniform'
           cdat2 = cumsum( ones(1,length(xx))./(length(xx) ));
       case 'normal'
           x = mi:ma; u = mean(tdat); g = std(tdat);
           cdat2 = ( 1 + (erf( (x-u)./(g.*sqrt(2)) )))./2;
       otherwise
           'The specified distribution is not implemented'
   end
else %create cumulative distribution to compare 
     
end

dval = max(abs( cdat1-cdat2 ));

pval = 'Not impletmented yet, check a table';
end