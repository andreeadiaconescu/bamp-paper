function bamp_extract_calculate_MAPs(options,currentVAR)


if nargin < 2
    currentVAR = 'mu20';
end

allSubjects      =  [options.controls, ...
    options.psychopathy, options.antisocial];


% variables needed for plotting
nCon                   = length(options.controls);
nAnti                  = length(options.antisocial);
nPsych                 = length(options.psychopathy);

% Dependent Variables:
[zeta]                 = bamp_load_zeta(options,allSubjects);
[perceptualParameters] = bamp_load_parameters(options,allSubjects);

switch currentVAR
    case 'mu20'
        curr_var                = perceptualParameters(:,1);
        label                   = '\mu{_2}';
    case 'ka'
        curr_var                = perceptualParameters(:,2);
        label                   = '\kappa';
    case 'omega2'
        curr_var                = perceptualParameters(:,3);
        label                   = '\omega{_2}';
    case 'omega3'
        curr_var                = perceptualParameters(:,4);
        label                   = '\omega{_3}';
    case 'rho'
        curr_var                = perceptualParameters(:,5);
        label                   = 'rho';
    case 'zeta'
        curr_var                = zeta(:,1);
        label                   = '\zeta';
    case 'beta'
        curr_var                = zeta(:,2);
        label                   = '\beta';
end

Groups            = [ones(nCon,1); 2*ones(nPsych, 1); 3*ones(nAnti, 1)];

bamp_stats_groups(curr_var,currentVAR,Groups);

selectedVariablePhases     = {curr_var([1:nCon]), curr_var([1+nCon:nCon+nPsych]),curr_var([1+nCon+nPsych:end])};
Groups_Conditions          = {ones(nCon, 1), 2*ones(nPsych, 1), 3*ones(nAnti, 1)};

bamp_plot_scatter_MAPs(selectedVariablePhases,Groups_Conditions,currentVAR,label);
end














