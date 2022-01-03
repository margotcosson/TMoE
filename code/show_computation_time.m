function show_computation_time(TMoE_ECM, TMoE_EM, NMoE)

set(0,'defaultaxesfontsize',12);
colors = {'k','r','b','g','m','c','y',   'k','r','b','g','m','c','y',    'k','r','b','g','m','c','y'};
style =  {'k.','r.','b.','g.','m.','c.','y.','k.','r.','b.','g.','m.','c.','y.','k.','r.','b.','g.','m.','c.','y.'};

stats_TMoE_ECM = TMoE_ECM.stats;
stats_TMoE_EM = TMoE_EM.stats;


stored_time_NMoE = NMoE.stored_cputime;
stored_time_TMoE_ECM = stats_TMoE_ECM.stored_cputime;
stored_time_TMoE_EM = stats_TMoE_EM.stored_cputime;

figure, 
hold all;
h1= plot(stored_time_NMoE,'-', 'color',[0.8 0.3 .1],'linewidth',1.5);
h2 = plot(stored_time_TMoE_EM,'-', 'color',[0.3 0.1 .8],'linewidth',1.5);
h3 = plot(stored_time_TMoE_ECM,'-', 'color',[0.1 0.8 .3],'linewidth',1.5);
xlabel('EM Runs');
ylabel('CPU computation time (in seconds)');
title('Computation time')
%legend('boxoff')
box on;

legend([h1, h2, h3], 'NMoE', 'TMoE with EM','TMoE with ECM')
%legend('boxoff')
savefig('results/no_outliers_computation_time.fig')
f = open("results\no_outliers_computation_time.fig");
saveas(f, "results\no_outliers_computation_time.png");
hold off;