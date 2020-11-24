function options = bamp_options(ModelCategory)

options = [];

options.doRunOnArton = false; % parallelization on other cluster with ssd scratch disk

if nargin < 1
    ModelCategory = 'RT_and_Choice'; % other option: 'Choice'
end

%% User folders-----------------------------------------------------------%
[~, uid] = unix('whoami');
switch uid(1: end-1)
    case 'drea'
        dataroot         = '/Users/drea/Documents/Collaborations/IntiBrazil/DATA_SL';
        resultroot       = '/Users/drea/Documents/Collaborations/IntiBrazil/Results';
        configroot       = fullfile(fileparts(mfilename('fullpath')), '/Utils');
end

%% Paths

% create folders, if non existent, and don't give warnings, if they do
% (won't be overwritten!)
[~,~] = mkdir(resultroot);

options.root           = dataroot;
options.dataroot       = dataroot;
options.resultroot     = resultroot;
options.configroot     = configroot;
options.code           = fullfile(fileparts(mfilename('fullpath')));
options.model.pathPerceptual = fullfile([options.code,'/Perceptual_Models']);
options.model.pathResponse   = fullfile([options.code,'/Response_Models']);

addpath(genpath(options.code));
addpath('/Users/drea/Documents/Toolboxes/spm12')

%% Analysis steps to be run
options.pipe.executeStepsPerSubject = {
    'inversion'
    'behaviour'}; % plotting is also an option here
options.pipe.executeStepsPerGroup   = [0 1 1 1];
options.family.template = fullfile(options.configroot,'family_allmodels.mat');

%% Specific to IOIO task
options.cue                    = fullfile(options.configroot,'DMPAD_N189_cue.txt'); % specify the IOIO design here
options.task.cueCodes          = [9:14];
options.task.cueProbs          = [0.75:-0.10:0.25];
options.task.probabilities     = [0.70,0.80,0.50,0.30,0.20,0.30,0.50,0.70,0.80];
options.task.TrialsperBlock    = 21;
options.task.TrialbyTrialprob  = ...
    [ones(options.task.TrialsperBlock,1).*options.task.probabilities(1);ones(options.task.TrialsperBlock,1).*options.task.probabilities(2);...
    ones(options.task.TrialsperBlock,1).*options.task.probabilities(3);ones(options.task.TrialsperBlock,1).*options.task.probabilities(4);...
    ones(options.task.TrialsperBlock,1).*options.task.probabilities(5); ones(options.task.TrialsperBlock,1).*options.task.probabilities(6);...
    ones(options.task.TrialsperBlock,1).*options.task.probabilities(7);ones(options.task.TrialsperBlock,1).*options.task.probabilities(8);...
    ones(options.task.TrialsperBlock,1).*options.task.probabilities(9)];

%% Find trial indices
% trials 1:42 are 80% helpful, trials 43:147 are variable, trials 147:210 are 80% helpful
options.task.helpfulPhase1 = vertcat(ones(42,1), zeros(147,1));
options.task.helpfulPhase2 = vertcat(zeros(147,1), ones(42,1));
options.task.volatilePhase = vertcat(zeros(42,1), ones(105,1), zeros(42,1));
options.task.switchHelpful = vertcat(zeros(142,1), ones(6,1), zeros(41,1));

%% Model Category
switch ModelCategory
    case 'RT_and_Choice'
        options.model.RT  = 1;
    case 'Choice'
        options.model.RT  = 0;
end

if options.model.RT == true
    options.model.winningPerceptual = 'bamp_hgf_binary_drift';
    options.model.winningResponse   = 'bamp_logrt_linear_binary';
else
    options.model.winningPerceptual = 'tapas_hgf_binary_reduced_omega';
    options.model.winningResponse   = 'tapas_ioio_unitsq_sgm';
end


ModelName                       = 'HGF_Reduced1';
options.errorfile               = 'Error_FirstLevel.mat';

%% Model simulations
if options.model.RT == true
    options.model.simPerceptual = 'tapas_hgf_binary_drift';
    options.model.simResponse   = 'bamp_logrt_linear_binary';
end

%% Details about the models available and included here
switch ModelName
    case 'HGF'
        options.model.perceptualModels   = 'tapas_hgf_binary';
        options.model.responseModels   = ...
            {'tapas_ioio_unitsq_sgm_mu3','tapas_ioio_cue_unitsq_sgm_mu3',...
            'tapas_ioio_advice_unitsq_sgm_mu3'};
        options.model.simulationsParameterArray = {'ka','om','th','ze','mu2_0'};
    case 'HGF_Drift'
        options.model.perceptualModels   = 'tapas_hgf_binary_drift';
        options.model.responseModels   = ...
            {'tapas_ioio_unitsq_sgm','tapas_ioio_cue_unitsq_sgm',...
            'tapas_ioio_advice_unitsq_sgm'};
        options.model.simulationsParameterArray = {'rho','om','th','ze','mu2_0'};
    case 'HGF_Reduced1'
        options.model.perceptualModels   = 'tapas_hgf_binary_reduced_omega';
        options.model.responseModels   = ...
            {'tapas_ioio_unitsq_sgm','tapas_ioio_cue_unitsq_sgm',...
            'tapas_ioio_advice_unitsq_sgm'};
    case 'HGF_2L'
        options.model.perceptualModels   = 'tapas_hgf_binary_novol';
        options.model.responseModels   = ...
            {'tapas_ioio_unitsq_sgm','tapas_ioio_cue_unitsq_sgm',...
            'tapas_ioio_advice_unitsq_sgm'};
        options.model.simulationsParameterArray = {'ka','om','ze'};
    case 'HGF_Attractor'
        options.model.perceptualModels   = 'tapas_hgf_binary_attractor';
        options.model.responseModels   = ...
            {'tapas_ioio_unitsq_sgm','tapas_ioio_cue_unitsq_sgm',...
            'tapas_ioio_advice_unitsq_sgm'};
        options.model.simulationsParameterArray = {'ka1','om','th','ze','mu2_0'};
    case 'HGF_Reduced2'
        options.model.perceptualModels   = 'tapas_hgf_binary_reduced_kappa';
        options.model.responseModels   = ...
            {'tapas_ioio_unitsq_sgm','tapas_ioio_cue_unitsq_sgm',...
            'tapas_ioio_advice_unitsq_sgm'};
        options.model.simulationsParameterArray = {'ka','om','th','ze','mu2_0'};
    case 'RW'
        options.model.perceptualModels   = 'tapas_rw_binary';
        options.model.responseModels   = ...
            {'tapas_ioio_unitsq_sgm','tapas_ioio_cue_unitsq_sgm',...
            'tapas_ioio_advice_unitsq_sgm'};
    case 'AR1_2level'
        options.model.perceptualModels   = 'tapas_hgf_binary_ar1_level2';
        options.model.responseModels   = ...
            {'tapas_ioio_unitsq_sgm','tapas_ioio_cue_unitsq_sgm',...
            'tapas_ioio_advice_unitsq_sgm'};
        options.model.simulationsParameterArray = {'ka','om','th','ze','m2'};
    case 'AR1_3level'
        options.model.perceptualModels   = 'tapas_hgf_binary_ar1_level3';
        options.model.responseModels   = ...
            {'tapas_ioio_unitsq_sgm','tapas_ioio_cue_unitsq_sgm',...
            'tapas_ioio_advice_unitsq_sgm'};
        options.model.simulationsParameterArray = {'ka','om','th','ze','m3'};
end


%% Models inverted: when fitting both RT and choice or choice only. The model space is the same, but for the RT models, we do not include RW
if options.model.RT == true
    options.model.allperceptualModels = {'bamp_hgf_binary_drift'};
    options.model.allresponseModels = ...
        { 'bamp_logrt_linear_binary'};
else
    options.model.allperceptualModels = {'tapas_hgf_binary','tapas_hgf_binary_reduced_omega','tapas_hgf_binary_reduced_kappa',...
        'tapas_hgf_binary_drift', 'tapas_hgf_binary_novol','tapas_rw_binary'};
    options.model.allresponseModels = ...
        {'tapas_ioio_unitsq_sgm_mu3','tapas_ioio_cue_unitsq_sgm_mu3','tapas_ioio_advice_unitsq_sgm_mu3',...
        'tapas_ioio_unitsq_sgm','tapas_ioio_cue_unitsq_sgm','tapas_ioio_advice_unitsq_sgm'};
end

%% Model names and labels

options.family.perceptual.labels = {'HGF', 'HGF_R1','HGF_R2','HGF_Drift','HGF_2L','RW'};
options.family.perceptual.partition = [1 1 1 2 2 2 3 3 3 4 4 4 5 5 5 6 6 6];

options.family.responsemodels1.labels = {'Both','Cue','Advice'};
options.family.responsemodels1.partition = [1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3];
options.model.labels = ...
    {'HGF', 'Cue','Advice',...
    'HGF1 Omega', 'Cue','Advice',...
    'HGF2 Kappa', 'Cue','Advice',...
    'Drift','Cue','Advice',...
    '2LV HGF', 'Cue','Advice',...
    'RW','Cue','Advice'};

%% Parameter names and labels
% Parameters
options.model.hgf   = {'omega_2','omega_3'};
options.model.rw    = {'mu2_0','alpha'};
options.model.ar1   = {'m3','phi3','kappa','omega_2','omega_3'};
options.model.sgm   = {'zeta_1','zeta_2'};

%% Subject IDs ------------------------------------------------------------%
% Local function for drug group specific settings
options = subject_details(options);
%% Subjects with specific name rules
    function detailsOut = subject_details(detailsIn)
        
        detailsOut = detailsIn;
        detailsOut.offenders=...
            {'A1701','A1702','A1703','A1704','A1705','A1706',...
            'A1708','A1709','A1710','A1711','A1712','A1713',...
            'A1714','A1715','A1716','A1717','A1718','P1701_retake',...
            'P1702','P1703','P1704','P1705','P1706','P1707','P1708',...
            'P1709','P1710','P1711','P1712','P1713','P1714','P1715',...
            'P1716','P1717','P1718','P1720','P1721','P1722','V1701',...
            'V1702','V1703','V1704','V1705','V1706','V1707','V1708',...
            'V1709','V1710','V1711','V1712','V1713-2','V1714','V1715','V1716'};
        detailsOut.controls=...
            {'C1701','C1705','C1710','C1718','C1719','C1720','C1901SL',...
            'C1902SL','C1903SL','C1904SL','C1905SL','C1906SL','C1907SL',...
            'C1908SL','C1909SL','C1910SL','C1911SL','C1912SL','C1913SL',...
            'C1914SL','C1915SL','C1916SL','C1917SL','C1918SL','C1919SL',...
            'C1920SL','C1921SL','C1922SL','C1923SL'};
        detailsOut.antisocial=...
            {'A1701','A1702','A1703','A1704','A1705','A1706','A1708',...
            'A1709','A1710','A1711','A1712','A1713','A1714','A1715',...
            'A1716','A1717','A1718','V1701','V1702','V1704','V1707',...
            'V1708','V1710','V1711','V1713-2','V1714','V1716'};
        detailsOut.psychopathy=...
            {'P1701_retake','P1702','P1703','P1704','P1705','P1706',...
            'P1707','P1708','P1709','P1710','P1711','P1712','P1713',...
            'P1714','P1715','P1716','P1717','P1718','P1720','P1721',...
            'P1722','V1703','V1705','V1706','V1709','V1712','V1715'};
    end
end
