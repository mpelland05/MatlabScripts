function info = max_visu_surf(data, ssurf, NumSeed, ShowSeed, varargin),
%Ex launching:info = max_visu_surf(data, ssurf, 1, 'yes');
%
%Prepares colormap for surface visualization and makes sure that low and
%high values are still represented even if they do not enter the range. 
%Also, png and .fig images of the graph will be save in teh current folder.
%
%data: 		the surface data to be shown.
%ssurf: 	the surface model to be used.
%NumSeed: 	The numbe of the seed to show.
%ShowSeedd: 	str: 'yes' or 'no'
%
%Option		Other inputs can be added, if so, make an Option structure containing:
%	.CoType: Colormap type: 1 and 2 stand for RedYel
%	.Limits: a matrix containing lower and upper bound limits. Can have
%               many of those if negative and positive limits are needed.
%                Limits must be put as rows. 
%	.Rot: A 4 x 2 matrix containing degrees of rotation for the
%               different images
%	.GName: Name that will be given to the saved files.
%	.lighting = 'none';
%	.out = '';%string with the name of the output folder
%
%Note: if using a map with negative and positive value and you want to only
%show either one, use colormap 4, it is gray and will not color one of the
%signs. 

fs = filesep;
format long; %makes sure that numbers aren't rounded too much.

%Setting default values
CoType = [2 3];%[2 3];
Limits = [2 4; -4 -2];
Rot = [15 5; -15 5; 0 -30; 0 -30];
GNam = 'CBvsSC_tvr_';%General name
NumView = [1 2 3 4];
Fout = Surfed;
seeds_surf = 'F:\MyStudies\Modularity\Modularity_OC_2016\mask\Occipital\Atoms_rand_OccBASC6_Right_surf.mat';

%Makes sure the dimensions or data are okay
if size(data,1) > size(data,2),
    data = data';
end

%Reading optional values
if nargin > 4,
    if isfield(varargin{1},'CoType'),   CoType = varargin{1}.CoType;end
    if isfield(varargin{1},'Limits'),   Limits = varargin{1}.Limits;end
    if isfield(varargin{1},'Rot'),      Rot = varargin{1}.Rot;end
    if isfield(varargin{1},'sName'),    GNam = varargin{1}.sName;end
    if isfield(varargin{1},'NumView'),  NumView = varargin{1}.NumView;end
    if isfield(varargin{1},'out'),      Fout = varargin{1}.out;end
    if isfield(varargin{1},'seeds_surf'),seeds_surf = varargin{1}.seeds_surf;end
end


%Set options
opt.limit = Limits;
%opt.material = 'dull'; 


%Creating colormaps. The process depends on the number of color
%maps required. 
%sum(size(Limits))
if sum(size(Limits)) == 3,
    opt.colormap = CreateColorMap(CoType);
    %Find values over and under limit and bring them to the limit. 
    MinLim = Limits(1);
    MaxLim = Limits(2);
    
    if min(size(data)) < 2,
        datatot = data;
        datatot(find( data~=0 & data<=MinLim )) = MinLim.*1.1;
    
        datatot(find( data>=MaxLim )) = MaxLim.*.9;
    else
        datatot = data(:,NumSeed);
        datatot(find( data(:,NumSeed)~=0 & data(:,NumSeed)<=MinLim )) = MinLim.*1.1;
    
        datatot(find( data(:,NumSeed)>=MaxLim )) = MaxLim.*.9;
    end
    
else
    %Create positive data.
    if size(data,1) > 1, Pos = data(:,NumSeed); else Pos = data(:);end
    Pos(find(Pos < 0)) = 0;
    pp = find(max(sum(Limits,2)) == sum(Limits,2)); %finds which of the limits is for the positive scale
    pMiLim = min(Limits(pp,:));
    pMaLim = max(Limits(pp,:));
    
    Pos(find( Pos~=0 & Pos<=pMiLim )) = pMiLim.*1.1;
    Pos(find( Pos>=pMaLim )) = pMaLim.*0.9;
    
    
    %Create negative data.
    if size(data,1) > 1, Neg = data(:,NumSeed); else Neg = data(:);end
    Neg(find(Neg > 0)) = 0;
    nn = find(min(sum(Limits,2)) == sum(Limits,2)); %finds which of the limits is for the positive scale
    nMiLim = min(Limits(nn,:));
    nMaLim = max(Limits(nn,:));
    
    Neg(find( Neg~=0 & Neg>=nMaLim )) = nMaLim.*1.1;
    Neg(find( Neg<=nMiLim )) = nMiLim.*0.9;
    
        
    %Puts positive and negative data together. 
    datatot = Pos + Neg;
    
    %Finds the real min and maximum values of the data.
    MaxLim = max(max(Limits));
    MinLim = min(min(Limits));
    
    %Create positive colormap
    PosCoMap = CreateColorMap(CoType(1));
    %Create negative colormap
    NegCoMap = CreateColorMap(CoType(2));
    %Put positive and negative together. 
        %Measure number of color steps per unit of the scale. 
        nCoStep = length(NegCoMap)-1;
        InInterv = pMaLim - pMiLim;
        StepPerInt = nCoStep/InInterv;
        SizGrayArea = floor((pMiLim - nMaLim).*StepPerInt);
        
        if ceil(SizGrayArea/2) == (SizGrayArea/2), %number is even
            SizGrayArea = SizGrayArea - 1;
        end
        
        opt.colormap = [NegCoMap; ones(SizGrayArea,3).*0.7; PosCoMap];%Creates the finalized matrix of the color map.
    
   opt.limit = [MinLim MaxLim];

end


%Places seed. 
if strcmp(ShowSeed,'yes'),
    %Gets the seed
    temp = load(seeds_surf,'data');
    sSeed = temp.data == NumSeed;
    datatot(find(sSeed > 0)) = MaxLim+1;
end

%show figure
info = niak_visu_surf_vMax(datatot,ssurf,opt);

%Rotate images
set(gcf, 'CurrentAxes', info(1)); camorbit(Rot(1,1),Rot(1,2)); camlight right;
set(gcf, 'CurrentAxes', info(2)); camorbit(Rot(2,1),Rot(2,2)); camlight left;
set(gcf, 'CurrentAxes', info(3)); camorbit(Rot(3,1),Rot(3,2)); camlight right;
set(gcf, 'CurrentAxes', info(4)); camorbit(Rot(4,1),Rot(4,2)); camlight left;
set(gcf,'Position', [100 100 1100 780]);


                        %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% Extra options %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %%%%%%%%%%%%%%%%%

%Removes legend
Leg = get(gcf,'Children'); delete(Leg(1));

%Sets papers size to pring well
%set(gcf,'PaperPosition', [18 180 550 400]);%,'PaperSize',[550 400]);
resolution = 400; OSiz = [1100 780];
set(gcf,'paperunits','inches','paperposition',[0 0 OSiz/resolution]);

%Remove panels of non interest
clf(info(NumView));

%Prints the figure in a tiff file at 400 dpi
%GNam = sName;%General name
print('-r600','-dpng', strcat(Fout,fs,GNam,num2str(NumSeed)))
saveas(gcf,strcat(Fout,fs,GNam,num2str(NumSeed)),'fig');
end