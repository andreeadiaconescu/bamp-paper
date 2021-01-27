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
    case 'm3'
        curr_var                = variables_all(:,3);
        label                   = 'm{_3}';
    case 'zeta'
        curr_var                = variables_all(:,4);
        label                   = '\zeta';
    case 'sigma'
        curr_var                = variables_all(:,6);
        label                   = '\sigma{_1}';
    case 'volatility'
        curr_var                = variables_all(:,7);
        label                   = '\mu{_3}';
end

Groups            = [ones(nCon,1); 2*ones(nPsych, 1); 3*ones(nAnti, 1)];

bamp_stats_groups(curr_var,currentVAR,Groups);

[p,tbl,stats] = anova1(curr_var([nCon+1:end]),Groups([nCon+1:end]));

postHoc_patients.p = p; 
postHoc_patients.F = tbl{2,5};
postHoc_patients.df = stats.df;
postHoc_patients.means = stats.means;
disp(postHoc_patients);

[p,tbl,stats] = anova1([curr_var([1:nCon]);curr_var([1+nCon+nPsych:end])],[Groups([1:nCon]);Groups([1+nCon+nPsych:end])]);
postHoc_controls.p = p; 
postHoc_controls.F = tbl{2,5};
postHoc_controls.df = stats.df;
postHoc_controls.means = stats.means;
disp(postHoc_controls);


selectedVariablePhases     = {curr_var([1:nCon]), curr_var([1+nCon:nCon+nPsych]),curr_var([1+nCon+nPsych:end])};
Groups_Conditions          = {ones(nCon, 1), 2*ones(nPsych, 1), 3*ones(nAnti, 1)};

bamp_plot_scatter_MAPs(selectedVariablePhases,Groups_Conditions,currentVAR,label);
end














