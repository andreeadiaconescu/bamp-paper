function [variablesPerceptualModels] = bamp_simulate_from_empiricalData(options)
%IN
% analysis options
% OUT
% parameters of the winning model and all recovered parameters from
% simulating responses from the parameters of the winning model

if nargin < 2
    comparisonType = 'all';
end

switch comparisonType
    case 'all'
        subjects = [options.controls, options.psychopathy, options.antisocial];
    case 'psychopathy'
        subjects = options.psychopathy;
    case 'offenders'
        subjects = options.antisocial;
end

nSubjects = numel(subjects);        

% parameters and subjects
Parameters                    =  {'om2','om3'};
ResponseModelParameters       =  {'ze1','ze2','baseline', 'uncertainty1','uncertainty2','volatility','noise'};
simParameters                 =  {'sim_om2','sim_om3'};
simResponseModelParameters    =  {'sim_ze1','sim_ze2','sim_baseline','sim_uncertainty1','sim_uncertainty2','sim_volatility','sim_noise'};

nParameters = numel([Parameters ResponseModelParameters]');
variables_bamp = cell(nSubjects, numel(nParameters));
simulated_bamp = cell(nSubjects, numel(nParameters));

% % Load seed for reproducible results
rng('shuffle');
% state = rng;
File = fullfile(options.configroot, 'RNGState.mat');
% save(File, 'state');
Data  = load(File);
state = Data.state;
rng(state);

for iSubject = 1:nSubjects
            id = char(subjects(iSubject));
            details = bamp_ioio_subjects(id, options);
    fileBehav = details.behav.fileRawBehav;
    sub = details.dirSubject;
    if ~exist(fileBehav, 'file')
        warning('Behavioral logfile for subject %s not found', sub)
    else
        subjectData = load(fileBehav);
        [behavMatrix,~,~] = bamp_get_responses(subjectData.SOC.Session(2).exp_data,options);
        finalBehavMatrix = behavMatrix;
        outputMatrix     = finalBehavMatrix;
    end
    
    % Collect data needed
    input_u_fromfile = outputMatrix(:,1);
    piechart_fromfile= outputMatrix(:,2);
    input_u          = [input_u_fromfile piechart_fromfile];
    if options.model.RT == true
        y_choice         = [outputMatrix(:,3) outputMatrix(:,5)];
    else
        y_choice         = outputMatrix(:,3);
    end
    
    est_bamp=tapas_fitModel(y_choice,input_u,[options.model.winningPerceptual,'_config'],...
            [options.model.winningResponse,'_config']);
        bamp_plotTraj(est_bamp,options);
    sim = tapas_simModel(est_bamp.u,options.model.winningPerceptual,...
        est_bamp.p_prc.p,options.model.winningResponse,est_bamp.p_obs.p);
    y_responses = sim.y;
    input_u     = sim.u;
    
    sim_bamp=tapas_fitModel(y_responses,input_u,[options.model.winningPerceptual,'_config'],...
        [options.model.winningResponse,'_config']);
    
    variables_bamp{iSubject,1} = est_bamp.p_prc.om(2);
    variables_bamp{iSubject,2} = est_bamp.p_prc.om(3);
    variables_bamp{iSubject,3} = est_bamp.p_obs.ze1;
    variables_bamp{iSubject,4} = est_bamp.p_obs.ze2;
    variables_bamp{iSubject,5} = est_bamp.p_obs.be0;
    variables_bamp{iSubject,6} = est_bamp.p_obs.be1;
    variables_bamp{iSubject,7} = est_bamp.p_obs.be2;
    variables_bamp{iSubject,8} = est_bamp.p_obs.be3;
    variables_bamp{iSubject,9} = est_bamp.p_obs.ze;

    simulated_bamp{iSubject,1} = sim_bamp.p_prc.om(2);
    simulated_bamp{iSubject,2} = sim_bamp.p_prc.om(3);
    simulated_bamp{iSubject,3} = sim_bamp.p_obs.ze1;
    simulated_bamp{iSubject,4} = sim_bamp.p_obs.ze2;
    simulated_bamp{iSubject,5} = sim_bamp.p_obs.be0;
    simulated_bamp{iSubject,6} = sim_bamp.p_obs.be1;
    simulated_bamp{iSubject,7} = sim_bamp.p_obs.be2;
    simulated_bamp{iSubject,8} = sim_bamp.p_obs.be3;
    simulated_bamp{iSubject,9} = sim_bamp.p_obs.ze;
    
end

variables_all             = [cell2mat(variables_bamp) cell2mat(simulated_bamp)];
variablesPerceptualModels = [variables_bamp(:,[1:2]) simulated_bamp(:,[1:2])];
variablesResponseModels   = [variables_bamp(:,[3:end]) simulated_bamp(:,[3:end])];
%% Save it
ofile=fullfile(options.configroot,'bamp_empirical_simulated.xlsx');
subjects = subjects';
columnNames = [{'subjectIds'}, Parameters, ResponseModelParameters,simParameters, simResponseModelParameters];
t = array2table([subjects variables_bamp simulated_bamp], ...
    'VariableNames', columnNames);
writetable(t, ofile);

%% Plot it
bamp_simulate_from_empiricalData_PerpPlot(cell2mat(variablesPerceptualModels),options);
bamp_simulate_from_empiricalData_RespPlot(cell2mat(variablesResponseModels),options);
end



