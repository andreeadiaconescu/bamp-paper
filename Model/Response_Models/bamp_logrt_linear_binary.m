function [logp, yhat, res] = bamp_logrt_linear_binary(r, infStates, ptrans)
% Calculates the log-probability of log-reaction times y (in units of log-ms) according to the
% linear log-RT model developed with Louise Marshall and Sven Bestmann
% adapted here for the IOIO task
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2014-2016 Christoph Mathys, UZH & ETHZ
% modified Andreea Diaconescu 19/11/2018, TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Transform parameters to their native space
ze1 = tapas_sgm(ptrans(1),1);
ze2 = exp(ptrans(2));
be0  = ptrans(3);
be1  = ptrans(4);
be2  = ptrans(5);
be3  = ptrans(6);
ze3   = exp(ptrans(7));

% Initialize returned log-probabilities, predictions,
% and residuals as NaNs so that NaN is returned for all
% irregualar trials
n = size(infStates,1);
logp_rt = NaN(n,1);
logp_ch = NaN(n,1);
logp    = NaN(n,1);

% Weed irregular trials out from responses and inputs
y_rt = log(r.y(:,2));
y_rt(r.irr) = [];

y_ch = r.y(:,1);
y_ch(r.irr) = [];

% Extract trajectories of interest from infStates
mu1hat = infStates(:,1,1);
sa1hat = infStates(:,1,2);
mu3hat = infStates(:,3,1);
mu2hat = infStates(:,2,1);
sa2hat = infStates(:,2,2);
c      = r.u(:,2);

% Decision Temperature
% ~~~~~~~~
decision_noise = exp(-mu3hat) + exp(log(ze2));
% decision_noise   = ze2;
decision_noise(r.irr) = [];

% Integrated Belief
% ~~~~~~~~
x = ze1.*mu1hat + (1-ze1).*c;
x(r.irr) = [];

% Avoid any numerical problems when taking logarithms close to 1
logx = log(x);
log1pxm1 = log1p(x-1);
logx(1-x<1e-4) = log1pxm1(1-x<1e-4);
log1mx = log(1-x);
log1pmx = log1p(-x);
log1mx(x<1e-4) = log1pmx(x<1e-4); 

% Calculate log-probabilities for non-irregular trials
reg = ~ismember(1:n,r.irr);
logp_ch(reg) = y_ch.*decision_noise.*(logx -log1mx) +decision_noise.*log1mx -log((1-x).^decision_noise +x.^decision_noise);
res(reg) = (y_ch-x)./sqrt(x.*(1-x));

% Bernoulli variance (aka irreducible uncertainty, risk) 
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bernv = sa1hat;
bernv(r.irr) = [];

% Inferential variance (aka informational or estimation uncertainty, ambiguity)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
inferv = tapas_sgm(mu2hat, 1).*(1 -tapas_sgm(mu2hat, 1)).*sa2hat; % transform down to 1st level
inferv(r.irr) = [];

% Phasic volatility (aka environmental or unexpected uncertainty)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
pv = tapas_sgm(mu2hat, 1).*(1-tapas_sgm(mu2hat, 1)).*exp(mu3hat); % transform down to 1st level
pv(r.irr) = [];

% Calculate predicted log-reaction time
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
logrt = be0 + be1.*bernv +be2.*inferv +be3.*pv;

% Calculate log-probabilities for non-irregular trials
% Note: 8*atan(1) == 2*pi (this is used to guard against
% errors resulting from having used pi as a variable).
reg = ~ismember(1:n,r.irr);
logp_rt(reg)      = -1/2.*log(8*atan(1).*ze3) -(y_rt-logrt).^2./(2.*ze3);
logp(reg)         = logp_ch(reg) + logp_rt(reg); 
yhat(reg) = logrt;
res(reg) = y_rt-logrt;
return;
