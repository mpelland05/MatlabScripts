function info = maxime_visu_surf(files_in, files_out, opt)
%ssurf, NumSeed, ShowSeed, varargin),
%Important note: this is a updated version of max_visu_surf
%It is modified to be more self sustained. 
%
%Prepares colormap for surface visualization and makes sure that low and
%high values are still represented even if they do not enter the range. 
%Also, png and .fig images of the graph will be save in teh specified folder.
%
%files_in
%       .data   cells of strings, full path to or to file(s), if multiples, they will
%               all be put on the brain, note that the order will affect
%               which one overlaps which one. The first will overlap all
%               others. The last will be hidden behind the others. 
%               **Important note: if data contains positive and negative,
%               and you want to see both, enter it twic, each with
%               different limits (see opt)
%                
%       .ssurf  string, full path to file to the model to be used
%
%files_out      string, path to folder where to put the result use '' if you want 
%               to use the same path and name as the input files
%    
%opt    (if you want defaults, simply input empty structure)
%       .coType     matrix, number of data X 1, CoTypes are described in 
%                   CreateColroMap.mat
%                   if the matrix size is smaller than the number of data,
%                   the same color will be used for each
%       .contour      
%           .show   boolean matrix, # of data x 1. Default, 0s. Can only be
%                   used if data is an fMRI volume. Instead of showing the
%                   whole image, only the outline will be shown
%           .color  matrix, #data X 3, RBG definition of the contour color. Default
%                   is black.  
%
%       .limits     
%           .minmax matrix, number of data X 2, with lower and upper limit
%                   for each. Note that the upper vallue of [-4 -2] is -2!
%           .over   boolean, should numbers over or above the limits be
%                   shown. number of data X 2, (1 number below data, 2
%                   number above data) for each
%
%       .numView    matrix listing the pannels to be viewed
%
%       .out
%           .name string, name of output file if different from first
%                           input
%           .append string, appended string after name of file (default:
%                           surfed)
%           .subfold strin, name of subfoleder in which to put data. 
%
%       .rot       matrix, 2 X 4, rotations applied to all 4 resulting
%                   pannels
%       .seed
%           .show   boolean, show the seed or not
%           .color  matrix, 3x1 matrix for RGB color
%           .num    int, number of the seed
%           .file   string, full path to seed file
%
%       .volRefs        
%           .vol    cells of strings, for for each ndata if ANY of them
%                   is volume. If some are already surfaced, then put
%                   an empty string. This is the volume of reference.
%           .surf   cells of strings, for for each ndata if ANY of them
%                   is volume. If some are already surfaced, then put
%                   an empty string. This is the surface of reference.
    

fs = filesep;

%%%%%%%%%%%%%%%%%
%Set up variables
%%%%%%%%%%%%%%%%%

%Setting inputs
data = files_in.data;
ssurf = files_in.ssurf;

%Reading optional values/setting defaults/warnings
sdata = length(data);

if isfield(opt,'coType'),   coType = opt.coType;    else coType = [2];                    end
  if ~ismember(size(coType,1),[1,sdata]), error('opt.coType is not the same size as the number of data');end
  if size(coType,1) == 1, coType = repmat(coType,sdata,1);end
  
if isfield(opt,'contour'),
    if isfield(opt.contour, 'show'),   contour.show = opt.contour.show;     else contour.show = zeros(length(data),1);        end
    if isfield(opt.contour, 'color'),  contour.color = opt.contour.color;   else contour.color = [0 0 0];                     end
  if ~ismember(size(contour.show,1),[1,sdata]), error('opt.contour.show is not the same size as the number of data');end
  if ~ismember(size(contour.color,1),[1,sdata]), error('opt.contour.colr is not the same size as the number of data');end
    if size(contour.show,1) == 1, contour.show = repmat(contour.show,sdata,1);end
    if size(contour.color,1) == 1, contour.color = repmat(contour.color,sdata,1);end
