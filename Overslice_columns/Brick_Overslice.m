function Brick_Overslice(files_in,opt),
%%script will do an overslice image in columns instead of a row. Especially
%interesting to look only at th eoccipital lobe. the input file should be
%an overslice from mricron.
%files_in
%       .path   string, full path to folder containing the images of
%                       interest
%       .perc
%opt
%       .numcol integer, number of columns 
%       .back = 1; %set to white background.
fs = filesep;

if ~isfield(files_in,'perc'), files_in.perc = .6;end
if ~isfield(files_in,'numcol'), files_in.numcol = 2;end
if ~isfield(opt,'imask'),opt.imask = 'H:\MatlabToolboxes\Overslice_columns\TemplateOverslice_CerRemoval.png';end;
if ~isfield(opt,'gmask'),opt.gmask = 'H:\MatlabToolboxes\Overslice_columns\GraySurround.png';end;

bPath = files_in.path;

fs = filesep;

%%%%%%%%
% Add filesep to end of base path
%%%%%%%%
if bPath(end) ~= fs,
   bPath = strcat(bPath,fs); 
end

%%%%%%%%%
% Pierre's way of getting rid of folders or files
%%%%%%%%%
dir_files = dir(bPath);
mask_dir = [dir_files.isdir];
list_all = {dir_files.name};
mask_dot = ismember(list_all,{'.','..'});
dir_files = dir_files(~mask_dot);
mask_dir = mask_dir(~mask_dot);
list_all = list_all(~mask_dot);
list_files = list_all(~mask_dir);
list_dir = list_all(mask_dir);


%loop for making the images
for ii = 1:length(list_files),
    files_in.path = strcat(bPath,fs,list_files{ii});
    Overslice(files_in,opt);
end

end