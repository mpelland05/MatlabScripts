clear 
Taskless_T_noLB50_100_Loader_Covariance;

%%%%%%%%%%%%
%% Tests
%%%%%%%%%%%%
%% Task %%

    %CB
    opt.test.task_CB.group.select(1).label        = 'SelCB';
    opt.test.task_CB.group.select(1).values       = 1;
    opt.test.task_CB.group.contrast.intercept     = 1;
    opt.test.task_CB.group.contrast.age           = 0;
    opt.test.task_CB.group.contrast.sex           = 0;
    opt.test.task_CB.group.contrast.FDtask        = 0;
    opt.test.task_CB.inter_run.select(1).label    = 'TVR';
    opt.test.task_CB.inter_run.select(1).values   = 1;
    opt.test.task_CB.intra_run.projection         = {'PITCH' 'SPATIAL'};
    opt.test.task_CB.intra_run.type = 'covariance';
        
 
%%%%%%%%%%%%%%%%%%%
%% Run the pipeline
%%%%%%%%%%%%%%%%%%%
opt.flag_test = false; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('files_in','var')||~exist('opt','var')
    error('niak:pipeline','syntax: PIPELINE = NIAK_PIPELINE_GLM_CONNECTOME(FILES_IN,OPT).\n Type ''help niak_pipeline_glm_connectome'' for more info.')
end

%% Checking that FILES_IN is in the correct format
list_fields   = { 'networks' , 'model' , 'fmri' };
list_defaults = { NaN        , NaN     , NaN    };
files_in      = psom_struct_defaults(files_in,list_fields,list_defaults);

%% Options
list_fields   = { 'min_nb_vol' , 'nb_samps' , 'nb_batch' , 'fdr' , 'type_fdr' , 'flag_rand' , 'flag_maps' , 'fwe'  , 'psom'   , 'folder_out' , 'test' , 'flag_verbose' , 'flag_test' };
list_defaults = { 10           , 1000       , 10         , 0.05  , 'LSL_sym'  , false       , true        , 0.05   , struct() , NaN           , NaN   ,    true        , false       };
opt = psom_struct_defaults(opt,list_fields,list_defaults);
folder_out = niak_full_path(opt.folder_out);
opt.psom.path_logs = [folder_out 'logs' filesep];

%% Generate individual connectomes
pipeline = struct();
list_subject = fieldnames(files_in.fmri);
list_test = fieldnames(opt.test);
list_network = fieldnames(files_in.networks);

ss = 1;

clear in out jopt
    subject = list_subject{ss};
    in.fmri = files_in.fmri.(subject);
    in.networks = files_in.networks;
    if isfield(files_in.model,'individual')&&isfield(files_in.model.individual,subject)
        in.model = files_in.model.individual.(subject);
    end
    for nn = 1:length(list_network)
        network = list_network{nn};
        out.(network) = [folder_out network filesep 'individual' filesep 'connectome_' subject '_' network '.mat'];
    end
    for tt = 1:length(list_test)
        test = list_test{tt};
        if isfield(opt.test.(test),'group')
            jopt.param.(test) = rmfield(opt.test.(test),'group');
        else
            jopt.param.(test) = opt.test.(test);
        end
    end
    jopt.min_nb_vol   = opt.min_nb_vol;
    jopt.flag_verbose = opt.flag_verbose;

files_in = in;files_out = out; opt = jopt;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('files_in','var')||~exist('files_out','var')||~exist('opt','var')
    error('niak:brick','syntax: [FILES_IN,FILES_OUT,OPT] = NIAK_BRICK_CONNECTOME_MULTISCALE(FILES_IN,FILES_OUT,OPT). \n  Type ''help niak_brick_connectome_MULTISCALE'' for more info.')
end

%% Files in
list_fields   = { 'fmri' , 'model'  , 'networks' };
list_defaults = {  NaN   , struct() ,  NaN       };
files_in = psom_struct_defaults(files_in,list_fields,list_defaults);

files_in.model = psom_struct_defaults(files_in.model,{'inter_run','intra_run'},{'gb_niak_omitted','gb_niak_omitted'});
[fmri,label_fmri] = niak_fmri2cell(files_in.fmri,false); % reformat FILES_IN.FMRI into a cell

%% Files out 
if ~isstruct(files_out)
    error('FILES_OUT should be a structure')
end
if ~psom_cmp_var(fieldnames(files_out),fieldnames(files_in.networks))
    error('FILES_OUT and FILES_IN.NETWORKS should have the same fields');
end

%% Options
list_fields   = { 'min_nb_vol' , 'param' , 'flag_verbose' , 'flag_test' };
list_defaults = { 10           , NaN     , true           ,   false     };
opt = psom_struct_defaults(opt,list_fields,list_defaults);

list_param = fieldnames(opt.param); % Defaults for opt.param
def_contrast.intercept = 1;
list_fields   = { 'select' , 'contrast'   , 'projection' , 'flag_intercept' , 'interaction' , 'normalize_x' , 'normalize_y' };
list_defaults = { struct() , def_contrast , struct()     , true             , {}            , true          , false         };

