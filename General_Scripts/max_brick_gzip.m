function [files_in,files_out,opt] = max_brick_gzip(files_in,files_out,opt)
% Zip all files within folder with a certain type of extension
%
% [files_in,files_out,opt] = max_brick_gzip(files_in,files_out,opt)
%
% _________________________________________________________________________
% INPUTS:
%
% FILES_IN  
%   (string) a relative or full path.
%
% FILES_OUT 
%   (string, default FILES_IN) a relative or full path name
%
% OPT   
%   (structure) with the following fields :
%
%   FLAG_RECURSIVE
%      (boolean, default true) recursively copy subfolders.
%
%   ARG_NII2MNC
%      (string, default '') an argument that will be added in
%      the system call to the NII2MNC function.
%
%   FLAG_VERBOSE 
%      (boolean, default 1) if the flag is 1, then the function prints 
%      some infos during the processing.
%
%   FLAG_ZIP
%      (boolean, default false) if the flag is true, the output minc
%      files are compressed (see comments below). This is useful with
%      MINC1 file format.
%
%   FILE_TYPE
%	(string or cell of strings, default {'.mnc', '.nii'}) type of files to
%	
%
% _________________________________________________________________________
% OUTPUTS
%
% The structures FILES_IN, FILES_OUT and OPT are updated with default
% valued. If OPT.FLAG_TEST == 0, the specified outputs are written.
%
% _________________________________________________________________________
% COMMENTS
%
% This brick is just a wraper of NII2MNC system calls.
%
% Compressed zip files (ended in .gz) are supported. To change the
% compression extension and/or the command used to uncompress files, please
% change the variables GB_NIAK_ZIP_EXT and GB_NIAK_UNZIP in the file
% NIAK_GB_VARS.M
%
% Copyright (c) Pierre Bellec, McConnell Brain Imaging Center,
% Montreal Neurological Institute, McGill University, 2008.
% Maintainer : pbellec@bic.mni.mcgill.ca
% See licensing information in the code.
% Keywords : pipeline, niak, nifti, minc, conversion

% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.

niak_gb_vars

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Seting up default arguments %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('files_in','var')
    error('niak:brick','syntax: [FILES_IN,FILES_OUT,OPT] = NIAK_BRICK_NII2MNC(FILES_IN,FILES_OUT,OPT).\n Type ''help niak_brick_MNC2NII'' for more info.')
end
if ~exist('files_out','var')||isempty(files_out)
    files_out = files_in;
end

%% Options
gb_name_structure = 'opt';
gb_list_fields = {'flag_recursive','flag_verbose','arg_nii2mnc', 'file_type'};
gb_list_defaults = {true,true,'',{'.mnc', '.nii'}};
niak_set_defaults

files_in = niak_full_path(files_in);
files_out = niak_full_path(files_out);

dir_files = dir(files_in);

mask_dir = [dir_files.isdir];
list_all = {dir_files.name};
mask_dot = ismember(list_all,{'.','..'});
dir_files = dir_files(~mask_dot);
mask_dir = mask_dir(~mask_dot);
list_all = list_all(~mask_dot);
list_files = list_all(~mask_dir);
list_dir = list_all(mask_dir);

niak_mkdir(files_out);

for num_f = 1:length(list_files)
    
    file_name = list_files{num_f};
    source_file = [files_in filesep file_name];
    
    [path_tmp,name_tmp,ext] = fileparts(file_name);
    
    if sum(strcmp(ext,opt.file_type)) >= 1,  
            
            target_file = [files_out filesep name_tmp ext gb_niak_zip_ext];
            tmp_file = niak_file_tmp(ext);
            instr_cp0 = ['cp ' source_file ' ' tmp_file];
            instr_cp0bis = [gb_niak_zip ' ' tmp_file];
            instr_cp1 = ['cp ' tmp_file gb_niak_zip_ext,' ',target_file];
            instr_cp2 = ['rm ' tmp_file gb_niak_zip_ext];
            instr_cp = char(instr_cp0,instr_cp0bis,instr_cp1,instr_cp2);
            
         if flag_verbose
            msg = sprintf('Convert %s to %s\n',source_file,target_file);
	    fprintf('%s',msg)
         end

        for num_e = 1:size(instr_cp,1)
            [flag_err,err_msg] = system(instr_cp(num_e,:));
            if flag_err
                warning(err_msg)
            end
        end
    end

        
end

if flag_recursive
    
    for num_d = 1:length(list_dir)
        
        max_brick_gzip([files_in filesep list_dir{num_d}],[files_out filesep list_dir{num_d}],opt);
        
    end
end
