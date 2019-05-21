function CreateInteractionGraph_All(Data),
%Creates interaction graphs and saves both Graphs and images. 

Scale = 100;
%Seeds = {[96 39]}; %{[76 80] [76 99] [76 65]};%{[76 80] [76 99] [76 65] [96 15] [96 21] [96 33] [96 64] [96 70]}; %Interaction

% Pairs of seeds showing the interaction effect. 
Seeds ={[2 96] [3 88] [3 96] [6 21] [6 26] ...
    [6 38] [6 40] [6 65] [6 80] [6 82] ...
    [6 88] [6 96] [10 96] [13 65] [13 96] ...
    [14 84] [14 96] [15 21] [15 40] [15 65] ...
    [15 88] [15 96] [17 96] [18 40] [18 96] ...
    [19 96] [21 29] [21 55] [21 56] [21 84] ...
    [21 96] [22 40] [22 65] [22 96] [23 40] ...
    [23 65] [23 96] [28 96] [29 65] [29 88] ...
    [29 96] [31 96] [38 84] [39 40] [39 88] ...
    [39 96] [40 55] [40 81] [40 84] [40 94] ...
    [40 100] [42 96] [50 96] [55 88] [55 96] ...
    [62 65] [62 96] [62 97] [64 80] [64 96] ...
    [65 71] [65 81] [65 84] [70 96] [71 96] ...
    [73 96] [75 96] [76 80] [80 84] [81 88] ...
    [81 96] [82 84] [82 96] [84 88] [84 96] ...
    [93 96] [94 96] [95 96] [96 98] [96 100] ...
    };

GNam = 'CBvsSC_int_Graphs_';

for ii = 1:length(Seeds),
    figure, h = ShowGraphEffect(Data,Scale,Seeds{ii}(1),Seeds{ii}(2),1,3);
    
    set(gca, 'PlotBoxAspectRatioMode', 'manual');
    
    ylim = get(gca, 'YLim');
    tick = [ylim(1) mean(ylim) ylim(2)];
    %stick = {num2str(tick(1)) num2str(tick(2)) num2str(tick(3))}
    dd = diff(ylim).*0.1;%difference to set the limits
    
    set(gca, 'FontName', 'Arial', 'FontSize', 33, 'FontWeight', 'Demi');       
    tl{1} = [num2str(ylim(1)) ' ']; tl{2} = [num2str(mean(ylim)) ' ']; tl{3} = [num2str(ylim(2)) ' '];
    
    set(gca, 'YLim', [ylim(1)-dd ylim(2)+dd]); 
    set(gca, 'YTick', tick);
    set(gca, 'YTickLabel', tl );
    set(gca,'YColor', [0 0 0]);

    set(gca, 'XLim', [0.8 2.2]); 
    set(gca, 'XTickLabel',[]); 
    set(gca, 'XTick',[]);
    set(gca,'XColor', [0 0 0]);

    set(gca, 'LineWidth', 6);
    
    set(h.h1,'LineWidth',6); set(h.h1,'Marker','None'); %set(h.h1, 
    set(h.h2,'LineWidth',6); set(h.h2,'Marker','None');
    
    h1 = findall(h.h1);
    h2 = findall(h.h2);
    
    mat1 = get(h1(3),'XData');
    mat2 = get(h2(3),'XData');
    
    mat1([4 7]) = 0.97; mat1([5 8]) = 1.03; mat1([13 16]) = 1.97; mat1([14 17]) = 2.03;
    set(h1(3),'XData',mat1);
    set(h1(1),'Color',[92 190 92]./255); 
    
    mat2([4 7]) = 0.97; mat2([5 8]) = 1.03; mat2([13 16]) = 1.97; mat2([14 17]) = 2.03;
    set(h2(3),'XData',mat2);
    set(h2(1),'Color',[81 81 202]./255);
    
    title(strcat({'Networks # '}, num2str(Seeds{ii}(1)) ,{' and '}, num2str(Seeds{ii}(2)), {      } ), 'FontSize', 39, 'FontWeight', 'Bold' );
    
    %set(gcf,'Position', [100 100 400 500]);

                        %%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%% Extra options %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %%%%%%%%%%%%%%%%%

    %Sets papers size to pring well
    %resolution = 400; OSiz = [800 800];
    %set(gcf,'paperunits','inches','paperposition',[0 0 OSiz/resolution]);

    %Prints the figure in a tiff file at 400 dpi
    print( '-r400','-dpng', strcat(GNam,num2str(Seeds{ii}(1)),'_', num2str(Seeds{ii}(2))) );
    saveas(gcf,strcat( GNam,num2str(Seeds{ii}(1)),'_', num2str(Seeds{ii}(2))) ,'fig' );
end
end