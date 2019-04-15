function [errorIds, errorSubjects, errorFile] = ...
    loop_analyze_behaviour_local(options)
% Loops over subjects in BAMP study with a local loop and executes all analysis steps %%
%
% USAGE
%        [errorIds, errorSubjects, errorFile] = loop_analyze_subject_local(options);
%
% IN
%   options         (subject-independent) analysis pipeline options,
%                   retrieve via options = dmpad_set_analysis_options
%
% OUT
%   errorIds
%   errorSubjects
%   errorFile
%
% See also dmpad_set_analysis_options
errorSubjects = {};
errorIds = {};
errorFile = options.errorfile; % TODO: time stamp? own sub-folder?
ModelArray = options.model.all;
for iModel = 1:numel(ModelArray)
    ModelName = ModelArray(iModel);
    options = bamp_options(ModelName);
    for idCell = options.subjectIDs
        id = char(idCell);
%         try
            bamp_analyze_subject(id,options);
%         catch err
%             errorSubjects{end+1,1}.id = id;
%             errorSubjects{end}.error = err;
%             errorIds{end+1} = id;
%         end
    end
end

save(fullfile(options.resultroot, errorFile), 'errorSubjects', 'errorIds');
