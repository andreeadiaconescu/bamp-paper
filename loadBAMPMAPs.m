function [parameters_bamp] = loadBAMPMAPs(options,subjects,comparisonType)
%IN
% analysis options
% OUT
% parameters of the winning model
options.subjectIDs = subjects;

% pairs of perceptual and response model
PerceptualModel_Parameters = options.model.hgf;
ResponseModel_Parameters = options.model.sgm;

perceptual_model = options.model.winningPerceptual;
response_model   = options.model.winningResponse;


nParameters = [PerceptualModel_Parameters';ResponseModel_Parameters'];
nSubjects = numel(options.subjectIDs);
parameters_bamp = cell(nSubjects, numel(nParameters));


for iSubject = 1:nSubjects
    id = char(options.subjectIDs(iSubject));
    details = bamp_ioio_subjects(id, options);
    tmp = load(fullfile(details.behav.pathResults,...
        [details.dirSubject, perceptual_model...
        response_model,'.mat']));
    parameters_bamp{iSubject,1} = tmp.est_bamp.p_prc.mu_0(3);
    parameters_bamp{iSubject,2} = tmp.est_bamp.p_prc.sa_0(3);
    parameters_bamp{iSubject,3} = tmp.est_bamp.p_prc.ka(2);
    parameters_bamp{iSubject,4} = tmp.est_bamp.p_prc.om(2);
    parameters_bamp{iSubject,5} = tmp.est_bamp.p_prc.om(3);
    parameters_bamp{iSubject,6} = tmp.est_bamp.p_obs.ze1;
    parameters_bamp{iSubject,7} = tmp.est_bamp.p_obs.ze2;
    parameters_bamp{iSubject,8} = tmp.est_bamp.go_against_adv_misleading;
    parameters_bamp{iSubject,9} = tmp.est_bamp.take_adv_helpful;
    parameters_bamp{iSubject,10}= tmp.est_bamp.take_adv_overall;
end
parameters_bamp = cell2mat(parameters_bamp);

% Check correlation between decision noise and volatility prior
figure; scatter(parameters_bamp(:,1),parameters_bamp(:,2));
xlabel(['\' options.model.hgf{1}]);
ylabel(['\' options.model.sgm{2}]);
[R,P]=corrcoef(parameters_bamp(:,1),parameters_bamp(:,2));
disp(['Correlation between mu3 and decision noise? Pvalue: ' num2str(P(1,2))]);

% Correlations among learning parameters
figure; scatter3(parameters_bamp(:,3),parameters_bamp(:,4),parameters_bamp(:,5),'filled');
xlabel(['\' options.model.hgf{3}]);
ylabel(['\' options.model.hgf{4}]);
zlabel(['\' options.model.hgf{5}]);
[R,P]=corrcoef(parameters_bamp(:,3),parameters_bamp(:,4));
disp(['Correlation between kappa and omega? Pvalue: ' num2str(P(1,2))]);

% Save MAPs
save(fullfile(options.resultroot, ['MAP_estimates_winning_model.mat']), ...
    'parameters_bamp', '-mat');
ofile=fullfile(options.resultroot,['MAP_estimates_winning_model.xlsx']);
columnNames = [{'subjectIds'}, options.model.hgf, options.model.sgm, ...
    {'go_against_adv_misleading', 'take_adv_helpful', 'take_adv_overall'}];
t = array2table([options.subjectIDs' num2cell(parameters_bamp)], ...
    'VariableNames', columnNames);
writetable(t, ofile);
end