for pp = 1:length(list_param) 
    param = list_param{pp};
    opt.param.(param) = psom_struct_defaults(opt.param.(param),{ 'inter_run' , 'intra_run' },{ struct()    , struct()    });
    opt.param.(param).inter_run = psom_struct_defaults(opt.param.(param).inter_run,list_fields,list_defaults);
end

%% If the test flag is true, stop here !
if opt.flag_test == 1
    return
end

%% Read the networks
if opt.flag_verbose
    fprintf('Reading the networks ...\n');
end
list_network = fieldnames(files_in.networks);
for nn = 1:length(list_network); %% loop over networks
    network = list_network{nn};    
    [hdr,networks.(network)] = niak_read_vol(files_in.networks.(network)); % read networks        
end

%% Read the intra-run models
if opt.flag_verbose
    fprintf('Reading the intra-run models ...\n');
end
for rr = 1:length(fmri)    
    session = label_fmri(rr).session;
    run = label_fmri(rr).run;
    if ~ischar(files_in.model.intra_run)&&isfield(files_in.model.intra_run,session)
        file_run = files_in.model.intra_run.(session).(run);
    elseif ~ischar(files_in.model.intra_run)&&(isfield(files_in.model.intra_run,'covariate')||isfield(files_in.model.intra_run,'event'))
        file_run = files_in.model.intra_run;
    else
        file_run = struct();
    end
    file_run = psom_struct_defaults(file_run,{'covariate','event'},{'gb_niak_omitted','gb_niak_omitted'});
        
    if ~strcmp(file_run.covariate,'gb_niak_omitted')
        [covariate.x,covariate.labels_x,covariate.labels_y] = niak_read_csv(file_run.covariate);
        intra_run.(session).(run).covariate = covariate;
    else 
        intra_run.(session).(run).covariate = struct();
    end
        
    if ~strcmp(file_run.event,'gb_niak_omitted')
        [event.x,event.labels_x] = niak_read_csv(file_run.event);      
        intra_run.(session).(run).event = event;
    else 
        intra_run.(session).(run).event = struct();
    end
end

%% Read the inter-run model 
if opt.flag_verbose
    fprintf('Reading the inter-run model ...\n');
end
inter_run_raw = struct;
if ~strcmp(files_in.model.inter_run,'gb_niak_omitted')
    [inter_run_raw.x,inter_run_raw.labels_x,inter_run_raw.labels_y] = niak_read_csv(files_in.model.inter_run);
else
    inter_run_raw.x        = [];
    inter_run_raw.labels_x = {label_fmri.name};
    inter_run_raw.labels_y = {};
end
    
for pp = 1:length(list_param); %% loop over parameters to generate SPC
    param = list_param{pp};    
    inter_run.(param) = niak_normalize_model(inter_run_raw,opt.param.(param).inter_run);
    x = inter_run.(param).x;
    c = inter_run.(param).c;
    inter_run.(param).p = c'*(x'*x)^(-1)*x';
end

%% Read the fMRI runs and generate the intra-run spc connectome
if opt.flag_verbose
    fprintf('Generation of a statistical parametric connectome ...\n');
end
spc_inter_run = struct();
flag_ok = true(length(list_param),1); % for each set of parameters, flag if there is enough data for the estimation

    num_r = 2;
    session = label_fmri(num_r).session;
    run = label_fmri(num_r).run;
    name = label_fmri(num_r).name;
    model_tseries = intra_run.(session).(run);
    
    
    file_run = fmri{num_r};
    [hdr_fmri,vol] = niak_read_vol(file_run);
model_tseries.tseries = niak_vol2tseries(vol);
if isfield(hdr_fmri,'extra')
    
model_tseries.time_frames = hdr_fmri.extra.time_frames;
    if isfield(hdr_fmri.extra,'confounds')
        model_tseries.confounds = hdr_fmri.extra.confounds;
        model_tseries.labels_confounds = hdr_fmri.extra.labels_confounds;
    else
        model_tseries.confounds = [];
        model_tseries.labels_confounds = {};
    end
    if isfield(hdr_fmri.extra,'mask_suppressed')
        model_tseries.mask_suppressed = hdr_fmri.extra.mask_suppressed;
    else
        model_tseries.mask_suppressed = false(size(intra_run.tseries,1),1);
    end
else
    model_tseries.time_frames = (0:(size(intra_run.tseries,1)-1))*hdr_fmri.info.tr;
    model_tseries.confounds = [];
    model_tseries.labels_confounds = {};
    model_tseries.mask_suppressed = false(size(intra_run.tseries,1),1);
end

    
    if opt.flag_verbose 
        fprintf('    %s \n',fmri{num_r});
    end

num_p = 1;
param = list_param{num_p};
        if ~isfield(spc_inter_run,param) % save the parameters of the connectomes in the output structure
           spc_inter_run.(param).param.inter_run = opt.param.(param).inter_run;
        end
        ind_r = find(strcmp(inter_run.(param).labels_x,name));
        if isempty(ind_r)
            continue
        end     