end
  
if isfield(opt,'limits'),  else opt.limits.minmax = [1 2]; opt.limits.over = 0; end;             
    if isfield(opt.limits, 'minmax'), limits.minmax = opt.limits.minmax; else limits.minmax = [2 4];    end
    if isfield(opt.limits, 'over'),   limits.over = opt.limits.over;     else limits.over = [1 1];      end
  if ~ismember(size(limits.minmax,1),[1,sdata]), error('opt.limits.minmax is not the same size as the number of data');end
  if ~ismember(size(limits.over,1),[1,sdata]), error('opt.limits.over is not the same size as the number of data');end
    if size(limits.minmax,1) == 1, limits.minmax = repmat(limits.minmax,sdata,1);end
    if size(limits.over,1) == 1, limits.over = repmat(limits.over,sdata,1);end

if isfield(opt,'numView'),  numView = opt.numView;  else numView = [1 2 3 4];               end

[pp,nn,ee] = fileparts(data{1});
if strcmp('',files_out),  files_out = pp;end

if ~isfield(opt, 'out'),
    out.name = nn; out.append = ''; 
else
    if isfield(opt.out, 'name'),   out.name = opt.out.name;     else  out.name = nn;            end
    if isfield(opt.out, 'append'), out.append = opt.out.append; else out.append = '';           end
    if isfield(opt.out, 'subfold'), files_out = strcat(files_out,fs,opt.out.subfold);           end
end

if isfield(opt,'rot'),      rot = opt.rot;          else rot = [15 5; -15 5; 0 -30; 0 -30]; end

if isfield(opt,'seed'), 
    if isfield(opt.seed, 'show'),  seed.show = opt.seed.show;   else seed.show = 0;         end
    if isfield(opt.seed, 'color'), seed.color = opt.seed.color; else seed.color = [1 0 1];  end
    if isfield(opt.seed, 'num'),   seed.num = opt.seed.num;     else seed.num = 0;          end
    if isfield(opt.seed, 'file'),  seed.file = opt.seed.file;   else seed.file = '';        end
else seed.show = 0; end

if isfield(opt,'volRefs'),
    if isfield(opt.volRefs, 'vol'),  volRefs.vol = opt.volRefs.vol;     end
    if isfield(opt.volRefs, 'surf'), volRefs.surf = opt.volRefs.surf;   end
  if ~ismember(length(volRefs.vol),[1,sdata]), error('opt.volRefs.vol is not the same size as the number of data');end
  if ~ismember(length(volRefs.surf),[1,sdata]), error('opt.volRefs.surf is not the same size as the number of data');end
    %if size(volRefs.vol,1) == 1,  for ii = 2:sdata, volRefs.vol{ii} = volRefs.vol{1};end;end
    %if size(volRefs.surf,1) == 1, for ii = 2:sdata, volRefs.surf{ii} = volRefs.surf{1};end;end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Script Starts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%
