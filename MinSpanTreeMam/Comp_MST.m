AnalName = 'MST'%Name of analysis

for ee = 1:length(ext),
  Smallest = 0;
  for cc = 1:length(Cond),
    for gg = 1:length(Groups),
      [xx yy numPart] = size(ConnMatrix.(Cond{cc}).(Groups{gg}).(ext{ee}));%get num of participants
          
        %Create result mat
        ConnMatrix.(Cond{cc}).(Groups{gg}).(strcat(ext{ee},'_tree')) = zeros(xx,xx,numPart);
          
      for kk = 1:numPart,
	kk
            temp =  ConnMatrix.(Cond{cc}).(Groups{gg}).(ext{ee})(:,:,kk).*-1; %-1 is to get the maximum spanning Tree.
             
            %Get measure
            [adjacency, cost] =  minSpanTreeKruskal(temp);

            %Put measure in result mat
            ConnMatrix.(Cond{cc}).(Groups{gg}).(strcat(ext{ee},'_tree'))(:,:,kk) = adjacency;
            
	    
            Per = sum(sum(adjacency))/((xx.*(xx-1)));
	    if Per > Smallest, Smallest = Per;end
      end

      ConnMatrix.(Cond{cc}).(Groups{gg}).(strcat(ext{ee},'_MinThresh')) = Smallest;

    end
  end
  
end

%save(strcat(BaseP,'CompiledConnectivityMatrices.mat'),ConnMatrix);
save('-mat-binary','CompiledConnectivityMatrices.mat','ConnMatrix');
