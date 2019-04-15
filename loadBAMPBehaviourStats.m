function [behaviour_bamp] = loadBAMPBehaviourStats(options,subjects)
%IN
% analysis options
% OUT
% behavioural_statistics

options.subjectIDs = subjects;

perceptual_model = options.model.winningPerceptual;
response_model   = options.model.winningResponse;


nBehaviourReadouts = 5;
nSubjects = numel(options.subjectIDs);
behaviour_bamp = cell(nSubjects, nBehaviourReadouts);

for iSubject = 1:nSubjects
    id = char(options.subjectIDs(iSubject));
    details = bamp_ioio_subjects(id, options);
    tmp = load(fullfile(details.behav.pathResults,...
        [details.dirSubject, perceptual_model...
        response_model,'.mat']));
    behaviour_bamp{iSubject,1} = tmp.est_bamp.take_adv_overall;
    behaviour_bamp{iSubject,2} = tmp.est_bamp.take_adv_helpful;
    behaviour_bamp{iSubject,3} = tmp.est_bamp.go_against_adv_misleading;
    behaviour_bamp{iSubject,4} = tmp.est_bamp.choice_against;
    behaviour_bamp{iSubject,5} = tmp.est_bamp.choice_with;
end
behaviour_bamp = cell2mat(behaviour_bamp);

figure; scatter(behaviour_bamp(:,3),behaviour_bamp(:,4)); % Go against misleading & Choice against advice
xlabel('against_misleadingAdvice');
ylabel('percentage_against_advice_highprob');
[R,P]=corrcoef(behaviour_bamp(:,3),behaviour_bamp(:,4));
disp(['Correlation between going against advice &  going against advice high probability? Pvalue: ' num2str(P(1,2))]);

figure; scatter(behaviour_bamp(:,2),behaviour_bamp(:,5));
xlabel('with_takingAdvice');
ylabel('percentage_with_advice_lowProb');
[R,P]=corrcoef(behaviour_bamp(:,2),behaviour_bamp(:,5));
disp(['Correlation between taking helpful advice &  going with advice low probability? Pvalue: ' num2str(P(1,2))]);

end

