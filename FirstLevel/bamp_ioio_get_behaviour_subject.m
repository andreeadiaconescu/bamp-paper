function bamp_ioio_get_behaviour_subject(id, options)

details = bamp_ioio_subjects(id, options);
fileBehav = details.behav.fileRawBehav;

sub = details.dirSubject;

if ~exist(fileBehav, 'file')
    warning('Behavioral logfile for subject %s not found', sub)
    y = [];
    input_u = [];
else
    subjectData = load(fileBehav);
    [behavMatrix,codeMatrix,~] = bamp_get_responses(subjectData.SOC.Session(2).exp_data,options);
    finalBehavMatrix = behavMatrix;
    finalCodeMatrix  = codeMatrix;
    outputMatrix     = finalBehavMatrix;
    outputCodes      = finalCodeMatrix;
    

end

save(fullfile(details.behav.pathResults,'behavMatrix.mat'), 'outputMatrix','outputCodes','-mat');

% Collect data needed
input_u_fromfile = outputMatrix(:,1);
piechart_fromfile= outputMatrix(:,2);
input_u          = [input_u_fromfile piechart_fromfile];
y_choice         = outputMatrix(:,3);
RT               = outputMatrix(:,5);
cumScore         = outputMatrix(:,7);
probeSelection   = outputMatrix(:,8);
iValid           = logical(outputMatrix(:,end));

[perf_acc,~,take_adv_helpful,go_against_adv_misleading,choice_with, ...
                choice_against,choice_with_chance,go_with_stable_helpful_advice,...
                adviceTakingSwitch,...
                go_with_volatile_advice, go_against_volatile_advice,...
                go_with_stable_helpful_advice1,go_with_stable_helpful_advice2,...
                take_adv_overall,RTStable,RTVolatile,AccuracyStable,AccuracyVolatile,RTStableAdvice1, RTStableAdvice2,...
                adviceBlock1, RTBlock1,adviceBlock2, RTBlock2,adviceBlock3,RTBlock3,adviceBlock4,RTBlock4,adviceBlock5,RTBlock5] ...
                = getBAMPData(input_u,y_choice,RT,iValid,options);
            
if isempty(input_u) % cue and cue advice are not subject-dependent, have to check inputs
    error('Behavioral data for subject %s not found', sub);
end

%% Probes
probeCategories = [probeSelection(1,1) probeSelection(14,1), ...
    probeSelection(49,1) probeSelection(73,1),...
    probeSelection(110,1)];
probes          = [];

for iProbe = 1:numel(probeCategories)
    switch probeCategories(iProbe)
        case 0
            probeValue = 0.5;
        case 1
            probeValue = 0.5;
        case 2
            probeValue = 0;
        case 3
            probeValue = 1;
            
    end
    
    probeValue(iProbe) = probeValue;
    
    probes = [probes; probeValue(iProbe)];
end


%% Store data
behav_bamp=[];

behav_bamp.cScore                                = cumScore(end);
behav_bamp.take_adv_helpful                      = take_adv_helpful;
behav_bamp.go_against_adv_misleading             = go_against_adv_misleading;
behav_bamp.perf_acc                              = perf_acc;
behav_bamp.choice_against                        = choice_against;
behav_bamp.choice_with                           = choice_with;
behav_bamp.choice_with_chance                    = choice_with_chance;
behav_bamp.go_with_stable_helpful_advice         = go_with_stable_helpful_advice;
behav_bamp.go_with_stable_helpful_advice1        = go_with_stable_helpful_advice1;
behav_bamp.go_with_stable_helpful_advice2        = go_with_stable_helpful_advice2;
behav_bamp.adviceTakingSwitch = adviceTakingSwitch;
behav_bamp.go_with_volatile_advice               = go_with_volatile_advice;
behav_bamp.take_adv_overall                      = take_adv_overall;
behav_bamp.go_against_volatile_advice            = go_against_volatile_advice;
behav_bamp.RTstable                              = RTStable;
behav_bamp.RTvolatile                            = RTVolatile;
behav_bamp.AccuracyStable                        = AccuracyStable;
behav_bamp.AccuracyVolatile                      = AccuracyVolatile;
behav_bamp.probe                                 = probes';
behav_bamp.RTStableAdvice1                       = RTStableAdvice1;
behav_bamp.RTStableAdvice2                       = RTStableAdvice2;
behav_bamp.RTBlock1                       = RTBlock1;
behav_bamp.RTBlock2                       = RTBlock2;
behav_bamp.RTBlock3                       = RTBlock3;
behav_bamp.RTBlock4                       = RTBlock4;
behav_bamp.RTBlock5                       = RTBlock5;

behav_bamp.adviceBlock1                       = adviceBlock1;
behav_bamp.adviceBlock2                       = adviceBlock2;
behav_bamp.adviceBlock3                       = adviceBlock3;
behav_bamp.adviceBlock4                       = adviceBlock4;
behav_bamp.adviceBlock5                       = adviceBlock5;

save(fullfile(details.behav.pathResults,[details.dirSubject, '_behavVariables.mat']), 'behav_bamp','-mat');
end
