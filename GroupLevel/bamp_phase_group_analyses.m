function bamp_phase_group_analyses(options)


subjects = [options.controls options.antisocial,...
            options.psychopathy]; 


% variables needed for plotting
nSubjects                  = size(subjects,2);


for iSubject = 1:nSubjects
    id = char(subjects(iSubject));
    details = bamp_ioio_subjects(id, options);
    tmp = load(fullfile(details.behav.pathResults,[options.model.winningPerceptual, ...
                options.model.winningResponse,'.mat']), 'est_bamp','-mat');    % Select the winning model only;
    [~,quantities_phases]    = bamp_extract_computational_quantities(tmp.est_bamp,options);
    bamp_phases{iSubject}                           = quantities_phases;
end

bamp_phase_group_analyses_stats_plot(options,bamp_phases);

end

