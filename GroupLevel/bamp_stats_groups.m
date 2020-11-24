function bamp_stats_groups(current_var,varName,Groups)

[p, tbl, stats, terms] = anovan(current_var,Groups,...
    'model','interaction','varnames',{'Group'},'display','off');

ANOVA_CurrentVar = tbl;


ANOVATbl =    cell2table(ANOVA_CurrentVar(2:end,:),...
                        'VariableNames',{varName,'SumSq1',...
                        'df','Singular1','MeanSq1','F1','PValue1'});
disp(ANOVATbl);

end