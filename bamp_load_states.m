function [states] = bamp_load_states(options,subjectArray)

if nargin < 2
    subjectArray =  [options.controls, ... 
        options.psychopathy, options.antisocial];
end

helpfulPhases                  = options.task.helpfulPhase1 + options.task.helpfulPhase2;
StableTrials                   = logical(helpfulPhases);
VolatileTrials                 = logical(options.task.volatilePhase);

subjectsAll = subjectArray;
for  iSubject = 1:length(subjectsAll)   
    id = char(subjectsAll(iSubject));
    details = bamp_ioio_subjects(id, options);
    tmp = load(fullfile(details.behav.pathResults,[options.model.winningPerceptual, ...
        options.model.winningResponse,'.mat']), 'est_bamp','-mat');
    
    
    pihat2 = 1./tmp.est_bamp.traj.sahat(:,2);
    pi3    = 1./tmp.est_bamp.traj.sa(:,3);
    psi3   = pihat2./pi3;
    
    variables_bamp{iSubject,1} = nanmean(psi3.*StableTrials);
    variables_bamp{iSubject,2} = nanmean(psi3.*VolatileTrials);
    variables_bamp{iSubject,3} = nanmean(abs(tmp.est_bamp.traj.epsi(:,3)).*StableTrials);
    variables_bamp{iSubject,4} = nanmean(abs(tmp.est_bamp.traj.epsi(:,3)).*VolatileTrials);
    variables_bamp{iSubject,5} = nanmean(tmp.est_bamp.traj.sahat(:,3).*StableTrials);
    variables_bamp{iSubject,6} = nanmean(tmp.est_bamp.traj.sahat(:,3).*VolatileTrials);
    variables_bamp{iSubject,7} = nanmean(tmp.est_bamp.traj.muhat(:,3).*StableTrials);
    variables_bamp{iSubject,8} = nanmean(tmp.est_bamp.traj.muhat(:,3).*VolatileTrials);
end
states = cell2mat(variables_bamp);

%% Save as table
ofile=fullfile(options.resultroot,'bamp_behaviourVariables.xlsx');

columnNames = [{'subjectIds'}, ...
    {'Sa1hatStable','Sa1HatVolatile','Sa2hatStable','Sa2HatVolatile','Sa3hatStable','Sa3HatVolatile',...
    'Mu3hatStable','Mu3HatVolatile'}];
t = array2table([subjectsAll' num2cell([states])], ...
    'VariableNames', columnNames);
writetable(t, ofile);

end