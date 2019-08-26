function bamp_plot_subject(id, options)
details = bamp_ioio_subjects(id, options);

perceptual_models = options.model.allperceptualModels';
response_models   = options.model.allresponseModels';

[iCombPercResp]  = bamp_get_model_space;
nModels          = size(iCombPercResp,1);

diagnostics = false;

for iModel= 1:nModels
    tmp = load(fullfile(details.behav.pathResults,...
        [perceptual_models{iCombPercResp(iModel,1)}...
        response_models{iCombPercResp(iModel,2)},'.mat']));
    if options.model.RT == true
        tapas_hgf_binary_plotTraj(tmp.est_bamp);
    end
    switch iModel
        case 4
            sim_bamp = tapas_simModel(tmp.est_bamp.u, options.model.winningPerceptual, ...
                tmp.est_bamp.p_prc.p, options.model.winningResponse, tmp.est_bamp.p_obs.p);
            temp  = (tmp.est_bamp.y == sim_bamp.y);
            sim_actual_y = double(temp');
            bamp_hgf_binary_plotTraj(tmp.est_bamp,sim_bamp, sim_actual_y,options);
        case {1,2,3,5,6,7,8,9,10,11,12}
            tapas_hgf_binary_plotTraj(tmp.est_bamp);
        case {16,17,18}
            tapas_hgf_ar1_binary_plotTraj(tmp.est_bamp);
        case {13,14,15}
            tapas_rw_binary_plotTraj(tmp.est_bamp);
    end
    if diagnostics == true
        tapas_fit_plotCorr(tmp.est_bamp);
    end
    
end
end