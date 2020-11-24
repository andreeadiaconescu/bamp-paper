function bamp_phase_group_analyses_stats_plot(options,bamp_phases)


allSubjects      =  [options.controls, ...
    options.psychopathy, options.antisocial];

nSubjects        = length(allSubjects);
% variables needed for plotting
nCon                   = length(options.controls);
nAnti                  = length(options.antisocial);
nPsych                 = length(options.psychopathy);

currentState = 'pi2';
label        = '\pi_2';
selectedColumn = [7:9];

curr_var                    = cell2mat(reshape(bamp_phases,nSubjects,1));



selectedVariablePhases     = {curr_var([1:nCon],selectedColumn(1)), curr_var([1:nCon],selectedColumn(2)),curr_var([1:nCon],selectedColumn(3)),...
    curr_var([1+nCon:nCon+nPsych],selectedColumn(1)), curr_var([1+nCon:nCon+nPsych],selectedColumn(2)),curr_var([1+nCon:nCon+nPsych],selectedColumn(3)),...
    curr_var([1+nCon+nPsych:end],selectedColumn(1)), curr_var([1+nCon+nPsych:end],selectedColumn(2)),curr_var([1+nCon+nPsych:end],selectedColumn(3))};

reshapeVariables = selectedVariablePhases;

% Independent Variables
Groups            = [ones(nCon, 1); 2*ones(nPsych, 1); 3*ones(nAnti, 1)];
Groups_Conditions = {ones(nCon, 1), 2*ones(nCon, 1), 3*ones(nCon, 1),...
                    4*ones(nPsych, 1),5*ones(nPsych, 1), 6*ones(nPsych, 1),...
                    7*ones(nAnti, 1),8*ones(nAnti, 1), 9*ones(nAnti, 1)};
                
% Within-subject Variables
withinSubjectsVariables    = curr_var(:,selectedColumn);
betweenSubjectsVariables   = [Groups];

tblMixedANOVA              = simple_mixed_anova(withinSubjectsVariables, betweenSubjectsVariables, ...
    {'Phases'},{'Group'});
disp(tblMixedANOVA);

bamp_plot_scatter_HGFStates(reshapeVariables,Groups_Conditions,currentState,label);

end