num_n = 1;

 network = list_network{num_n};    
            model_tseries.network = networks.(network);
                                
            %% Compute the statistical parametric connectome at the level of intra run    
            opt = opt.param.(param).intra_run;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nargin = 2;

%% Default model
list_fields   = { 'tseries' , 'time_frames' , 'mask_suppressed' , 'confounds' , 'labels_confounds' , 'event' , 'covariate' , 'network' };
list_defaults = { NaN       , []            , []                , []          , {}                 , struct  , struct      , []        };
model_tseries = psom_struct_defaults(model_tseries,list_fields,list_defaults);

if isempty(model_tseries.time_frames)
    model_tseries.time_frames = 0:(length(model_tseries.tseries)-1);
end

if isempty(model_tseries.mask_suppressed)
    if isfield(model_tseries.covariate.x)&&~isempty(model_tseries.covariate.x)
        model_tseries.mask_suppressed = false(size(model_tseries.covariate.x,1),1);
    else
        model_tseries.mask_suppressed = false(size(model_tseries.tseries,1),1);
    end
end

%% Default option
if nargin < 2
    opt = struct;
end
opt = psom_struct_defaults(opt,{'type'},{'correlation'},false);
switch opt.type
    case 'correlation'
        list_fields   = { 'type'        , 'flag_fisher' , 'projection' , 'select' , 'select_diff' };
        list_defaults = { 'correlation' , true          , {}           , struct() , struct()      };
        opt = psom_struct_defaults(opt,list_fields,list_defaults);
    case 'covariance'%<--------------------------------------------------------------------------------------------------------------------------------Maxime
        list_fields   = { 'type'        , 'flag_fisher' , 'projection' , 'select' , 'select_diff' };
        list_defaults = { 'covariance'  , false          , {}           , struct() , struct()      };
        opt = psom_struct_defaults(opt,list_fields,list_defaults);
    case 'glm'
        def_contrast.seed = 1;
        list_fields   = { 'select' , 'contrast'   , 'projection' , 'flag_intercept' , 'interaction' , 'normalize_x' , 'type'        , 'normalize_y' };
        list_defaults = { {}       , def_contrast , struct()     , true             , {}            , false         , 'correlation' , true          };
        opt = psom_struct_defaults(opt,list_fields,list_defaults);
end    

%% Case of a difference in correlation
if strcmp(opt.type,'correlation') && isfield(opt.select_diff,'label')
    opt1 = rmfield(opt,'select_diff');    
    [spc1,model_n(1)] = niak_glm_connectome_run(model_tseries,opt1);
    opt2 = opt1;
    opt2.select = opt.select_diff;
    [spc2,model_n(2)] = niak_glm_connectome_run(model_tseries,opt2);
    if isnan(spc1)||isnan(spc2)
        spc = NaN;
    else
        spc = spc2-spc1;
    end
    return
end

%% Add the manually specified covariates in the model
conf = struct;
if isfield(model_tseries.covariate,'x')&&~isempty(model_tseries.covariate.x)
    conf.x = model_tseries.covariate.x(~model_tseries.mask_suppressed,:);
    conf.labels_y = model_tseries.covariate.labels_y;
else
    conf.x = [];
    conf.labels_y = {};
end
  
%% Add the events convolved with an hemodynamic response to the model
if isfield(model_tseries.event,'x')&&~isempty(model_tseries.event.x)
    [list_event,tmp,all_event]  = unique(model_tseries.event.labels_x); 
    opt_m.events = [all_event(:) model_tseries.event.x];
    opt_m.frame_times = model_tseries.time_frames;
    x_cache =  niak_fmridesign(opt_m); 
    conf.x = [conf.x x_cache.x(:,:,1,1)];
    conf.labels_y = [conf.labels_y(:) ; list_event(:)];
end

%% Add the confounds to the model
if ~isempty(model_tseries.confounds)&&~strcmp(opt.type,'correlation')
    if any(ismember(model_tseries.labels_confounds,conf.labels_y))
        error('Some labels of event/covariate are also found in the list of confounds. Do not use the same label twice !')
    end
    conf.x = [conf.x model_tseries.confounds];
    conf.labels_y = [conf.labels_y(:) ; model_tseries.labels_confounds(:)];
    for num_c = 1:length(model_tseries.labels_confounds)
        opt.contrast.(model_tseries.labels_confounds{num_c}) = 0;
    end
end

%% Add the time series in the model
conf.y = model_tseries.tseries;
lab_vol = find(~model_tseries.mask_suppressed);
conf.labels_x = cell([size(conf.y,1) 1]);
for num_v = 1:length(lab_vol)
    conf.labels_x{num_v} = sprintf('%i',lab_vol(num_v));
end

%% the user wants to work with covariance values
	opt_n.select = opt.select;
	if ~isempty(opt.projection)
            for num_f = 1:length(opt.projection)
                opt_n.contrast.(opt.projection{num_f}) = 1;
            end
        end
        model_n = niak_normalize_model(conf,opt_n);
       
            model_proj.x = model_n.x;
            model_proj.y = model_n.y;
            opt_proj.flag_residuals = true;
            %res_proj = niak_glm(model_proj,opt_proj);
            %model_n.y = res_proj.e;
