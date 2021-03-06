    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % >>t mixture of experts (TMoE): Robust mixtures-of-experts modeling using the t distribution <<
    %  
    % TMoE : A Matlab/Octave toolbox for modeling, sampling, inference, regression and clustering of
    % heterogeneous data with the t Mixture-of-Experts (TMoE) model.
    %  
    % TMoE provides a flexible and robust modeling framework for heterogenous data with possibly
    % heavy-tailed distributions and corrupted by atypical observations. TMoE consists of a mixture of K
    % t expert regressors network (of degree p) gated by a softmax gating network (with regression
    % degree q) and is represented by 
    % - The gating net. parameters $\alpha$'s of the softmax net. 
    % - The experts network parameters: The location parameters (regression coefficients) $\beta$'s, scale
    % parameters $\sigma$'s, and the degree of freedom (robustness) parameters $\nu$'s. 
    % TMoE thus generalises  mixtures of (normal, t, and) distributions and mixtures of regressions with these
    % distributions. For example, when $q=0$, we retrieve mixtures of (t-, or normal) regressions, and
    % when both $p=0$ and $q=0$, it is a mixture of (t-, or normal) distributions. It also reduces to
    % the standard (normal, t) distribution when we only use a single expert (K=1).
    %  
    % Model estimation/learning is performed by a dedicated expectation conditional maximization (ECM)
    % algorithm by maximizing the observed data log-likelihood. We provide simulated examples to
    % illustrate the use of the model in model-based clustering of heterogeneous regression data and in
    % fitting non-linear regression functions. Real-world data examples of tone perception for musical
    % data analysis, and the one of temperature anomalies for the analysis of climate change data, are
    % also provided as application of the model.
    %  
    % To run it on the provided examples, please run "main_demo_TMoE_SimulatedData.m" or
    % "main_demo_TMoE_RealData.m"
    % 
    %% Please cite the code and the following papers when using this code:
    % - F. Chamroukhi. Robust mixture of experts modeling using the $t$-distribution. Neural Networks, V. 79, p:20?36, 2016
    % - F. Chamroukhi. Non-Normal Mixtures of Experts. arXiv:1506.06707, July, 2015
    %
    % (c) Introduced and written by Faicel Chamroukhi (may 2015)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
clc;
samples = {50, 100, 200, 500, 1000, 1500, 2000};
list_NMoE = {};
list_TMoE_EM = {};
list_TMoE_ECM = {};

