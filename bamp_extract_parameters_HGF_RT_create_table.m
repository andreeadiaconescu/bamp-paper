function [variables_all] = bamp_extract_parameters_HGF_RT_create_table(options,comparisonType)
%IN
% analysis options, subjects
% OUT
% parameters of the winning model and all nonmodel-based parameters
if nargin < 2
    comparisonType = 'all';
end

switch comparisonType
    case 'all'
        subjects = [options.controls, options.psychopathy, options.antisocial];
    case 'psychopathy'
        subjects = options.psychopathy;
    case 'offenders'
        subjects = options.antisocial;
end

% pairs of perceptual and response model
PerceptualModel_Parameters = options.model.hgf;
ResponseModel_Parameters   = {'ze1','ze2','beta1','beta2','beta3','beta4','ze3'};
subjectsIncluded           = subjects;

nParameters = [PerceptualModel_Parameters';ResponseModel_Parameters'];
nSubjects = numel(subjectsIncluded);
variables_bamp = cell(nSubjects, numel(nParameters)); % 16 is the number of nonmodel-based variables


for iSubject = 1:nSubjects
     id = char(subjects(iSubject));
    details = bamp_ioio_subjects(id, options);
    tmp = load(fullfile(details.behav.pathResults,[options.model.winningPerceptual, ...
        options.model.winningResponse,'.mat']), 'est_bamp','-mat');
    variables_bamp{iSubject,1} = tmp.est_bamp.p_prc.mu_0(2);
    variables_bamp{iSubject,2} = tmp.est_bamp.p_prc.ka(2);
    variables_bamp{iSubject,3} = tmp.est_bamp.p_prc.om(2);
    variables_bamp{iSubject,4} = tmp.est_bamp.p_prc.om(3);
    variables_bamp{iSubject,5} = tmp.est_bamp.p_obs.ze1;
    variables_bamp{iSubject,6} = tmp.est_bamp.p_obs.ze2;
    variables_bamp{iSubject,7} = tmp.est_bamp.p_obs.be1;
    variables_bamp{iSubject,8} = tmp.est_bamp.p_obs.be2;
    variables_bamp{iSubject,9} = tmp.est_bamp.p_obs.be3;
    variables_bamp{iSubject,10} = tmp.est_bamp.p_obs.be4;
    variables_bamp{iSubject,11} = tmp.est_bamp.p_obs.ze;
end


variables_all = [cell2mat(variables_bamp)];
save(fullfile(options.resultroot, [comparisonType '_MAP_estimates_HGF_RT.mat']), ...
    'variables_bamp', '-mat');
ofile=fullfile(options.resultroot,[comparisonType '_MAP_estimates_HGF_RT_nonModelVariables.xlsx']);

columnNames = [{'subjectIds'}, options.model.hgf, ResponseModel_Parameters];
t = array2table([subjectsIncluded' num2cell(variables_all)], ...
    'VariableNames', columnNames);
writetable(t, ofile);
end



