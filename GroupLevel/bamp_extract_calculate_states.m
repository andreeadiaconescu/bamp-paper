function bamp_extract_calculate_states(options,currentVAR)


if nargin < 2
    currentVAR = 'sa1hat';
end

allSubjects      =  [options.controls, ...
    options.psychopathy, options.antisocial];


% variables needed for plotting
nCon                   = length(options.controls);
nAnti                  = length(options.antisocial);
nPsych                 = length(options.psychopathy);

% Dependent Variables:
[states] = bamp_load_states(options,allSubjects);

switch currentVAR
    case 'psi3'
        currentState = 'psi3';
        label        = 'Precision Weights';
        selectedColumn = [1:2];
    case 'epsilon3'
        currentState = 'epsilon3';
        label        = 'Volatility Precision-weighted PEs';
        selectedColumn = [3:4];
    case 'sa3hat'
        currentState = 'sa3hat';
        label        = 'Volatility Uncertainty';
        selectedColumn = [5:6];
    case 'mu3hat'
        currentState = 'mu3hat';
        label        = 'Environmental Uncertainty';
        selectedColumn = [7:8];
end

Groups            = [ones(nCon,1); 2*ones(nPsych, 1); 3*ones(nAnti, 1)];

selectedVariablePhases     = {states([1:nCon],selectedColumn(1)), states([1:nCon],selectedColumn(2)),...
    states([1+nCon:nPsych+nCon],selectedColumn(1)), states([1+nCon:nPsych+nCon],selectedColumn(2)),...
    states([1+nCon+nPsych:nAnti+nCon+nPsych],selectedColumn(1)),states([1+nCon+nPsych:nAnti+nCon+nPsych],selectedColumn(2))};
reshapeVariables = selectedVariablePhases;
Groups_Conditions = {ones(nCon, 1), 2*ones(nCon, 1), 3*ones(nPsych, 1),...
    4*ones(nPsych, 1),5*ones(nAnti, 1),6*ones(nAnti, 1)};
% Within-subject Variables
withinSubjectsVariables    = states(:,selectedColumn);
betweenSubjectsVariables   = [Groups];
tblMixedANOVA              = simple_mixed_anova(withinSubjectsVariables, betweenSubjectsVariables, ...
    {'Phases'},{'Group'});
disp(tblMixedANOVA);
fprintf('\n===\n\t Mean:\n\n');
disp(mean(reshape(states(:,selectedColumn),2*length(allSubjects),1)));
fprintf('\n===\n\t STD:\n\n');
disp(std(reshape(states(:,selectedColumn),2*length(allSubjects),1)));
bamp_plot_scatter_States(reshapeVariables,Groups_Conditions,currentState,label);
end














