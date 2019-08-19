function bamp_extract_calculate_MAPs_RT(options,currentVAR)


if nargin < 2
    currentVAR = 'be3';
end

allSubjects      =  [options.controls,options.psychopathy,options.antisocial];


% variables needed for plotting
nCon                   = length(options.controls);
nAnti                  = length(options.antisocial);
nPsych                 = length(options.psychopathy);

% Dependent Variables:
[variables_all] = bamp_extract_parameters_HGF_RT_create_table(options,'all');
parameters      = variables_all;

switch currentVAR
    case 'be1'
        curr_var                = parameters(:,7);
        label                   = '\beta{_1}';
    case 'be2'
        curr_var                = parameters(:,8);
        label                   = '\beta{_2}';
    case 'be3'
        curr_var                = parameters(:,9);
        label                   = '\beta{_3}';
    case 'be4'
        curr_var                = parameters(:,10);
        label                   = '\beta{_4}';
    case 'zeta'
        curr_var                = parameters(:,5);
        label                   = '\zeta';
    case 'beta'
        curr_var                = parameters(:,6);
        label                   = '\zeta';
    case 'zeta3'
        curr_var                = parameters(:,11);
        label                   = '\zeta3';
end

Groups            = [ones(nCon,1); 2*ones(nPsych, 1); 3*ones(nAnti, 1); ];

bamp_stats_groups(curr_var,currentVAR,Groups);

selectedVariablePhases     = {curr_var([1:nCon]), curr_var([1+nCon:nCon+nPsych]),curr_var([1+nCon+nPsych:end])};
Groups_Conditions          = {ones(nCon, 1), 2*ones(nPsych, 1), 3*ones(nAnti, 1)};

bamp_plot_scatter_MAPs(selectedVariablePhases,Groups_Conditions,currentVAR,label);
end