%Go through the different data and compil them. 
%%%%%%%%%%%%%%%%
for dd = length(data):-1:1,
    %transform volume to data
   [pp nn ee] = fileparts(data{dd});
   if strcmp(ee, '.nii') + strcmp(ee,'.gz'),
        tcont.show = contour.show(dd); tcont.color = contour.color(dd,:);
        tcont.limits.minmax = limits.minmax(dd,:);
        tcont.limits.over = limits.over(dd,:);
        [tdata tlimits] = maxime_vol2surfVoxels(data{dd},volRefs.vol{dd},volRefs.surf{dd},tcont);%this script will take in path to data, ref vol, ref sur, and info on contour (with whether to show and color)
        limits.minmax(dd,:) = tlimits.minmax;
        limits.over(dd,:) = tlimits.over;
        %tdata = tdata.*( max(abs(limits.minmax(dd,:))) - min(abs(limits.minmax(dd,:))) );   
   else
       aa = load(data{dd}); tdata = aa.data;
   end
   %Makes sure the dimensions or data are okay
   if size(data,1) > size(data,2),
        tdata = tdata';
   end
   
   %Deal with negative/set negative to positive -> all data to be plotted
   %is set to positive, so are limits and over are rotated 180o to fit. 
   tmmax = limits.minmax(dd,:);
   tover = limits.over(dd,:);
   if tmmax(1) < 0, tdata = tdata.* -1; tmmax = rot90(tmmax,2).*-1; tover = rot90(tover,2);end   
   
   %Set limits
   uloc = find( (tdata > 0).*(tdata < (tmmax(1))) );
   oloc = find(tdata > tmmax(2));
   if tover(1), tdata(uloc) = tmmax(1);else tdata(uloc) = 0;end
   if tover(2), tdata(oloc) = tmmax(2);else tdata(oloc) = 0;end

   %normalize
   tdata = tdata.*(100./tmmax(2));%(tdata.*diff(tmmax)./100);
   
   %create compiled data varialbe (only done for first data)
   if dd == length(data), compdata = zeros(size(tdata));end
   
   %compile data
   compdata(tdata>0) = (dd.*100)+(tdata(tdata>0));
   %compdata = compdata + ( (tdata>0).*((dd.*100)+(tdata)) ); old line
   %which caused problems because it added overlapping colors
end

%Creating colormaps. The process depends on the number of color
%maps required. The concept is simple, create one colormap per data, and
%aggregate them. Similarly, the datas are collapsed together. 
%sum(size(Limits))
for dd = length(data):-1:1,
    %set full size of colormap for first iteration, as well as seed color
    %and gray for 0
    if dd == sdata,
        opt_v.colormap = zeros(100*(dd+1),3);
        opt_v.colormap(1:10,:) = 0.7;
        if seed.show, opt_v.colormap(11:100,:) = repmat(seed.color,90,1);end
    end
    
    if isfield(opt,'contour').*contour.show(dd), 
        opt_v.colormap((dd*100)+1:100*(dd+1),:) = repmat(contour.color(dd,:),100,1);
    else
        opt_v.colormap((dd*100)+1:100*(dd+1),:) = CreateColorMapScaled(coType(dd),100);
    end
end

opt_v.limit = [1 (sdata+1).*100];

%Places seed. 
if seed.show,
    %Gets the seed
    temp = load(seed.file,'data');
    sSeed = find(temp.data == seed.num);
    compdata(sSeed) = 50;
end

%show figure
tsurf = niak_read_surf(files_in.ssurf);
info = niak_visu_surf_vMax(compdata,tsurf,opt_v);

%Rotate images
set(gcf, 'CurrentAxes', info(1)); camorbit(rot(1,1),rot(1,2)); camlight right;
set(gcf, 'CurrentAxes', info(2)); camorbit(rot(2,1),rot(2,2)); camlight left;
set(gcf, 'CurrentAxes', info(3)); camorbit(rot(3,1),rot(3,2)); camlight right;
set(gcf, 'CurrentAxes', info(4)); camorbit(rot(4,1),rot(4,2)); camlight left;
set(gcf,'Position', [100 100 1100 780]);


                        %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% Extra options %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %%%%%%%%%%%%%%%%%

% create folder    
psom_mkdir(files_out);

%Removes legend
Leg = get(gcf,'Children'); delete(Leg(1));

%Sets papers size to pring well
%set(gcf,'PaperPosition', [18 180 550 400]);%,'PaperSize',[550 400]);
resolution = 400; OSiz = [1100 780];
set(gcf,'paperunits','inches','paperposition',[0 0 OSiz/resolution]);

%Remove panels of non interest
clf(info(numView));

%Prints the figure in a tiff file at 400 dpi
fnam = strcat(files_out,fs,out.name,out.append);

print('-r600','-dpng', fnam)
saveas(gcf,strcat(fnam,'fig'));
end