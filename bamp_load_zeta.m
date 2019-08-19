function [zeta] = bamp_load_zeta(options,subjectsAll)

if nargin < 2
    subjectsAll = [options.controls, ...
    options.psychopathy, options.antisocial];
end
bamp_zeta      = cell(numel(subjectsAll), 1);
for  iSubject = 1:length(subjectsAll)
    id = char(subjectsAll(iSubject));
    details = bamp_ioio_subjects(id, options);
    tmp = load(fullfile(details.behav.pathResults,[options.model.winningPerceptual, ...
                options.model.winningResponse,'.mat']), 'est_bamp','-mat');
    
    bamp_zeta{iSubject,1} = tmp.est_bamp.p_obs.ze1;
    bamp_zeta{iSubject,2} = tmp.est_bamp.p_obs.ze2;
end
zeta = cell2mat(bamp_zeta);

end