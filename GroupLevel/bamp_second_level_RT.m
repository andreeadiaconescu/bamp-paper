function bamp_second_level_RT(options)
%Performs all analysis steps at the group level
%   IN:
%           options     as set by bamp_options();

fprintf('\n===\n\t The following pipeline Steps were selected. Please double-check:\n\n');
Analysis_Strategy = options.pipe.executeStepsPerGroup;
disp(Analysis_Strategy);
fprintf('\n\n===\n\n');
pause(2);

doModelComparison              = Analysis_Strategy(1);
doParameterRecovery            = Analysis_Strategy(2);
doBehavAnalysis                = Analysis_Strategy(3);
doCheckParameterCorrelations   = Analysis_Strategy(4);
doParameterExtraction          = Analysis_Strategy(5);


% Deletes previous preproc/stats files of analysis specified in options
if doModelComparison
    bamp_behav_model_evidence(options);
end
if doParameterRecovery
    bamp_simulate_from_empiricalData(options);
end
if doBehavAnalysis
    bamp_extract_calculate_behaviour(options,'RT');
    bamp_extract_calculate_behaviour(options,'accuracy');
    bamp_extract_calculate_behaviour(options,'advice_taking');
end
if doCheckParameterCorrelations
    bamp_check_correlations_regressors(options);
end
if doParameterExtraction
    bamp_extract_parameters_HGF_RT_create_table(options);
    bamp_extract_calculate_MAPs(options,'omega3');
    bamp_extract_calculate_MAPs(options,'sigma');
end

