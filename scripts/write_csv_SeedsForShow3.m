clear all

%%%%%%%%%%%%%%
%Column labels
%%%%%%%%%%%%%%%
opt.labels_y = {'index'};

%%%%%%%%%%%%%%
%Row labels
%%%%%%%%%%%%
opt.labels_x = {'ROI1' 'ROI2' };


%%%%%%%%%%%%%%%%%
%Covariate values
%%%%%%%%%%%%%%%%%
values(1,1)   =   38546; 
values(2,1)   =   136244; 

%%%%%%%%%%%
% write group csv
%%%%%%%%%%%
opt.precision = 2;
niak_write_csv('SeedsForShow3.csv',values,opt);
