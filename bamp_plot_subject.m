function bamp_plot_subject(id, options)
details = bamp_ioio_subjects(id, options);
responseModels   = options.model.responseModels;

diagnostics = false;

for iRsp=1 % :numel(responseModels)
load(fullfile(details.subjectresultsroot,['behav/',details.behav.invertBAMPName, ...
        options.model.responseModels{iRsp},'.mat']), 'est_bamp','-mat');
    
    sim_bamp = tapas_simModel(est_bamp.u, options.model.winningPerceptual, ...
        est_bamp.p_prc.p, options.model.winningResponse, est_bamp.p_obs.p); 
        temp  = (est_bamp.y == sim_bamp.y);
        sim_actual_y = double(temp');
        bamp_hgf_binary_plotTraj(est_bamp,sim_bamp, sim_actual_y,options);
        
    if diagnostics == true
        tapas_fit_plotCorr(est_bamp);
    end

end
end