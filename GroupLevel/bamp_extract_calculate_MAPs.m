function bamp_extract_calculate_MAPs(options,currentVAR)


if nargin < 2
    currentVAR = 'omega3';
end


% variables needed for plotting
nCon                   = length(options.controls);
nAnti                  = length(options.antisocial);
nPsych                 = length(options.psychopathy);

% Dependent Variables:
[variables_all] = bamp_extract_parameters_HGF_RT_create_table(options);

switch currentVAR
    case 'omega2'
        curr_var                = variables_all(:,1);
        label                   = '\omega{_2}';
    case 'omega3'
        curr_var                = variables_all(:,2);
        label                   = '\omega{_3}';
    case 'zeta'
        curr_var                = variables_all(:,3);
        label                   = '\zeta';
    case 'sigma'
        curr_var                = variables_all(:,5);
        label                   = '\sigma{_1}';
    case 'volatility'
        curr_var                = variables_all(:,6);
        label                   = '\mu{_3}';
end

Groups            = [ones(nCon,1); 2*ones(nPsych, 1); 3*ones(nAnti, 1)];

bamp_stats_groups(curr_var,currentVAR,Groups);

selectedVariablePhases     = {curr_var([1:nCon]), curr_var([1+nCon:nCon+nPsych]),curr_var([1+nCon+nPsych:end])};
Groups_Conditions          = {ones(nCon, 1), 2*ones(nPsych, 1), 3*ones(nAnti, 1)};

bamp_plot_scatter_MAPs(selectedVariablePhases,Groups_Conditions,currentVAR,label);
end














