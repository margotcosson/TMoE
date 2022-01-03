function show_computation_times_over_samples(samples, list_NMoE, list_TMoE_EM, list_TMoE_ECM)

disp('- SAMPLES -')
disp(samples)
disp('- NMoE -')
disp(list_NMoE)
disp('- TMoE EM -')
disp(list_TMoE_EM)
disp('- TMoE ECM -')
disp(list_TMoE_ECM)
set(0,'defaultaxesfontsize',12);
colors = {'k','r','b','g','m','c','y',   'k','r','b','g','m','c','y',    'k','r','b','g','m','c','y'};
style =  {'k.','r.','b.','g.','m.','c.','y.','k.','r.','b.','g.','m.','c.','y.','k.','r.','b.','g.','m.','c.','y.'};

figure, 
hold all;
h1= plot(horzcat(samples{:}), horzcat(list_NMoE{:}),'-', 'color',[0.8 0.3 .1],'linewidth',1.5);
h2 = plot(horzcat(samples{:}), horzcat(list_TMoE_EM{:}),'-', 'color',[0.3 0.1 .8],'linewidth',1.5);
h3 = plot(horzcat(samples{:}), horzcat(list_TMoE_ECM{:}),'-', 'color',[0.1 0.8 .3],'linewidth',1.5);
xlabel('number of samples');
ylabel('mean CPU computation time (in seconds)');
title('Computation time depending on the amount of data')
%legend('boxoff')
box on;

legend([h1, h2, h3], 'NMoE', 'TMoE with EM','TMoE with ECM')
%legend('boxoff')
savefig('results/no_outliers_computation_time_over_samples.fig')
f = open("results\no_outliers_computation_time_over_samples.fig");
saveas(f, "results\no_outliers_computation_time_over_samples.png");
hold off;