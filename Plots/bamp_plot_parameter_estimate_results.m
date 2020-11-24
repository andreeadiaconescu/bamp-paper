function bamp_plot_parameter_estimate_results(options)
% Runs and plots model selection results
% IN
%   options     general analysis options%
%               options = bamp_options;

% OUT
% Winning model MAPs & behavioural statistics


subjects = options.subjectIDs;


[parameters] = loadBAMPMAPs(options,subjects);
[behaviour_bamp] = loadBAMPBehaviourStats(options,subjects);

%% Take Advice
design_matrix = [parameters ones(size(parameters,1),1)];
[B,BINT,R,RINT,stats.regression_takeadvice] = regress(behaviour_bamp(:,1),design_matrix);
disp(['GLM with taking advice as the dependent variable:'...
    ' the R-square statistic, the F statistic and p value  ' ...
    num2str(stats.regression_takeadvice(1:3))]);

% Advice-taking and Zeta
[R,P]=corrcoef(parameters(:,6),behaviour_bamp(:,1));
disp(['Correlation between zeta1 and taking advice? Pvalue: ' num2str(P(1,2))]);
stats.correlation_advicexzeta = R(1,2);
stats.correlationp_advicexzeta = P(1,2);

% Advice-taking (helpful) and Zeta
[R,P]=corrcoef(parameters(:,6),behaviour_bamp(:,2));
disp(['Correlation between zeta1 and taking helpful advice? Pvalue: ' num2str(P(1,2))]);
stats.correlation_advicexzeta2 = R(1,2);
stats.correlationp_advicexzeta2 = P(1,2);

% Advice-taking (misleading) and Zeta
[R,P]=corrcoef(parameters(:,6),behaviour_bamp(:,3));
disp(['Correlation between zeta1 and going against advice? Pvalue: ' num2str(P(1,2))]);
stats.correlation_againstadvicexzeta = R(1,2);
stats.correlationp_againstadvicexzeta = P(1,2);

% Advice-taking and Omega2
[R,P]=corrcoef(parameters(:,4),behaviour_bamp(:,1));
disp(['Correlation between omega2 and taking advice? Pvalue: ' num2str(P(1,2))]);
stats.correlation_advicexomega2 = R(1,2);
stats.correlationp_advicexomega2 = P(1,2);

save(fullfile(options.resultroot, ['parameter_behaviour_stats.mat']), ...
    'stats', '-mat');
end