for k=1:length(samples)
    disp(samples{k}); 
    %%  sample drawn from the model:
    n=samples{k};
    % some specified parameters for the model
    Alphak = [0, 8]';
    Betak = [0 0;
        -2.5 2.5];
    Sigmak = [.5, .5];%the standard deviations
    Lambdak = [3, 5];
    % Nuk = [5, 7];
    Nuk = [inf, inf];
    
    % sample the data
    x = linspace(-1, 1, n);
    [y, klas, stats, Z] = sample_univ_TMoE(Alphak, Betak, Sigmak, Nuk, x);
    
    %% add (or no) outliers
    WithOutliers = 1; % to generate a sample with outliers
    hide_data = 0;
    x_out_low = 0;
    x_out_up = 0;
    y_out_low = 0;
    y_out_up = 0;
    
    % if outliers
    if WithOutliers
        disp('- THERE ARE OUTLIERS --')
        rate = 0.0;%amount of outliers in the data
        upperrate = rate / 2;
        lowerrate = rate / 2;
        Noupper = round(length(y)*upperrate);
        upperoutilers = -1.5 + 2*rand(Noupper,1);
        uptmp = randperm(length(y));
        Indoutupper = uptmp(1:Noupper);
        y(Indoutupper) = -5 ; %outilers;
        % y(Indoutupper) = normrnd(3, 2, [1, Noupper]);
        % y(Indoutupper) =-5 + 10 *rand(Noupper,1);
        Nolower = round(length(y)*lowerrate);
        outilers = -1.5 + 2*rand(Nolower,1);
        disp('     Outliers');
        disp(Nolower);
        disp(Indoutupper);
        %disp(rand(Nolower,1));
        lowtmp = randperm(length(y));
        Indoutlower = lowtmp(1:Nolower);
        y(Indoutlower) = -5 ; %outilers;
        %y(Indoutlower) = -5 + 10 *rand(Nolower,1);
        % y(Indoutlower) = normrnd(-2, 2, [1, Nolower]);
        x_out_low = Indoutlower;
        x_out_up = Indoutupper;
        y_out_low =  y(Indoutlower);
        y_out_up =  y(Indoutupper);
    %end
    
    elseif hide_data
        rate = 0;
        old_x = x;
        old_y = y;
        missing_interval = -1 + rand(2, 1)*2;
        missing_interval = sort(missing_interval);
        while  missing_interval(2) - missing_interval(1)>0.8 | 0.3>missing_interval(2) - missing_interval(1)
            missing_interval = -1 + rand(2, 1)*2;
            missing_interval = sort(missing_interval);
        end
        disp('-- Missing interval--');
        disp(missing_interval);
         y = y(find(x>missing_interval(2) | missing_interval(1)>x));
        x = x(x>missing_interval(2) | missing_interval(1)>x);
        %disp(find(x>missing_interval(2) | missing_interval(1)>x));
    end
    
    
    %% model learning
    % model structure setting
    K = 2; % number of experts
    p = 1; % degree the polynomial regressors (Experts Net)
    q = 1; % degree of the logstic regression (gating Net)
    
    % EM options setting
    nb_EM_runs = 20;
    max_iter_EM = 1500;
    threshold = 1e-6;
    verbose_EM = 0; % instead of 1
    verbose_NR = 0;
    verbose_single_fig = 1;
    
    %% learn the model from the sampled data
    TMoE_ECM =  learn_TMoE_EM(y, x, K, p, q, nb_EM_runs, max_iter_EM, threshold, verbose_EM, verbose_NR, 1);
    disp('- TMoE with ECM fit completed --')
    disp(' ')
    TMoE_EM =  learn_TMoE_EM(y, x, K, p, q, nb_EM_runs, max_iter_EM, threshold, verbose_EM, verbose_NR, 0);
    disp('- TMoE with EM fit completed --')
    disp(' ')
    NMoE =  learn_univ_NMoE_EM(y, x, K, p, q, nb_EM_runs, max_iter_EM, threshold, verbose_EM, verbose_NR);
    
    disp('- fit completed --')
    
    newSubFolder = fullfile('results', strcat(sprintf('%.0f', rate*100), '_simulated_outliers'))
    if ~exist(newSubFolder, 'dir')
      mkdir(newSubFolder);
    end
    %% plot of the results
    %show_computation_time(TMoE_ECM, TMoE_EM, NMoE)
    
    %show_TMoE_results(x, y, TMoE_ECM, klas, stats)
    %show_TMoE_results(x, y, TMoE_EM, klas, stats)
    %show_NMoE_results(x, y, NMoE, klas, stats)
    %show_TMoE_results_simulated(x, y, TMoE_ECM, klas, stats, newSubFolder, x_out_low, x_out_up, y_out_low, y_out_up, verbose_single_fig)
    %show_NMoE_results_simulated(x, y, NMoE, klas, stats, newSubFolder, x_out_low, x_out_up, y_out_low, y_out_up, verbose_single_fig)
    
    % Note that as it uses the t distribution, so the mean and the variance might be not defined (if Nu <1 and or <2), and hence the
    % mean functions and confidence regions might be not displayed..

    list_NMoE = [list_NMoE, NMoE.cputime];
    list_TMoE_EM = [list_TMoE_EM, TMoE_EM.stats.cputime];
    list_TMoE_ECM =  [list_TMoE_ECM, TMoE_ECM.stats.cputime];
end

show_computation_times_over_samples(samples, list_NMoE, list_TMoE_EM, list_TMoE_ECM)
