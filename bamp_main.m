function bamp_main

%% Performs all analysis steps at the single-subject and group level
% Important: you need to have access to the raw data; the path should be specified
% in bamp_options();

%% Analysis part 2
options = bamp_options('Choice');
fprintf('\n===\n\t Running the first level analysis (modelling trialwise choices:\n\n');

loop_analyze_behaviour_local(options);

fprintf('\n===\n\t Running group-level analysis and printing tables:\n\n');
bamp_second_level(options);

%% Analysis part 1
options = bamp_options('RT');
fprintf('\n===\n\t Running the first level analysis (modelling trialwise choices and RTs:\n\n');

loop_analyze_behaviour_local(options);

fprintf('\n===\n\t Running group-level analysis and printing tables:\n\n');
bamp_second_level_choice_RT(options);

fprintf('\n===\n\t Done!\n\n');
end