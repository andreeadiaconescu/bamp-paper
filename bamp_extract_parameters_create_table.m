function [variables_bamp] = bamp_extract_parameters_create_table(options)
%IN
% analysis options, subjects
% OUT
% parameters of the winning model and all nonmodel-based parameters
subjects = options.subjectIDs;

% pairs of perceptual and response model
PerceptualModel_Parameters = options.model.hgf;
ResponseModel_Parameters   = options.model.sgm;

perceptual_model = options.model.winningPerceptual;
response_model   = options.model.winningResponse;

nParameters    = [PerceptualModel_Parameters';ResponseModel_Parameters'];
nSubjects      = numel(options.subjectIDs);
variables_bamp = cell(nSubjects, numel(nParameters)+16); % 16 is the number of nonmodel-based variables


for iSubject = 1:nSubjects
    id = char(options.subjectIDs(iSubject));
    details = bamp_ioio_subjects(id, options);
    tmp = load(fullfile(details.behav.pathResults,...
        [perceptual_model,response_model,'.mat']));
    variables_bamp{iSubject,1} = tmp.est_bamp.p_prc.mu_0(2);
    variables_bamp{iSubject,2} = tmp.est_bamp.p_prc.ka(2);
    variables_bamp{iSubject,3} = tmp.est_bamp.p_prc.om(2);
    variables_bamp{iSubject,4} = tmp.est_bamp.p_prc.om(3);
    variables_bamp{iSubject,5} = tmp.est_bamp.p_obs.ze1;
    variables_bamp{iSubject,6} = tmp.est_bamp.p_obs.ze2;
    variables_bamp{iSubject,7} = tmp.est_bamp.perf_acc;
    variables_bamp{iSubject,8} = tmp.est_bamp.take_adv_helpful;
    variables_bamp{iSubject,9} = tmp.est_bamp.go_against_adv_misleading;
    variables_bamp{iSubject,10}= tmp.est_bamp.choice_with;
    variables_bamp{iSubject,11}= tmp.est_bamp.choice_against;
    variables_bamp{iSubject,12}= tmp.est_bamp.take_adv_overall;
end
variables_bamp = cell2mat(variables_bamp);
save(fullfile(options.resultroot, ['MAP_estimates_winning_model_nonModelVariables.mat']), ...
    'variables_bamp', '-mat');
ofile=fullfile(options.resultroot,['MAP_estimates_winning_model_nonModelVariables.xlsx']);

columnNames = [{'subjectIds'}, options.model.hgf, options.model.sgm, ...
    {'performanceAccuracy','take_adv_helpful', ...
    'go_against_adv_misleading','choiceAdvice','againstAdvice',...
    'take_adv_overall'}];
t = array2table([subjects' num2cell(variables_bamp)], ...
    'VariableNames', columnNames);
writetable(t, ofile);

end



