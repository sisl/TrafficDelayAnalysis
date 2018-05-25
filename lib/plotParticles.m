% This function plots the particles in EDS in 2-lane case

function plotParticles(part,PlotMode)
alpha = 0.02;
switch PlotMode
    case 0
    case 1
        scatter(part(:,1),part(:,2),[],'k','filled','MarkerFaceAlpha',alpha);
        axis equal;
        axis([min(part(:,1)),8,min(part(:,2)),8])
    case 2
        histogram2(part(:,1),part(:,2),'BinWidth',0.1,'Normalization','probability');
    otherwise
        error('Unknown PlotMode');
end
xlabel('Delay in Lane 1.')
ylabel('Delay in Lane 2.')
box on
end