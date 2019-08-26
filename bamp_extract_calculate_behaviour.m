function bamp_extract_calculate_behaviour(options,currentVAR)


if nargin < 2
    currentVAR = 'advice_phases';
end

allSubjects      =  [options.controls, ...
    options.psychopathy, options.antisocial];


% variables needed for plotting
nCon                   = length(options.controls);
nAnti                  = length(options.antisocial);
nPsych                 = length(options.psychopathy);

% Dependent Variables:
[advice_taking] = bamp_load_advice(options,allSubjects);

switch currentVAR
    case 'advice_taking'
        currentState = 'advice_taking';
        label        = 'Going with Advice (%)';
        selectedColumn = [1:2];
    case 'RT'
        currentState = 'RT';
        label        = 'RT';
        selectedColumn = [3:4];
    case 'accuracy'
        currentState = 'accuracy';
        label        = 'Performance Accuracy (%)';
        selectedColumn = [5:6];
    case 'advice_phases'
        currentState = 'advice_phases';
        label        = 'Going with Advice (%)';
        selectedColumn = [7:8];
end

Groups            = [ones(nCon,1); 2*ones(nPsych, 1); 3*ones(nAnti, 1)];

selectedVariablePhases     = {advice_taking([1:nCon],selectedColumn(1)), advice_taking([1:nCon],selectedColumn(2)),...
    advice_taking([1+nCon:nPsych+nCon],selectedColumn(1)), advice_taking([1+nCon:nPsych+nCon],selectedColumn(2)),...
    advice_taking([1+nCon+nPsych:nAnti+nCon+nPsych],selectedColumn(1)),advice_taking([1+nCon+nPsych:nAnti+nCon+nPsych],selectedColumn(2))};
reshapeVariables = selectedVariablePhases;
Groups_Conditions = {ones(nCon, 1), 2*ones(nCon, 1), 3*ones(nPsych, 1),...
    4*ones(nPsych, 1),5*ones(nAnti, 1),6*ones(nAnti, 1)};
% Within-subject Variables
withinSubjectsVariables    = advice_taking(:,selectedColumn);
betweenSubjectsVariables   = [Groups];
tblMixedANOVA              = simple_mixed_anova(withinSubjectsVariables, betweenSubjectsVariables, ...
    {'Phases'},{'Group'});
disp(tblMixedANOVA);
fprintf('\n===\n\t Mean:\n\n');
disp(mean(reshape(advice_taking(:,selectedColumn),2*79,1)));
fprintf('\n===\n\t STD:\n\n');
disp(std(reshape(advice_taking(:,selectedColumn),2*79,1)));
bamp_plot_scatter_States(reshapeVariables,Groups_Conditions,currentState,label);
end














