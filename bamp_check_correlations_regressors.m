function bamp_check_correlations_regressors(options)
subjects = [options.controls, ...
    options.psychopathy, options.antisocial];

for iSub = 1: numel(subjects)
    id = char(subjects{iSub});
    details = bamp_ioio_subjects(id,options);
    winningModel = load(fullfile(details.behav.pathResults,[options.model.winningPerceptual, ...
        options.model.winningResponse,'.mat']));
    corrMatrix    = winningModel.est_bamp.optim.Corr;
    z_transformed = real(sibak_fisherz(reshape(corrMatrix,size(corrMatrix,1)^2,1)));
    averageCorr{iSub,1}=reshape(z_transformed,size(corrMatrix,1),...
        size(corrMatrix,2));
end
save(fullfile(options.resultroot, 'bampsubjects_parameter_correlations.mat'), ...
    'averageCorr', '-mat');
% Two subjects' data is not invertable for the tapas_hgf_binary_drift
% model with mu2_0 estimated. Thus, these 2 subjects are excluded from the average computation.
if options.model.RT == 1
    averageCorr([3 69]) = [];
end

averageZCorr = mean(cell2mat(permute(averageCorr,[2 3 1])),3);
averageGroupCorr = sibak_ifisherz(reshape(averageZCorr,size(corrMatrix,1)^2,1));
finalCorr = reshape(averageGroupCorr,size(corrMatrix,1),...
    size(corrMatrix,2));
title('Correlation Matrix, averaged over subjects');
maximumCorr = max(max(finalCorr(~isinf(finalCorr))));
fprintf('\n\n----- Maximum correlation is %s -----\n\n', ...
    num2str(maximumCorr));
minimumCorr = min(min(finalCorr(~isinf(finalCorr))));
fprintf('\n\n----- Minimum correlation is %s -----\n\n', ...
    num2str(minimumCorr));
finalCorr(isnan(finalCorr))=1;
figure;imagesc(finalCorr,[-1 1]);

if options.model.RT == 1
    parametersModel = {'\mu_2','\omega_2','\omega_3','\rho','\zeta_1','\zeta_2','\beta_0','\beta_1',...
        '\beta_2','\beta_3','\beta_4','\zeta_3'};
else
    parametersModel = {'\mu_2','\omega_2','\omega_3','\zeta','\beta'};
end
set(gca,'XTick',1:numel(parametersModel))
set(gca,'XTickLabel',parametersModel);
set(gca,'YTick',1:numel(parametersModel))
set(gca,'YTickLabel',parametersModel);
colorbar(gca);
end