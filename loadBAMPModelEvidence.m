function [models_bamp] = loadBAMPModelEvidence(options,subjects)

perceptual_models = {'tapas_hgf_binary','tapas_hgf_binary_reduced_omega','tapas_hgf_binary_reduced_kappa',...
                      'tapas_hgf_ar1_binary','tapas_rw_binary'};
response_models  = options.model.allresponseModels';

iCombPercResp = zeros(15,2);
iCombPercResp(1:3,1)   = 1;
iCombPercResp(4:6,1)   = 2;
iCombPercResp(7:9,1)   = 3;
iCombPercResp(10:12,1) = 4;
iCombPercResp(13:15,1) = 5;

iCombPercResp(1:3,2)   = 1:3;
iCombPercResp(4:6,2)   = 4:6;
iCombPercResp(7:9,2)   = 4:6;
iCombPercResp(10:12,2) = 4:6;
iCombPercResp(13:15,2) = 4:6;

nModels = size(iCombPercResp,1);

nSubjects = numel(subjects);
models_bamp = cell(nSubjects, nModels);

for iSubject = 1:nSubjects
    
    id = char(subjects(iSubject));
    details = bamp_ioio_subjects(id, options);
    
    % loop over perceptual and response models
    for iModel = 1:nModels
        
        tmp = load(fullfile(details.behav.pathResults,...
            [details.dirSubject, perceptual_models{iCombPercResp(iModel,1)}...
            response_models{iCombPercResp(iModel,2)},'.mat']));
        models_bamp{iSubject,iModel} = tmp.est_bamp.optim.LME;
    end
end
models_bamp = cell2mat(models_bamp);
end