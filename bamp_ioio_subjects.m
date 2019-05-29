function details = bamp_ioio_subjects(id, options)

options.subjectIDs = [options.controls options.antisocial,...
            options.psychopathy];
if ~ismember(id, options.subjectIDs)
    error('Subject %s does not belong to any group %s. Please choose right options-struct.', ...
        id, options.part);
end

root = options.root;

% General paths
details = [];
details.root = root;

details.dirSubject            = id;
details.subjectresultsroot    = fullfile(options.resultroot, details.dirSubject);
details.behav.pathData        = fullfile(options.dataroot);
details.behav.pathResults     = fullfile(details.subjectresultsroot, 'behav');

% Create subjects results directory for current preprocessing strategy
[~,~] = mkdir(details.subjectresultsroot);
[~,~] = mkdir(details.behav.pathResults);

% Tasks
details.behav.tasks = '7_EEG';
details.behav.fileRawBehav = sprintf('%s/%sperblock_IOIO_run%s.mat', details.behav.pathData, details.dirSubject, details.behav.tasks);

