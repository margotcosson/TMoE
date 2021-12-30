function show_NMoE_results(x, y, TMoE, klas, TrueStats)

set(0,'defaultaxesfontsize',12);
colors = {'k','r','b','g','m','c','y',   'k','r','b','g','m','c','y',    'k','r','b','g','m','c','y'};
style =  {'k.','r.','b.','g.','m.','c.','y.','k.','r.','b.','g.','m.','c.','y.','k.','r.','b.','g.','m.','c.','y.'};

yaxislim = [min(y)-std(y), max(y)+std(y)];

param = TMoE.param;
% stats = TMoE.stats;
Ey_k = TMoE.Ey_k;
Ey = TMoE.Ey;
Vy = TMoE.Vary;
Piik = TMoE.Piik;
klas = TMoE.klas;
stored_loglik =TMoE.stored_loglik;

K = length(param.Betak);

if nargin>3
    figure,
    h1 = plot(x,y,'o','color',[0.6 0.6 .6]);
    hold all
    h2 = plot(x,TrueStats.Ey_k,'k--');
    h3 = plot(x,Ey_k,'r--');
    
    h4 = plot(x,TrueStats.Ey,'k','linewidth',2);
    h5 = plot(x,Ey,'r','linewidth',2);
    xlabel('x'), ylabel('y');
    ylim(yaxislim)
    hold off
    legend([h1, h4, h3(1), h5, h2(1)], 'data',['True mean',' (NMoE)'],'True Experts', ...
        ['Estimated mean',' (TMoE)'],'Estimated Experts',...
        'Location','SouthWest');
    legend('boxoff')
    figure,
    for k=1:K
        plot(x,Piik(:,k),[colors{k},'-'],'linewidth',2);
        hold on;
    end
    hold off
    ylim([0, 1]);
    xlabel('x'), ylabel('Gating network probabilities');
    
    
    %% data, True and Estimated mean functions and pointwise 2*sigma confidence regions
    figure,
    h1 = plot(x,y,'o','color',[0.6 0.6 .6]);
    hold all
    % true
    h2 = plot(x,TrueStats.Ey,'k','linewidth',1.5);
    h3 = plot(x,[TrueStats.Ey-2*sqrt(TrueStats.Vy), TrueStats.Ey+2*sqrt(TrueStats.Vy)],'k--','linewidth',1);
    % estimated
    h4 = plot(x,Ey,'r','linewidth',2);
    h5 = plot(x,[Ey-2*sqrt(Vy), Ey+2*sqrt(Vy)],'r--','linewidth',1);
    legend([h1, h2, h3(1), h4, h5(1)],'data', ['True mean',' (NMoE)'], ....
        'True conf. regions',['Estimated mean',' (NMoE)'], 'Estimated conf. regions',...
        'Location','SouthWest');
    legend('boxoff');
    xlabel('x'), ylabel('y');
    ylim(yaxislim)
    hold off
    
    %% obtained partition
    figure,
    hold all
    % true partiton
    for k=1:max(klas)
        plot(x,TrueStats.Ey_k(:,k),colors{k},'linewidth',1.2);
        plot(x(klas==k),y(klas==k),[colors{k},'o']);
    end
    legend('True expert means','True clusters');
    
    ylim(yaxislim)
    box on
    xlabel('x'), ylabel('y');
    
    legend('boxoff')
    hold off
    
    figure
    hold all
    % estimated partition
    for k=1:K
        plot(x,Ey_k(:,k),colors{k},'linewidth',1.2);
        plot(x(klas==k),y(klas==k),[colors{k},'o']);
    end
    legend('Estimated expert means','Estimated clusters');    ylim(yaxislim)
    box on
    xlabel('x'), ylabel('y');
    
    legend('boxoff')
    hold off
    %% observed data log-likelihood
    figure, plot(stored_loglik,'-');
    xlabel('EM iteration number');
    ylabel('Observed data log-likelihood');
    legend('TMoE log-likelihood');
    legend('boxoff')
    box on;
else %eg. for real data with unknown classes etc
    
    [x, indx] = sort(x);
    y = y(indx);
    Ey_k = Ey_k(indx,:);
    Piik = Piik(indx,:);
    Ey = Ey(indx);
    Vy = Vy(indx);
    klas = klas(indx);
    
    figure,
    h1 = plot(x,y,'o','color',[0.6 0.6 .6]);
    hold all
    h2 =  plot(x,Ey_k,'r--');
    h3 =  plot(x,Ey,'r','linewidth',2);
    xlabel('x'), ylabel('y');
    ylim(yaxislim)
    hold off
    legend([h1, h2(1), h3], 'data','TMoE mean function','Estimated Experts',...
        'Location','SouthWest');
    legend('boxoff')
    
    figure,
    for k=1:K
        plot(x,Piik(:,k),[colors{k},'-'],'linewidth',2);
        hold on;
    end
    hold off
    ylim([0, 1]);
    xlabel('x'), ylabel('Gating network probabilities');
    
    
    %% data and Estimated mean functions and pointwise 2*sigma confidence regions
    figure,
    h1 = plot(x,y,'o','color',[0.6 0.6 .6]);
    hold all
    % estimated
    h2 = plot(x,Ey,'r','linewidth',2);
    h3 = plot(x,[Ey-2*sqrt(Vy), Ey+2*sqrt(Vy)],'r--','linewidth',1);
    legend([h1, h2(1), h3(1)],'data', 'Estimated mean (NMoE)', 'Estimated conf. regions',...
        'Location','SouthWest');
    legend('boxoff');
    xlabel('x'), ylabel('y');
    ylim(yaxislim)
    hold off
    
    %% obtained partition
    figure
    hold all
    for k=1:K
        %         h1= plot(x,stats.Ey_k(:,k),color{k},'linewidth',1.2);
        %         h2= plot(x(stats.klas==k),y(stats.klas==k),[color{k},'o']);
        %         hold on
        %     end
        
        %%
        expertMean_k = Ey_k(:,k);
        %prob_model_k = solution.param.piik(:,k);
        active_model_k = expertMean_k(klas==k);
        active_period_model_k = x(klas==k);
        
        inactive_model_k = expertMean_k(klas ~= k);
        inactive_period_model_k = x(klas ~= k);
        if (~isempty(active_model_k))
            plot(active_period_model_k,y(klas==k),[colors{k},'o']);%, 'markersize', 0.2);
            hold on,
            plot(inactive_period_model_k,inactive_model_k,style{k},'markersize',0.01);
            hold on,
            plot(active_period_model_k, active_model_k,'Color', colors{k},'linewidth',2.5);
            hold on
        end
    end
    %%
    legend('Estimated clusters','NMoE expert means (non-active)','NMoE expert means (active)');
    ylim(yaxislim)
    box on
    xlabel('x'), ylabel('y');
    
    legend('boxoff')
    hold off
    %% observed data log-likelihood
    figure, plot(stored_loglik,'-');
    xlabel('EM iteration number');
    ylabel('Observed data log-likelihood');
    legend('NMoE log-likelihood');
    legend('boxoff')
    box on;
end
end