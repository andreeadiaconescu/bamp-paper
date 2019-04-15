function bamp_ioio_get_behaviour_subject(id, options)

details = bamp_ioio_subjects(id, options);
fileBehav = details.behav.fileRawBehav;


[cue, cue_advice_space,~,input_u,takeAdv,take_helpfulAdvice, ...
    perf_acc,against_misleadingAdvice,percentage_against_advice_hiprob,...
    percentage_with_advice_lowprob] = getBAMPData(details,options,fileBehav);
if isempty(input_u) % cue and cue advice are not subject-dependent, have to check inputs
    error('Behavioral data for subject %s not found', sub);
end


behav_bamp.take_adv_helpful                      = take_helpfulAdvice;
behav_bamp.go_against_adv_misleading             = against_misleadingAdvice;
behav_bamp.perf_acc                              = perf_acc;
behav_bamp.choice_against                        = percentage_against_advice_hiprob;
behav_bamp.choice_with                           = percentage_with_advice_lowprob;
behav_bamp.cue                                   = cue;
behav_bamp.cue_advice_space                      = cue_advice_space;
behav_bamp.take_adv_overall                      = takeAdv;

save(fullfile(details.behav.pathResults,[details.behav.BAMPTaskName,'.mat']), 'behav_bamp','-mat');
end
