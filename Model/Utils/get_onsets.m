datapath = '/Users/drea/Documents/Social_Learning_EEG/social_learning_pharma_EEG/data/';

hdr={'block_number','trial_number','iti','type_stim','type_video','when_cue_adv',...
    'probe','button_press', 'type_response','time_response',...
    'reaction_time', 'type_target','outcome','when_target','correctness',...
    'cs_score'};

txt=sprintf('%s/t',hdr{:});
txt(end)='';

for i=1:numel(subjects)
    sub=subjects{i};
    for c=1:numel(task)
        t=task{c};
        load(fullfile(datapath, [sub '/behav/' sub 'perblock_IOIO_run' t '_EEG.mat']));
        outputmatrix=get_responses(SOC.Session(2).exp_data);
        if strcmp(sub,'DMPAD_0180') && strcmp(t,'16')
            outputmatrix=outputmatrix([1:99],:);
            save(fullfile(datapath, [sub '/behav/' sub 'onsets_regressor_' t '.mat']),'outputmatrix','-mat');
        else
            save(fullfile(datapath, [sub '/behav/' sub 'onsets_regressor_' t '.mat']),'outputmatrix','-mat');
        end
    end
end

