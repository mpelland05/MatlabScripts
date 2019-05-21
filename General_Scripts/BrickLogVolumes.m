function BrickLogVolumes(basePath),
%See log volumes
fs = filesep;

%%%%%%%%%
% Pierre's way of getting rid of folders or files
%%%%%%%%%
dir_files = dir(basePath);
mask_dir = [dir_files.isdir];
list_all = {dir_files.name};
mask_dot = ismember(list_all,{'.','..'});
dir_files = dir_files(~mask_dot);
mask_dir = mask_dir(~mask_dot);
list_all = list_all(~mask_dot);
list_files = list_all(~mask_dir);
list_dir = list_all(mask_dir);

for ii = 1:length(list_files),
    basePath2 = strcat(basePath,fs,list_files{ii});
    LogVolumes(basePath2);
end

end