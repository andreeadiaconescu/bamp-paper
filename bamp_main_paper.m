function bamp_main_paper

%% Performs all analysis steps at the single-subject and group level
% Important: you need to have access to the raw data; the path should be specified
% in bamp_options();
options = bamp_options('RT_and_Choice');
fprintf('\n===\n\t Running the first level analysis (modelling trialwise choices and RTs:\n\n');

loop_analyze_behaviour_local(options);

fprintf('\n===\n\t Running group-level analysis and printing tables:\n\n');
bamp_second_level_RT(options);

fprintf('\n===\n\t Done!\n\n');
end