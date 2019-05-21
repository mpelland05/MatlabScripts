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
%% Syntax
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
for ss = 1:length(list_subject)
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
    pipeline = psom_add_job(pipeline,['connectome_' subject],'niak_brick_connectome_multiscale_covariance_maxime',in,out,jopt);%<--------------------------------------------------------------------------Maxime
end

%% Copy the networks
for nn = 1:length(list_network)
    network = list_network{nn};            
    [path_f,name_f,ext_f] = niak_fileparts(files_in.networks.(network));
    pipeline.(['networks_' network]).command   = 'system([''cp '' files_in '' '' files_out]);';
    pipeline.(['networks_' network]).files_in  = files_in.networks.(network);
    pipeline.(['networks_' network]).files_out = [folder_out network filesep 'networks_' network ext_f];
end

%% Run GLM estimation 
nn = 2;
network = list_network{nn};
    for ss = 1:length(list_subject)
        subject = list_subject{ss};
        job_in.connectome.(subject) = pipeline.(['connectome_' subject]).files_out.(network);
    end
    if isfield(files_in.model,'group')
        job_in.model = files_in.model.group;
    end
    job_in.networks = pipeline.(['networks_' network]).files_out;
    tt=1;
        clear job_out job_opt
        test = list_test{tt};
        job_opt.fdr = opt.fdr;
        job_opt.min_nb_vol = opt.min_nb_vol;
        job_opt.type_fdr = opt.type_fdr;
        if isfield(opt.test.(test),'group')
            job_opt.test.(test) = opt.test.(test).group;
        end
        job_out.results = [folder_out network filesep test filesep 'glm_' test '_' network '.mat' ];
        if opt.flag_maps
            job_out.ttest          = [folder_out network filesep test filesep 'ttest_'     test '_' network ext_f  ];
            job_out.fdr            = [folder_out network filesep test filesep 'fdr_'       test '_' network ext_f  ];
            job_out.effect         = [folder_out network filesep test filesep 'effect_'    test '_' network ext_f  ];
            job_out.std_effect     = [folder_out network filesep test filesep 'std_'       test '_' network ext_f  ];
            job_out.perc_discovery = [folder_out network filesep test filesep 'perc_disc_' test '_' network ext_f  ];
        end

files_in = job_in;files_out = job_out;opt = job_opt;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Syntax
if ~exist('files_in','var')||~exist('files_out','var')||~exist('opt','var')
    error('niak:brick','syntax: [FILES_IN,FILES_OUT,OPT] = NIAK_BRICK_GLM_CONNECTOME(FILES_IN,FILES_OUT,OPT). \n  Type ''help niak_brick_glm_connectome'' for more info.')
end

%% Files in
list_fields   = { 'connectome' , 'model'           , 'networks' };
list_defaults = {  NaN   , 'gb_niak_omitted' ,  NaN       };
files_in = psom_struct_defaults(files_in,list_fields,list_defaults);

if ~isstruct(files_in.connectome)
    error('FILES_IN.CONNECTOME should be a structure');
end

if ~ischar(files_in.networks)
    error('FILES_IN.NETWORKS should be a string')
end

%% Files out
list_fields   = { 'results'         , 'ttest'           , 'effect'          , 'std_effect'      , 'fdr'             , 'perc_discovery'  };
list_defaults = { 'gb_niak_omitted' , 'gb_niak_omitted' , 'gb_niak_omitted' , 'gb_niak_omitted' , 'gb_niak_omitted' , 'gb_niak_omitted' };
files_out = psom_struct_defaults(files_out,list_fields,list_defaults);

%% Options
list_fields   = { 'min_nb_vol' , 'type_fdr' , 'fdr' , 'test' , 'flag_verbose' , 'flag_test' };
list_defaults = { 10           , 'LSL_sym'  , 0.05  , NaN    , true           ,   false     };
opt = psom_struct_defaults(opt,list_fields,list_defaults);

%% Default for the test
test = fieldnames(opt.test);
test = test{1};
def_contrast.intercept = 1;
list_fields   = { 'select' , 'contrast'   , 'projection' , 'flag_intercept' , 'interaction' , 'normalize_x' , 'normalize_y' };
list_defaults = { struct() , def_contrast , struct()     , true             , {}            , true          , false         };
opt.test.(test)   = psom_struct_defaults(opt.test.(test),list_fields,list_defaults);

%% If the test flag is true, stop here !
if opt.flag_test == 1
    return
end

%% Read and prepare the group model
if ~strcmp(files_in.model,'gb_niak_omitted')
    if opt.flag_verbose
        fprintf('Reading the group model ...\n');
    end
    [model_group.x,model_group.labels_x,model_group.labels_y] = niak_read_csv(files_in.model);
    % choosing the subjects of the model
    opt.test.(test).labels_x = fieldnames(files_in.connectome) ;
else 
    if opt.flag_verbose
        fprintf('No group model was specified ! I will use default values ...\n')
    end
    model_group.x  = [] ; 
    model_group.labels_x = fieldnames(files_in.connectome);
    model_group.labels_y ={};
    opt.test.(test).group.flag_intercept = 1 ;
    opt.test.(test).group.contrast.intercept = 1 ;
end 
model_group = niak_normalize_model(model_group, opt.test.(test));

%% Load individual connectomes
list_subject = model_group.labels_x;
mask_subject_ok = true(length(list_subject),1);
nb_vol = zeros(length(list_subject),1);