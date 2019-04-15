function bamp_invert_subject(id, options)
% IN
%   id          subject id string, only number (e.g. '0002')
%   options     general analysis options%
%               options = bamp_ioio_options
% NB: Behaviour data is also saved with the inversion

details = bamp_ioio_subjects(id, options);
fileBehav = details.behav.fileRawBehav;

perceptualModels = {'tapas_hgf_binary','tapas_hgf_binary_reduced_omega','tapas_hgf_binary_reduced_kappa',...
                    'tapas_hgf_ar1_binary','tapas_rw_binary'};
responseModels   = options.model.allresponseModels';

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

for iModel = 1:nModels
    [cue, cue_advice_space,y_responses,input_u,takeAdv,take_helpfulAdvice, ...
        perf_acc,against_misleadingAdvice,percentage_against_advice_hiprob,...
        percentage_with_advice_lowprob] = getBAMPData(details,options,fileBehav);
    if isempty(input_u) % cue and cue advice are not subject-dependent, have to check inputs
        error('Behavioral data for subject %s not found', sub);
    end
    
    % Report findings in Matlab window
    fprintf('Percentage of times subject took advice: %d\n', takeAdv);
    
    est_bamp=tapas_fitModel(y_responses,input_u,[perceptualModels{iCombPercResp(iModel,1)},'_config'],...
        responseModels{iCombPercResp(iModel,2)});
    
    est_bamp.take_adv_helpful                      = take_helpfulAdvice;
    est_bamp.go_against_adv_misleading             = against_misleadingAdvice;
    est_bamp.perf_acc                              = perf_acc;
    est_bamp.choice_against                        = percentage_against_advice_hiprob;
    est_bamp.choice_with                           = percentage_with_advice_lowprob;
    est_bamp.cue                                   = cue;
    est_bamp.cue_advice_space                      = cue_advice_space;
    est_bamp.take_adv_overall                      = takeAdv;
    
    save(fullfile(details.behav.pathResults,[perceptualModels{iCombPercResp(iModel,1)}, ...
        responseModels{iCombPercResp(iModel,2)},'.mat']), 'est_bamp','-mat');
end
end

