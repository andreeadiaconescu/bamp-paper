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
errorSubjects = {};
errorIds = {};
errorFile = options.errorfile; 
    for idCell = [options.controls options.antisocial,...
            options.psychopathy]
        id = char(idCell);
        try
            bamp_analyze_subject(id,options);
        catch err
            errorSubjects{end+1,1}.id = id;
            errorSubjects{end}.error = err;
            errorIds{end+1} = id;
        end
    end

save(fullfile(options.resultroot, errorFile), 'errorSubjects', 'errorIds');
