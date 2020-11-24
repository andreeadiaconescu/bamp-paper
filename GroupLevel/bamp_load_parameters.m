function [perceptualParameters] = bamp_load_parameters(options,subjectsAll)

if nargin < 2
    subjectsAll = [options.controls, ...
    options.psychopathy, options.antisocial];
end

bamp_par      = cell(numel(subjectsAll), 4);
for  iSubject = 1:length(subjectsAll)
    id = char(subjectsAll(iSubject));
    details = bamp_ioio_subjects(id, options);
    
    tmp = load(fullfile(details.behav.pathResults,[options.model.winningPerceptual, ...
                options.model.winningResponse,'.mat']), 'est_bamp','-mat');
    
    bamp_par{iSubject,1} = tapas_sgm(tmp.est_bamp.p_prc.mu_0(2),1);
    bamp_par{iSubject,2} = tmp.est_bamp.p_prc.ka(2);
    bamp_par{iSubject,3} = tmp.est_bamp.p_prc.om(2);
    bamp_par{iSubject,4} = tmp.est_bamp.p_prc.om(3);
    bamp_par{iSubject,5} = tmp.est_bamp.p_prc.rho(2);
end
perceptualParameters = cell2mat(bamp_par);



end