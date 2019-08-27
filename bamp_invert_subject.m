function bamp_invert_subject(id, options)
% IN
%   id          subject id string, only number (e.g. '0002')
%   options     general analysis options%
%               options = bamp_ioio_options
% NB: Behaviour data is also saved with the inversion

perceptual_models = options.model.allperceptualModels;
response_models   = options.model.allresponseModels;

[iCombPercResp]  = bamp_get_model_space;
nModels          = size(iCombPercResp,1);

for iModel = 1:nModels
    details = bamp_ioio_subjects(id, options);
    fileBehav = details.behav.fileRawBehav;
    sub = details.dirSubject;
    if ~exist(fileBehav, 'file')
        warning('Behavioral logfile for subject %s not found', sub)
    else
        subjectData = load(fileBehav);
        [behavMatrix,~,~] = bamp_get_responses(subjectData.SOC.Session(2).exp_data,options);
        finalBehavMatrix = behavMatrix;
        outputMatrix     = finalBehavMatrix;
    end
    
    % Collect data needed
    input_u_fromfile = outputMatrix(:,1);
    piechart_fromfile= outputMatrix(:,2);
    input_u          = [input_u_fromfile piechart_fromfile];
    if options.model.RT == true
        y_choice         = [outputMatrix(:,3) outputMatrix(:,5)];
    else
        y_choice         = outputMatrix(:,3);
    end
    
    % Two subjects' data is not invertable for the tapas_hgf_binary_drift
    % model with mu2_0 estimated. Thus, for these 2 subjects, we fix mu2_0.
    if options.model.RT == 1 && iModel == 3
        switch id
            case {'C1710','A1718'}
                est_bamp=tapas_fitModel(y_choice,input_u,['tapas_hgf_binary_drift_fix_mu20_config'],...
                    [response_models{iCombPercResp(iModel,2)},'_config']);
            otherwise
                est_bamp=tapas_fitModel(y_choice,input_u,['tapas_hgf_binary_drift_config'],...
                    [response_models{iCombPercResp(iModel,2)},'_config']);
        end
        
    else
        est_bamp=tapas_fitModel(y_choice,input_u,[perceptual_models{iCombPercResp(iModel,1)},'_config'],...
            [response_models{iCombPercResp(iModel,2)},'_config']);
    end
    est_bamp.cue_advice_space                      = piechart_fromfile;
    est_bamp.take_adv_overall                      = nansum(input_u_fromfile)./size(input_u,1);
    
    save(fullfile(details.behav.pathResults,[perceptual_models{iCombPercResp(iModel,1)}, ...
        response_models{iCombPercResp(iModel,2)},'.mat']), 'est_bamp','-mat');
end
end

