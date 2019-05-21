function CreateInteractionGraph(Data),
%Creates interaction graphs and saves both Graphs and images. 

Scale = 100;
%Seeds = {[96 39]}; %{[76 80] [76 99] [76 65]};%{[76 80] [76 99] [76 65] [96 15] [96 21] [96 33] [96 64] [96 70]}; %Interaction

Seeds = {[15 96]}; %{[21 84] [65 84] [84 96] [6 96] [15 96] [81 96] [84 96] [96 100] [96 100]};

tick = [-.1 .2 .5];%enter matrix of tick marks 
lim = [(tick(1)-0.05) (tick(3)+0.05)];%enter matrix of the limits of the graph

% Pairs of seeds showing the interaction effect. 
%{[96 2] [96 3] [96 6] [96 10] [96 13] ...
% [96 14] [96 15] [96 17] [96 18] [96 19] ...
% [96 21] [96 22] [96 23] [96 28] [96 29] ...
% [96 31] [96 39] [96 42] [96 50] [96 55] ...
% [96 62] [96 64] [96 70] [96 71] [96 73] ...
% [96 75] [96 81] [96 82] [96 84] [96 93] ...
% [96 94] [96 95] [96 98] [96 100] [40 6] ...
% [40 6] [40 15] [40 18] [40 22] [40 23] ...
% [40 39] [40 55] [40 81] [40 84] [40 94] ...
% [40 100] [65 6] [65 6] [65 13] [65 15] ...
% [65 22] [65 23] [65 29] [65 62] [65 71] ...
% [65 81] [65 84] [88 3] [88 6] [88 15] ...
% [88 29] [88 39] [88 55] [88 81] [88 84] ...
% [21 6] [21 15] [21 29] [21 55] [21 56] ...
% [21 84] [21 84] [80 6] [80 64] [80 76] ...
% [80 84] [84 82] [84 38] [84 14] [6 26] ...
% [6 26] [6 38] [6 82]};




GNam = 'CBvsSC_int_Graphs_';

for ii = 1:length(Seeds),
    figure, h = ShowGraphEffect(Data,Scale,Seeds{ii}(1),Seeds{ii}(2),1,3);

    set(gca, 'YLim', lim); 
    set(gca, 'YTick', tick);
    set(gca, 'YTickLabel', []);
    set(gca,'YColor', [0 0 0]);

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
    
    a = 10;
    
    %set(gcf,'Position', [100 100 800 800]);


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