function bamp_stats_groups(current_var,Groups)

p = anovan(current_var,Groups,...
    'model','interaction','varnames',{'Group'});

end