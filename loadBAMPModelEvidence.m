function [models_bamp] = loadBAMPModelEvidence(options,subjects)

perceptual_models = options.model.allperceptualModels';
response_models   = options.model.allresponseModels';

[iCombPercResp]  = bamp_get_model_space;
nModels          = size(iCombPercResp,1);

nSubjects = numel(subjects);
models_bamp = cell(nSubjects, nModels);

for iSubject = 1:nSubjects
    
    id = char(subjects(iSubject));
    details = bamp_ioio_subjects(id, options);
    
    % loop over perceptual and response models
    for iModel = 1:nModels
        
        tmp = load(fullfile(details.behav.pathResults,...
            [perceptual_models{iCombPercResp(iModel,1)}...
            response_models{iCombPercResp(iModel,2)},'.mat']));
        models_bamp{iSubject,iModel} = tmp.est_bamp.optim.LME;
    end
end
models_bamp = cell2mat(models_bamp);
end