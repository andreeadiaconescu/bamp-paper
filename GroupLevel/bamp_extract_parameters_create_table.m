function [bamp_par] = bamp_extract_parameters_create_table(options,comparisonType)
%IN
% analysis options, subjects
% OUT
% parameters of the winning model and all nonmodel-based parameters
if nargin < 2
    comparisonType = 'all';
end

switch comparisonType
    case 'all'
        subjects = [options.controls options.antisocial,...
            options.psychopathy];
    case 'psychopathy'
        subjects = options.psychopathy;
    case 'offenders'
        subjects = options.antisocial;
end

% pairs of perceptual and response model
PerceptualModel_Parameters = options.model.hgf;
ResponseModel_Parameters   = options.model.sgm;

nParameters    = [PerceptualModel_Parameters';ResponseModel_Parameters'];
nSubjects      = numel(subjects);
bamp_par       = cell(nSubjects, numel(nParameters));

for iSubject = 1:nSubjects
    id = char(subjects(iSubject));
    details = bamp_ioio_subjects(id, options);
    tmp = load(fullfile(details.behav.pathResults,[options.model.winningPerceptual, ...
        options.model.winningResponse,'.mat']), 'est_bamp','-mat');
    
    bamp_par{iSubject,1} = tapas_sgm(tmp.est_bamp.p_prc.mu_0(2),1);
    bamp_par{iSubject,2} = tmp.est_bamp.p_prc.ka(2);
    bamp_par{iSubject,3} = tmp.est_bamp.p_prc.om(2);
    bamp_par{iSubject,4} = tmp.est_bamp.p_prc.om(3);
    bamp_par{iSubject,5} = tmp.est_bamp.p_prc.rho(2);
    bamp_par{iSubject,6} = tmp.est_bamp.p_obs.ze1;
    bamp_par{iSubject,7} = tmp.est_bamp.p_obs.ze2;
end
bamp_par = cell2mat(bamp_par);
save(fullfile(options.resultroot, ['MAP_estimates_winning_model.mat']), ...
    'bamp_par', '-mat');
ofile=fullfile(options.resultroot,['MAP_estimates_winning_model.xlsx']);

columnNames = [{'subjectIds'}, options.model.hgf, options.model.sgm];
t = array2table([subjects' num2cell(bamp_par)], ...
    'VariableNames', columnNames);
writetable(t, ofile);

end



