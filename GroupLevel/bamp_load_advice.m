function [advice_taking] = bamp_load_advice(options,subjectArray)

if nargin < 2
    subjectArray =  [options.controls, ... 
        options.psychopathy, options.antisocial];
end

subjectsAll = subjectArray;
advice      = cell(numel(subjectsAll), 10);
for  iSubject = 1:length(subjectsAll)
    id = char(subjectsAll(iSubject));
    details = bamp_ioio_subjects(id, options);

    tmp = load(fullfile(details.behav.pathResults,[details.dirSubject, '_behavVariables.mat']), ...
        'behav_bamp','-mat');
    
    advice{iSubject,1}  = tmp.behav_bamp.go_with_stable_helpful_advice2;
    advice{iSubject,2}  = tmp.behav_bamp.go_with_volatile_advice;
    advice{iSubject,3}  = tmp.behav_bamp.RTstable;
    advice{iSubject,4}  = tmp.behav_bamp.RTvolatile;
    advice{iSubject,5}  = tmp.behav_bamp.AccuracyStable;
    advice{iSubject,6}  = tmp.behav_bamp.AccuracyVolatile;
    
    advice{iSubject,7}  = tmp.behav_bamp.RTBlock4;
    advice{iSubject,8}  = tmp.behav_bamp.RTBlock5;
    
    advice{iSubject,9}  = tmp.behav_bamp.adviceBlock1;
    advice{iSubject,10}  = tmp.behav_bamp.adviceBlock5;
    
    advice{iSubject,11}  = tmp.behav_bamp.perf_acc;
    advice{iSubject,12}  = tmp.behav_bamp.take_adv_overall;
    
    advice{iSubject,13}  = tmp.behav_bamp.choice_against;
    advice{iSubject,14} = tmp.behav_bamp.choice_with;
    
    advice{iSubject,15} = tmp.behav_bamp.choice_with_chance;
    advice{iSubject,16} = tmp.behav_bamp.adviceTakingSwitch;
                               
end
advice_taking = cell2mat(advice);

%% Save as table
ofile=fullfile(options.resultroot,'bamp_behaviourVariables.xlsx');

columnNames = [{'subjectIds'}, ...
    {'AdviceStable','AdviceVolatile', ...
    'RTStable','RTVolatile',...
    'AccuracyStable','AccuracyVolatile',...
    'TakeAdviceHelpful1','TakeAdviceHelpful2',...
    'TakeHelpfulAdvice','AgainstMisleadingAdvice',...
    'PerformanceAccuracy','AdviceTaking',...
    'ChoiceAgainstAdviceWhenOdds','ChoiceWithAdviceWhenOdds',...
    'ChoiceWitheAdviceChanceOdds','AdviceTakingSwitchtoHelpful'}];
t = array2table([subjectsAll' num2cell([advice_taking])], ...
    'VariableNames', columnNames);
writetable(t, ofile);

end