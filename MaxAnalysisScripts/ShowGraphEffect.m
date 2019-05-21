function h = ShowGraphEffect(Data,NNets,varargin),
%lines on how to show many different statistical significance
%test_q = tril(test_q);
%[aa bb] = find(test_q == 1);
%ShowGraphEffect(Data,100,aa(ii),bb(ii),1,2)


if nargin <1,
    seed(1) = 9;        %seed(1),seed(2)
    seed(2) = 2;

    group(1) = 1;
    group(2) = 2;
else
    seed(1) = varargin{1};        %seed(1),seed(2)
    seed(2) = varargin{2};

    group(1) = varargin{3};
    group(2) = varargin{4};
end
    
Nets = strcat('sci',num2str(NNets),'_scg',num2str(NNets),'_scf',num2str(NNets));

 h.h1 = errorbar([Data.(Nets).rest.Groups{group(1)}.Effect(seed(1),seed(2)) Data.(Nets).task.Groups{group(1)}.Effect(seed(1),seed(2))], ...
     [Data.(Nets).rest.Groups{group(1)}.Std(seed(1),seed(2)) Data.(Nets).task.Groups{group(1)}.Std(seed(1),seed(2))],'go-');
 hold on
 h.h2 = errorbar([Data.(Nets).rest.Groups{group(2)}.Effect(seed(1),seed(2)) Data.(Nets).task.Groups{group(2)}.Effect(seed(1),seed(2))], ...
     [Data.(Nets).rest.Groups{group(2)}.Std(seed(1),seed(2)) Data.(Nets).task.Groups{group(2)}.Std(seed(1),seed(2))],'ro-');
 
 hold off
end