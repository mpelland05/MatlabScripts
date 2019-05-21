clear all
%%%%%%%%%%%%%%%%%%%
%%%%% IMPORTANT
%%%%%%%%%%%%%%% This script was writtent to remove LB, please erase the
%%%%%%%%%%%%%%% relevant lines when wanting to keep them. 

FiltGroup =  'LBxxx'; %Remove this line if you do not want to filter out LBs.
 
bPath = '/mnt/parallel_scratch_ms2_wipe_on_april_2015/bellec/bellec_group/blindtvr/fmri/fmri_preprocess_01_RestOnly_NoSmooth/fmri/';

files_in.mask = '/home/mpelland/database/blindtvr/fmri/region_growing_01_RestOnly_NoSmooth/rois/brain_rois.mnc.gz';

opt.folder_out = '/home/mpelland/database/blindtvr/fmri/region_growing_01_RestOnly_NoSmooth/NormalizeTseries/';


%%%%%%%%%%%%%
% Start here
%%%%%%%%%%%
aa = dir(bPath);

llist = [];
Incre = 0;
for ii = 1:length(aa),
   if (aa(ii).isdir == 0),
        [tdir, tname, text, tver] = fileparts(aa(ii).name); 
        if ~isempty(strfind(text,'.gz')),
            [xxx, yyy, text, zzz] = fileparts(aa(ii).name(1:end-3)); 
        end
        if ~isempty(strfind(text,'.mnc') ),
            if exist('FiltGroup'),
                if isempty(strfind(tname,FiltGroup) ),
                    Incre = Incre + 1;
                    files_in.fmri{Incre} = strcat(bPath,aa(ii).name);
                end
            else
                Incre = Incre + 1;
                files_in.fmri{Incre} = strcat(bPath,aa(ii).name);
            end
        end
   end
end

files_in.fmri = files_in.fmri;

files_out = struct;

[files_in,files_out,opt] = niak_brick_tseries2(files_in,files_out,opt);
