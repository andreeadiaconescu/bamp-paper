function bamp_plot_scatter_HGFStates(Variables,Groups_Conditions,currentState,label)

GroupingVariables = {'Stable','Volatile',...
                     'Stable','Volatile',...
                     'Stable','Volatile'};

figure;

H   = Variables;
N   = numel(Variables);

switch currentState
    case 'mu3'
        colors=winter(numel(H));
    case 'pi2'
        colors=bone(numel(H));
    otherwise
        colors=cool(numel(H));
end
for i=1:N
    e = notBoxPlot(cell2mat(H(i)),cell2mat(Groups_Conditions(i)),'markMedian',true);
    set(e.data,'MarkerSize', 10);
    set(e.data,'Marker','o');
    if i==1, hold on, end
    set(e.data,'Color',colors(i,:));
    set(e.sdPtch,'FaceColor',colors(i,:));
    set(e.semPtch,'FaceColor',[0.9 0.9 0.9]);
end
set(gca,'XTick',1:N)
set(gca,'XTickLabel',GroupingVariables);
set(gca,'FontName','Calibri','FontSize',40);
ylabel(label);



end


