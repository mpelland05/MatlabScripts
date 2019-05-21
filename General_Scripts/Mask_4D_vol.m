function Mask_4D_vol(files_in,files_out)
  %This script will take all files within a folder and mask them with selected mask. 
  %
  %files_in
  %       .path   string, path to folder where fieles area
  %       .mask   mask to be used
  %files_out      string, path to output folder. This can be the same as input, 
  %                       but then files will be replaced
  
  fs=filesep;
  
  ppath = files_in.path;
  mmask = files_in.mask;
  fo = files_out;
  
  if ppath(end) ~= fs, ppath = strcat(ppath,fs);end;
  if fo(end)  ~= fs, fo = strcat(fo,fs);end;
  
  %find name of files
  dir_files = dir(ppath);
  mask_dir = [dir_files.isdir];
  list_all = {dir_files.name};
  mask_dot = ismember(list_all,{'.','..'});
  dir_files = dir_files(~mask_dot);
  mask_dir = mask_dir(~mask_dot);
  list_all = list_all(~mask_dot);
  lf = list_all(~mask_dir); %list of files in files_in.path
  
  %Load mask
  [hh m3d] = niak_read_vol(mmask);%3d mask
  
  for ff = 1:length(lf),
    [hdr tvol] = niak_read_vol(strcat(ppath,lf{ff}));
    le = size(tvol,4);
    
    m4d = repmat(m3d,1,1,1,le);
    
    nvol = tvol.*m4d;
    
    hdr.file_name = strcat(fo,lf{ff});
    niak_write_vol(hdr,nvol);
  end
  
  end