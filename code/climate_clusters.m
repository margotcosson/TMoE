clear all;
close all;
clc;


set(0,'defaultaxesfontsize',14);
data_set = 'MonthlyTemperatureAnomaly'; K = 2; p = 1; q = 1;

%% EM options
nbr_EM_tries = 10;
max_iter_EM = 1500;
threshold = 1e-6;
verbose_EM = 0;
verbose_IRLS = 0;
modif_xaxis = 1;

data = csvread('data/MonthlyTemperatureAnomaly.csv');
x = data(:, 1);
y = data(:, 2);


%% learn the model from the  data

for K=1:6
   %TMoE =  learn_TMoE_EM(y, x, K, p, q, nbr_EM_tries, max_iter_EM, threshold, verbose_EM, verbose_IRLS, 1);
    NMoE =  learn_univ_NMoE_EM(y, x, K, p, q, nbr_EM_tries, max_iter_EM, threshold, verbose_EM, verbose_IRLS);
    %disp("ICL TMoE for " + K + " clusters = " + TMoE.stats.ICL)
    %disp("AIC TMoE for " + K + " clusters = " + TMoE.stats.AIC)
    %disp("BIC TMoE for " + K + " clusters = " + TMoE.stats.BIC)
    %disp("ICL NMoE for " + K + " clusters = " + NMoE.ICL)
    %disp("AIC NMoE for " + K + " clusters = " + NMoE.AIC)
    disp("BIC NMoE for " + K + " clusters = " + NMoE.BIC)
end


