function bamp_behav_model_evidence(options)
%IN
% options
% Function saves model selection results

subjects = [options.controls options.antisocial,...
            options.psychopathy];

[models_bamp]                                       = loadBAMPModelEvidence(options,subjects);
[bamp_model_posterior,bamp_xp, bamp_protected_xp]   = bamp_behav_plot_model_selection(options,models_bamp);

save(fullfile(options.resultroot ,['model_selection_results.mat']), ...
    'bamp_model_posterior','bamp_xp', 'bamp_protected_xp', '-mat');
end

