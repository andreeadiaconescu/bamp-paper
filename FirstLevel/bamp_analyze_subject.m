function bamp_analyze_subject(id, options)

doinvertSubject        = ismember('inversion', options.pipe.executeStepsPerSubject);
doplotTrajectory       = ismember('plotting', options.pipe.executeStepsPerSubject);
dobehavVariables       = ismember('behaviour', options.pipe.executeStepsPerSubject);

% Inverts the model for a given subject
if doinvertSubject
    bamp_invert_subject(id, options);
end

% Plots trajectories of a given subject
if doplotTrajectory
    bamp_plot_subject(id, options);
end

% Plots trajectories of a given subject
if dobehavVariables
    bamp_ioio_get_behaviour_subject(id, options);
end


end
