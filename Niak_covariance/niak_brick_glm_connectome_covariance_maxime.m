function [files_in,files_out,opt] = niak_brick_glm_connectome_covariance_maxime(files_in,files_out,opt)
% General linear model analysis of connectomes (group-level, random-effect)
%
% SYNTAX:
% [FILES_IN,FILES_OUT,OPT] = NIAK_BRICK_GLM_CONNECTOME(FILES_IN,FILES_OUT,OPT)
% ______________________________________________________________________________________________________
% INPUTS:
%
% FILES_IN  
%   (structure) with the following fields : 
%
%   CONNECTOME.(SUBJECT)
%      (string) a .mat files with a variable (TEST). This variable is a structure multiple
%      fields (TEST).connectome.(NETWORK).value which store a vectorized connectome. See below for a 
%      description of the fields (TEST) and (NETWORK). The variable (TEST).param.intra_run.type defines
%      the type of connectome, and how it can be unvectorized.
%
%   NETWORKS
%      (string) a file name of a mask of brain networks (network I is filled with Is, 0 is for the 
%      background). The analysis is done at the level of these networks.
%
%   MODEL
%      (string, optional) the name of a .csv file describing the covariates at the group level
%      Example :
%                , SEX , HANDENESS
%      (SUBJECT) , 0   , 0
%      This type of file can be generated with Excel (save under CSV).
%      Each column defines a covariate that can be used in a linear model.
%      If omitted, the group model will only include the intercept.
%       
% FILES_OUT
%   (structure) with the following fields : 
%
%   RESULTS
%      (string, default 'gb_niak_omitted') a .mat file with the following matlab variables:
%      
%      MODEL_GROUP
%         (structure) with the following fields:
%         X (matrix N*K) each column is a covariate of the model
%         Y (matrix N*W) each row is a vectorized connectome for one subject.
%         C (vector K*1) C(K) is the weight of X(:,K) in the contrast.
%         LABELS_X (cell of string N*1) the subject labels.
%         LABELS_Y (cell of string K*1) the covariate labels.
%
%      TYPE_MEASURE
%         (string) the type of connectome (either 'correlation' or 'glm')
%
%      BETA
%         (matrix K*W) BETA(K,:) is a vectorized version of the V*V matrix of effects 
%         for each connection for covariate X(:,K). 
%
%      EFF
%         (matrix 1*W) estimate of the effect associated with the 
%         specified contrast at each connection.
%
%      STD_NOISE
%         (matrix 1*W) estimate of the standard deviation of noise
%         at each connection.
%
%      TTEST
%         (matrix 1*W) A t-test for the significance of the contrast
%         at each connection.
%
%      PCE 
%         (matrix 1*W) the per-comparison error associated with each t-test
%         against a bilateral hypothesis of BETA(w)=0.
%
%      FDR
%         (matrix V*V) FDR(v,v') is the false-discovery rate associated with 
%         PCE(v,v') See OPT.TYPE_FDR for more info.
%
%      Q
%         (scalar) the threshold on acceptable FDR. 
%
%      TEST_Q
%         (matrix V*V) TEST_Q(v,v') equals to 1 if the associated t-test is deemed 
%         significant as part of the family (map) v'. TEST_Q(v,v') equals 0 otherwise.
%
%      MODEL_WHITE
%         (structure) a general linear model to check for the presence of heteroscedasticity
%         in the model.
%
%      TEST_WHITE
%         (matrix) some tests to check for the presence of heteroscedasticity in the 
%         model. 
%
%      NB_DISCOVERY
%          (vector 1*V) PERC_DISCOVERY(v) is the number of discoveries in the map
%          associated with v.
%
%      PERC_DISCOVERY
%          (vector 1*V) PERC_DISCOVERY(v) is the percentage of discoveries in the map
%          associated with v.
%
%   TTEST
%      (string, default 'gb_niak_omitted') the file name of a 4D dataset. 
%      TTEST(:,:,:,n) is the t-stat map associated with the n-th network.
%
%   EFFECT
%      (string, default 'gb_niak_omitted') the file name of a 4D dataset. 
%      EFFECT(:,:,:,n) is the effect map corresponding the TTEST(:,:,:,n).
%
%   STD_EFFECT
%      (string, default 'gb_niak_omitted') the file name of a 4D dataset. 
%      STD_EFFECT(:,:,:,n) is the map of standard deviation of the effect 
%      corresponding to TTEST(:,:,:,n).
%
%   FDR
%      (string, default 'gb_niak_omitted') the file name of a 4D dataset. 
%      FDR(:,:,:,n) is the t-stat map corresponding to TTEST. All the 
%      t-values associated with a global false-discovery rate below 
%      OPT.FDR are put to zero.
%
%   PERC_DISCOVERY
%      (string, default 'gb_niak_omitted') the file name of a 3D volume. 
%      PERC_DISCOVERY(:,:,:) is the map of the number of discovery 
%      associated with each network, expressed as a percentage of the 
%      number of networks - 1 (i.e. the max possible number of discoveries 
%      associated with a network).
%
% OPT
%   (structure) with the following fields:
%
%   FDR
%      (scalar, default 0.05) the level of acceptable false-discovery rate 
%      for the t-maps.
%
%   TYPE_FDR
%      (string, default 'LSL_sym') how the FDR is controled. 
%      See the TYPE argument of NIAK_GLM_FDR.
%
%   TEST.<LABEL>
%      (structure, optional) By default the contrast is on the intercept (average of all connectomes 
%      across all subjects). The following fields are supported:
%
%      CONTRAST.(NAME)
%         (structure, the fields (NAME) need to correspond to a column in FILES_IN.MODEL)
%         The fields found in CONTRAST will determine which covariates enter the model. 
%         CONTRAST.(NAME) is the weight of the covariate NAME in the contrast.
% 
%      INTERACTION
%         (structure, optional) with multiple entries and the following fields :
%          
%         LABEL
%            (string) a label for the interaction covariate.
%
%         FACTOR
%            (cell of string) covariates that are being multiplied together to build the
%            interaction covariate. 
%
%         FLAG_NORMALIZE_INTER
%            (boolean,default true) if FLAG_NORMALIZE_INTER is true, the factor of interaction 
%            will be normalized to a zero mean and unit variance before the interaction is 
%            derived (independently of OPT.<LABEL>.GROUP.NORMALIZE below.
%
%      PROJECTION
%         (structure, optional) with multiple entries and the following fields :
%
%         SPACE
%            (cell of strings) a list of the covariates that define the space to project 
%            out from (i.e. the covariates in ORTHO, see below, will be projected 
%            in the space orthogonal to SPACE).
%
%         ORTHO
%            (cell of strings, default all the covariates except those in space) a list of 
%            the covariates to project in the space orthogonal to SPACE (see above).
%
%         FLAG_INTERCEPT
%            (boolean, default true) if the flag is true, add an intercept in SPACE (even 
%            when the model does not have an intercept).
%
%      NORMALIZE_X
%         (structure or boolean, default false) If a boolean and true, all covariates of the 
%         model are normalized to a zero mean and unit variance. If a structure, the 
%         fields <NAME> need to correspond to the label of a column in the 
%         file FILES_IN.MODEL, and the normalization will only be applied to the listed 
%         variables.
%
%      NORMALIZE_Y
%         (boolean, default false) If true, the data is corrected to a zero mean and unit variance,
%         in this case across subjects.
%
%      FLAG_INTERCEPT
%         (boolean, default true) if FLAG_INTERCEPT is true, a constant covariate will be
%         added to the model.
%
%      SELECT
%         (structure, optional) with multiple entries and the following fields:           
%
%         LABEL
%            (string) the covariate used to select entries *before normalization*
%
%         VALUES
%            (vector, default []) a list of values to select (if empty, all entries are retained).
%
%         MIN
%            (scalar, default []) only values higher (or equal) than MIN are retained.
%
%         MAX
%            (scalar, default []) only values lower (or equal) than MAX are retained. 
%
%         OPERATION
%            (string, default 'or') the operation that is applied to select the frames.
%            Available options:
%            'or' : merge the current selection SELECT(E) with the result of the previous one.
%            'and' : intersect the current selection SELECT(E) with the result of the previous one.
%
%   FLAG_TEST
%       (boolean, default 0) if the flag is 1, then the function does not
%       do anything but update the defaults of FILES_IN, FILES_OUT and OPT.
%
%   FLAG_VERBOSE 
%       (boolean, default 1) if the flag is 1, then the function prints 
%       some infos during the processing.
%           
% _________________________________________________________________________
% OUTPUTS:
%
% The structures FILES_IN, FILES_OUT and OPT are updated with default
% valued. If OPT.FLAG_TEST == 0, the specified outputs are written.
%              
% _________________________________________________________________________
% SEE ALSO:
% NIAK_PIPELINE_GLM_CONNECTOME, NIAK_BRICK_CONNECTOME_MULTISCALE, 
% NIAK_LSE, NIAK_FDR
%
% _________________________________________________________________________
% COMMENTS:
%
% Copyright (c) Pierre Bellec, Centre de recherche de l'institut de 
% Gériatrie de Montréal, Département d'informatique et de recherche 
% opérationnelle, Université de Montréal, 2010-2013.
% Maintainer : pierre.bellec@criugm.qc.ca
% See licensing information in the code.
% Keywords : GLM, functional connectivity, connectome,PPI.

% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
%mode
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.

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
for num_s = 1:length(list_subject);
    % Load the file
    subject = list_subject{num_s};
    conn = load(files_in.connectome.(subject),test);
    
    % Grab the number of volumes
    list_session = fieldnames(conn.(test).model.intra_run);    
    for ss = 1:length(list_session)
        session = list_session{ss};
        list_run = fieldnames(conn.(test).model.intra_run.(session));
        for rr = 1:length(list_run)
            run = list_run{rr};
            nb_vol(num_s) = nb_vol(num_s) + conn.(test).model.intra_run.(session).(run).nb_vol;
        end
    end
    
    % Organize the connectomes into one big array    
    mask_subject_ok(num_s) = ~any(isnan(conn.(test).connectome));
    if ~exist('spc_subject','var')&&mask_subject_ok(num_s)
        spc_subject = zeros([length(list_subject) length(conn.(test).connectome)]);
        type_measure = conn.(test).param.intra_run.type;
    end    
    if mask_subject_ok(num_s)
        spc_subject(num_s,:) = conn.(test).connectome;
    end
end   % end of subjects

if ~any(mask_subject_ok)
    error('No subject was found to have enough data to generate connectomes');
end

%% Filter out subjects with missing data
spc_subject = spc_subject(mask_subject_ok,:);
model_group.x = model_group.x(mask_subject_ok,:);
model_group.labels_x = model_group.labels_x(mask_subject_ok);
nb_vol = nb_vol(mask_subject_ok);

%% Generate the group model
model_group.y = spc_subject;

%% Estimate the group-level model
if opt.flag_verbose
   fprintf('Estimate model...\n')
end
opt_glm_gr.test  = 'ttest' ;
opt_glm_gr.flag_beta = true ; 
opt_glm_gr.flag_residuals = true ;
y_x_c.x = model_group.x;
y_x_c.y = model_group.y;
y_x_c.c = model_group.c; 
[results, opt_glm_gr] = niak_glm(y_x_c , opt_glm_gr);

%% Run White's test of heteroscedasticity
model_white.y = model_group.y;
model_white.labels_x = model_group.labels_x;
model_white.labels_y = model_group.labels_y;
if length(unique(nb_vol))>1
    model_white.x = [model_group.x nb_vol];
    model_white.labels_y{end+1} = 'nb_vol';
else
    model_white.x = model_group.x;
end
[test_white.p,model_white] = niak_white_test_hetero(model_white);
model_white = rmfield(model_white,'y'); % remove the square residuals from the model, as this is very large data & is easy to regenerate
[test_white.fdr,test_white.result] = niak_fdr(test_white.p(:),'BH',0.2);

%% Reformat the results of the group-level model
beta =  results.beta; 
e  = results.e ;
std_e = results.std_e ;
ttest = results.ttest ;
pce = results.pce ; 
eff =  results.eff ;
std_eff =  results.std_eff ; 
switch type_measure
    case 'correlation'
        ttest_mat = niak_lvec2mat (ttest);
        eff_mat   = niak_lvec2mat (eff);
        std_mat   = niak_lvec2mat (std_eff);
    case 'covariance'%<-----------------------------------------------------------------------------------------------------------------------------------------Maxime
        ttest_mat = niak_lvec2mat (ttest);
        eff_mat   = niak_lvec2mat (eff);
        std_mat   = niak_lvec2mat (std_eff);

    case 'glm'
        ttest_mat = reshape (ttest,[sqrt(length(ttest)),sqrt(length(ttest))]);
        eff_mat   = reshape (eff,[sqrt(length(eff)),sqrt(length(eff))]);
        std_mat   = reshape (std_eff,[sqrt(length(std_eff)),sqrt(length(std_eff))]);
    otherwise
        error('%s is an unkown type of intra-run measure',opt.test.(test).run.type)
end

%% Run the FDR estimation
q = opt.fdr;
[fdr,test_q] = niak_glm_fdr_covariance_maxime(pce,opt.type_fdr,q,type_measure);%<-----------------------------------------------------------------------------------------Maxime
nb_discovery = sum(test_q,1);
perc_discovery = nb_discovery/size(fdr,1);

%% Build volumes
[hdr,mask] = niak_read_vol(files_in.networks);
if ~strcmp(files_out.perc_discovery,'gb_niak_omitted')||~strcmp(files_out.fdr,'gb_niak_omitted')||~strcmp(files_out.effect,'gb_niak_omitted')||~strcmp(files_out.std_effect,'gb_niak_omitted')
    if opt.flag_verbose
       fprintf('Generating volumes ...\n')
    end    
    nb_net = size(ttest_mat,1);
    mask(mask>nb_net) = 0;
    t_maps   = zeros([size(mask) nb_net]);
    fdr_maps = zeros([size(mask) nb_net]);
    eff_maps = zeros([size(mask) nb_net]);
    std_maps = zeros([size(mask) nb_net]);
    for num_net = 1:nb_net
        t_maps(:,:,:,num_net)   = niak_part2vol(ttest_mat(:,num_net),mask);    
        eff_maps(:,:,:,num_net) = niak_part2vol(eff_mat(:,num_net),mask);
        std_maps(:,:,:,num_net) = niak_part2vol(std_mat(:,num_net),mask);
        ttest_thre = ttest_mat(:,num_net);
        ttest_thre( ~test_q(:,num_net) ) = 0;
        fdr_maps(:,:,:,num_net) = niak_part2vol(ttest_thre,mask);
    end
    discovery_maps = niak_part2vol(perc_discovery,mask);
end

% t-test maps
if ~strcmp(files_out.ttest,'gb_niak_omitted')
    hdr.file_name = files_out.ttest;
    niak_write_vol(hdr,t_maps);
end

% perc_discovery
if ~strcmp(files_out.perc_discovery,'gb_niak_omitted')
    hdr.file_name = files_out.perc_discovery;
    niak_write_vol(hdr,discovery_maps);
end

% FDR-thresholded t-test maps
if ~strcmp(files_out.fdr,'gb_niak_omitted')
    hdr.file_name = files_out.fdr;
    niak_write_vol(hdr,fdr_maps);
end

% effect maps
if ~strcmp(files_out.effect,'gb_niak_omitted')
    hdr.file_name = files_out.effect;
    niak_write_vol(hdr,eff_maps);
end

% std maps
if ~strcmp(files_out.std_effect,'gb_niak_omitted')
    hdr.file_name = files_out.std_effect;
    niak_write_vol(hdr,std_maps);
end

%% Save results in mat form
if ~strcmp(files_out.results,'gb_niak_omitted')
    save(files_out.results,'type_measure','test_white','model_white','model_group','beta','eff','std_eff','ttest','pce','fdr','test_q','q','perc_discovery','nb_discovery')
end
