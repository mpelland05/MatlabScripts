    function map = CreateColorMapScaled(CoType,scale)
%Create color maps selected by CoType
%1 red-> yellow
%2 red-> yellow (better)
%3 Blue -> green
%4 Nothing
%5 hue saturation value (HSV)
%6 JET
%7 Overlap (red, blue and yellow)
%8 Red
%9 Green
%10 Blue
%11 Red -> white
%12 Green-> white
%13 Blue-> white
%14 Purple -> white
%15 Black 
%16 Random
%17 Random jet
%18 Colors from lines
%this script needs to be corrected for when the division does not carry
%well (100/3 leads to leftovers

if CoType == 1,
	%RedYel
    Red = [linspace(0.5,1,round(scale./3)) ones(1,round(2.*scale./3))];
    Green = [zeros(1,round(scale./3)) linspace(0,1,round(scale./3)) ones(1,round(scale./3))]; 
    Blue = [zeros(1,round(2.*scale./3)) linspace(0,0.5,round(scale./3))];
elseif CoType == 2,
    %or
    Red = [linspace(192/256,1,scale)];
    Green = [linspace(0,1,scale)];
    Blue = [zeros(1,scale)];    
elseif CoType == 3,
    %BlueGreen
    Red = rot90([zeros(1,scale)],2);
    Green = rot90([linspace(1,0,scale)],2);
    Blue = rot90([linspace(192/256,1,scale)],2);  
elseif CoType == 4,
    %Gray (usefull when only want pos or neg of an image
elseif CoType == 5,
    %HSV 
    hue = linspace(0,1,scale);
    saturation = ones(1,scale);
    value = ones(1,scale);
    
    temp = hsv2rgb([hue' saturation' value']);
    
    Red = [temp(:,1)'];
    Green = [temp(:,2)'];
    Blue = [temp(:,3)'];  
    
elseif CoType == 6,
    %Jet
    Red = [zeros(1,.37.*scale) linspace(0,1,round(.23.*scale)) ones(1, .27.*scale) linspace(1,.5,round(.13.*scale)) ];
    Green = [zeros(1,.13.*scale) linspace(0,1,round(.23.*scale)) ones(1, .27.*scale) linspace(1,0,round(.23.*scale)) zeros(1,round(.14.*scale))];
    Blue = [linspace(0.5,1,round(.11.*scale)) ones(1, .27.*scale) linspace(1,0,round(.23.*scale)) zeros(1,round(.39.*scale))];

elseif CoType == 7,
    %Overlap of 2 different colours
    Red =   [1 0 0];
    Green = [1 0 1];
    Blue =  [0 1 0];

elseif CoType == 8,
    Red = linspace(0,1,scale);
    Green = zeros(1,scale);
    Blue = zeros(1,scale);  
elseif CoType == 9,
    Red = [zeros(1,scale.*.6) linspace(0,0.8,scale.*.4)];
    Green = linspace(0,1,scale);
    Blue = [zeros(1,scale.*.6) linspace(0,0.8,scale.*.4)]; 
elseif CoType == 10,
    Red = zeros(1,scale);
    Green = zeros(1,scale);
    Blue = linspace(0,1,scale);
elseif CoType == 11,
    Red = linspace(0,1,scale);
    Green = [zeros(1,scale.*.6) linspace(0,0.8,scale.*.4)];
    Blue = [zeros(1,scale.*.6) linspace(0,0.8,scale.*.4)]; 
elseif CoType == 12,
    Red = [zeros(1,scale.*.6) linspace(0,0.8,scale.*.4)];
    Green = linspace(0,1,scale);
    Blue = [zeros(1,scale.*.6) linspace(0,0.8,scale.*.4)]; 
elseif CoType == 13,
    Red = [zeros(1,scale.*.6) linspace(0,0.8,scale.*.4)];
    Green = [zeros(1,scale.*.6) linspace(0,0.8,scale.*.4)]; 
    Blue = linspace(0,1,scale);
elseif CoType == 14,
    Red = linspace(0,1,scale);
    Green = [zeros(1,scale.*.6) linspace(0,0.8,scale.*.4)]; 
    Blue = linspace(0,1,scale);
elseif CoType == 15,
    Red = zeros(1,scale);
    Green = zeros(1,scale);
    Blue = zeros(1,scale);
elseif CoType == 16,
    Red = rand(1,scale);
    Green = rand(1,scale);
    Blue = rand(1,scale);
elseif CoType == 17,
    Red = [zeros(1,.37.*scale) linspace(0,1,round(.23.*scale)) ones(1, .27.*scale) linspace(1,.5,round(.13.*scale)) ];
    Green = [zeros(1,.13.*scale) linspace(0,1,round(.23.*scale)) ones(1, .27.*scale) linspace(1,0,round(.23.*scale)) zeros(1,round(.14.*scale))];
    Blue = [linspace(0.5,1,round(.11.*scale)) ones(1, .27.*scale) linspace(1,0,round(.23.*scale)) zeros(1,round(.39.*scale))];
  
    ord = randperm(scale);
    Red = Red(ord);
    Green = Green(ord);
    Blue = Blue(ord);
elseif CoType == 18,
    Red = [ones(1,scale/4).*.85 ones(1,scale/4).*.494 ones(1,scale/4).*.466 ones(1,scale/4).*.635];
    Green = [ones(1,scale/4).*.325 ones(1,scale/4).*.1840 ones(1,scale/4).*.6740 ones(1,scale/4).*.078];
    Blue = [ones(1,scale/4).*.098 ones(1,scale/4).*.556 ones(1,scale/4).*.188 ones(1,scale/4).*.184];
end

map = zeros(length(Blue),3);
map(:,1) = Red; map(:,2) = Green; map(:,3) = Blue;

end