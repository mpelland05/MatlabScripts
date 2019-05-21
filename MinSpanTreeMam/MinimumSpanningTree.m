%MinimumSpanningTree
%
% Usage
% * |MinimumSpanningTree(/weights/)| calculates a Minimum Spanning Tree of the grid graph with given weight matrix.
%
% Notes
% * The returned value is the weighted adjacency matrix of a Minimum Spanning Tree.
% * Option |Method="Prim"| uses Prim's algorithm (non deterministic).  This is the default.
% * Option |Method="Kruskal"| uses Kruskal's algorithm.
% * Implemented by Fan Zhang <zfan@cs.york.ac.uk>

function adjacency = MinimumSpanningTree(weights,option_Method)
  option_Method = 'Kruskal'
  
  %DeveloperParseOptions(varargin);
  
  switch(option_Method)
   case 'Kruskal'
    adjacency = KruskalMst(weights);
   case 'Prim'
    [t, r, w, u] = PrimMst(weights);
    adjacency = w;
   otherwise
    Print('MinimumSpanningTree does not know the method you are trying to use, sorry');
  end
  
%...........................................
%Authour: Fan Zhang
%Email: zfan@cs.york.ac.uk
%File Create Date: 06/03/2005
%...........................................

% functions: Kruskal's algorithm to find a minimum spanning tree (mst) of a graph
%input:
%A: the weighted adjacency matrix of a graph
%if i not connect with nod j, than A(i,j)<=0,usually A(i,j) = 0 or -1;
%output:
%WTreeMatrix: The weighted adjacency matrix of mst
%UnwTreeMatrix: The unweighted adjacency matrix of mst



function [TreeMatrix] = KruskalMst(A)

VertexNumber = size(A,1);

%construct edgelist
count = 1;
for i = 1:VertexNumber
    for j = (i+1):VertexNumber
        if A(i,j) > 0
            EdgeList(count,1) = i;
            EdgeList(count,2) = j;
            EdgeList(count,3) = A(i,j);   
            count = count + 1;
        end
    end
end

%sort edges

EdgeList = sortrows(EdgeList,3);

TreeMatrix = zeros(size(A));

j = 1;
for i = 1:(VertexNumber-1)
    while true
       if CheckCircuit(TreeMatrix,EdgeList(j,1),EdgeList(j,2)) < 0
           TreeMatrix(EdgeList(j,1),EdgeList(j,2)) = 1;
           TreeMatrix(EdgeList(j,2),EdgeList(j,1)) = 1;
           j = j+1;
           break;
       else
          j = j+1; 
       end
    end   
end

%...........................................
%Authour: Fan Zhang
%Email: zfan@cs.york.ac.uk
%File Create Date: 06/03/2005
%...........................................

% functions: Check whether node a and b is connected in a subtree forest
%input:
%A: the weighted adjacency matrix of a graph
%if i not connect with nod j, than A(i,j)<=0,usually A(i,j) = 0 or -1;
%a,b: the input nodes
%output:
%res: 1 connected; -1 not connected



function [res] = CheckCircuit(A, a, b)

VertexNumber = size(A,1);

res = -1;

for i = 1:(VertexNumber-1)
   con = A^i;
   if con(a,b) > 0
      res = 1;
      break;
   end    
end

%...........................................
%Authour: Fan Zhang
%Email: zfan@cs.york.ac.uk
%File Create Date: 25/02/2005
%...........................................

% functions: prim's algorithm to find a minimum spanning tree (mst) of a graph
%input:
%A: the weighted adjacency matrix of a graph
%if i not connect with nod j, than A(i,j)<=0,usually A(i,j) = 0 or -1;
%output:
%Tree: The path of the mst
%Root: The start node used to construct the tree
%WTreeMatrix: The weighted adjacency matrix of mst
%UnwTreeMatrix: The unweighted adjacency matrix of mst


function [Tree, Root, WTreeMatrix, UnwTreeMatrix] = PrimMst(A)
pseudorand = 0.5; % I want it repeatable (fraile)
  
Infinity = 1.0e+10; 

VertexNumber = size(A,1);

start = floor(pseudorand * VertexNumber) + 1;
Root = start;
array1(1,1) = start;

%array(:,1) V-T array(:,2) T
%DeveloperProgress(false);
for i = 1:VertexNumber
 % DeveloperProgress(i/VertexNumber);
    if i < start
        array2(i,1) = i;
        array2(i,2) = start;
        if A(i,start) <= 0
            array2(i,3) = Infinity;
        else
            array2(i,3) = A(i,start);
        end
    elseif i > start
        array2(i-1,1) = i;
        array2(i-1,2) = start;
        if A(i,start) <= 0
            array2(i-1,3) = Infinity;
        else
            array2(i-1,3) = A(i,start);
        end
    end
    
end

loopnumber = size(array2,1);
Tree=zeros(VertexNumber,3);
%DeveloperProgress(false);
for i = 1:loopnumber
    %DeveloperProgress(i/loopnumber);

    [c,mini] = min(array2(:,3));
    
    array1(i+1,1) = array2(mini,1);
    addednode = array2(mini,1);
   
    Tree(addednode,1) = array2(mini,1);
    Tree(addednode,2) = array2(mini,2);
    Tree(addednode,3) = array2(mini,3);
    
    array2(mini,:) = [];
    
    %refresh the array2
    for m = 1:size(array2, 1)
        if (array2(m,3) > A(array2(m,1), addednode)) && (A(array2(m,1), addednode) > 0)
            array2(m,2) = addednode;
            array2(m,3) = A(array2(m,1), addednode);
        end        
    end
    
end

% modified to sparse by Roberto, to avoid memory problems
UnwTreeMatrix = sparse(size(A));
WTreeMatrix = sparse(size(A));
%DeveloperProgress(false);
for i = 1:size(Tree,1)
  %DeveloperProgress(i/size(Tree,1));
    if Tree(i,1) ~= 0
        UnwTreeMatrix(Tree(i,1), Tree(i,2)) = 1;
        UnwTreeMatrix(Tree(i,2), Tree(i,1)) = 1;
        WTreeMatrix(Tree(i,1), Tree(i,2)) = A(Tree(i,1), Tree(i,2));
        WTreeMatrix(Tree(i,2), Tree(i,1)) = A(Tree(i,2), Tree(i,1));
    
    end

end