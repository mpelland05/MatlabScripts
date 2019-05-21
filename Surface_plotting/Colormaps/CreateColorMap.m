function map = CreateColorMap(CoType),
%Create color maps selected by CoType

SCo = [1 0 1]; %Seed color
Gr = .7;%Color of gray background.

if CoType == 1,
	%RedYel
    Red = [Gr linspace(0.5,1,85) ones(1,170) SCo(1)];
    Green = [Gr zeros(1,85) linspace(0,1,85) ones(1,85) SCo(2)];
    Blue = [Gr zeros(1,170) linspace(0,0.5,85) SCo(3)];
elseif CoType == 2,
    %or
    Red = [Gr linspace(192/256,1,1000) SCo(1)];
    Green = [Gr linspace(0,1,1000) SCo(2)];
    Blue = [Gr zeros(1,1000) SCo(3)];    
elseif CoType == 3,
    %BlueGreen
    Red = [Gr zeros(1,1000) SCo(1)];
    Green = [Gr linspace(1,0,1000) SCo(2)];
    Blue = [Gr linspace(192/256,1,1000) SCo(3)];  
elseif CoType == 4,
    %Gray (usefull when only want pos or neg of an image
        %BlueGreen
    Red = [ones(1,1000).*Gr SCo(1)];
    Green = [ones(1,1000).*Gr SCo(2)];
    Blue = [ones(1,1000).*Gr SCo(3)];
elseif CoType == 5,
    %HSV 
    hue = linspace(0,1,1000);
    saturation = ones(1,1000);
    value = ones(1,1000);
    
    temp = hsv2rgb([hue' saturation' value']);
    
    Red = [Gr temp(:,1)' SCo(1)];
    Green = [Gr temp(:,2)' SCo(2)];
    Blue = [Gr temp(:,3)' SCo(3)];  
    
elseif CoType == 6,
    %Jet
    temp = colormap('jet');
    Red = [Gr temp(:,1)'];
    Green = [Gr temp(:,2)'];
    Blue = [Gr temp(:,3)'];

elseif CoType == 7,
    %Overlap of 2 different colours
    Red =   [Gr 1 0 0];
    Green = [Gr 1 0 1];
    Blue =  [Gr 0 1 0];
end

map = zeros(length(Blue),3);
map(:,1) = Red; map(:,2) = Green; map(:,3) = Blue;

end