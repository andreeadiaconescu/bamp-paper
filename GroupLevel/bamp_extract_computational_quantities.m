function [bamp_computational_quantities,quantities_phases] = bamp_extract_computational_quantities(est,options)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prediction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1st level predictions, precisions
mu3hat               = est.traj.muhat([1:189],3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Uncertainty
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sa1hat     = est.traj.sahat([1:189],1);
pi2hat     = 1./est.traj.sahat([1:189],2);
pi3hat     = 1./est.traj.sahat([1:189],3);

sa1hatPhase = [mean(sa1hat(logical(options.task.helpfulPhase1))) mean(sa1hat(logical(options.task.volatilePhase))),...
    mean(sa1hat(logical(options.task.helpfulPhase2)))];
mu3hatPhase = [mean(mu3hat(logical(options.task.helpfulPhase1))) mean(mu3hat(logical(options.task.volatilePhase))),...
    mean(mu3hat(logical(options.task.helpfulPhase2)))];
sa2hatPhase = [mean(pi2hat(logical(options.task.helpfulPhase1))) mean(pi2hat(logical(options.task.volatilePhase))),...
    mean(pi2hat(logical(options.task.helpfulPhase2)))];
sa3hatPhase = [mean(pi3hat(logical(options.task.helpfulPhase1))) mean(pi3hat(logical(options.task.volatilePhase))),...
    mean(pi3hat(logical(options.task.helpfulPhase2)))];

bamp_computational_quantities = [sa1hat, mu3hat pi2hat pi3hat];
quantities_phases             = [sa1hatPhase mu3hatPhase sa2hatPhase sa3hatPhase];

end