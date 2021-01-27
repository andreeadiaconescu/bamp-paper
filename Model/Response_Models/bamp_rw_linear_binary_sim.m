function [y_ch,y_rt,prob_choice] = bamp_rw_linear_binary_sim(r, infStates, p)
% Simulates logRTs with Gaussian noise
% as well as choices under the IOIO task model
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2016 Christoph Mathys, TNU, UZH & ETHZ
% % modified by Andreea Diaconescu, 2018 TNU, UZH & ETHZ
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Get parameters
ze1 = p(1);
ze2 = p(2);
be0  = p(3);
be1  = p(4);
ze3   = p(5);

% Number of trials
n = size(infStates,1);

% Inputs
u = r.u(:,1);
c = r.u(:,2);

% Extract trajectories of interest from infStates
mu1hat = infStates(:,1,1);
sa1hat = mu1hat.*(1-mu1hat);

% Belief vector
% ~~~~~~~~
b = ze1.*mu1hat + (1-ze1).*c;

% additional decision noise injected?
if length(p)<9
    eta = 0;
else
    eta = p(9);
end

% Decision Temperature
beta = exp(log(ze2) - eta);

% Apply the unit-square sigmoid to the inferred states
prob_choice = b.^(beta)./(b.^(beta)+...
    (1-b).^(beta));

% Bernoulli variance (aka irreducible uncertainty, risk) 
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bernv = sa1hat;

% Calculate predicted log-reaction time
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
logrt = be0+be1.*bernv;

% Initialize random number generator
% rng('shuffle');

% Simulate
y_ch = binornd(1, prob_choice);

% Simulate
y_rt = logrt+sqrt(ze3)*randn(n, 1);

end
