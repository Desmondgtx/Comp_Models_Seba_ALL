function [output] = visualize_model_PM(allmodels, modelID,doanalyse )
% Analyses visualise results
% trials
% INPUT:    - allmodels: struct with all model parameters in it
%           - modelID: string if you want to pick one specific model
%           - doanalyse: vector indicating which analyses to run
% OPTIONS:  - doanalyse:    1. Plot AIC/BIC/NNL for all models

%%

figpath='figures';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 1. Plot AIC/BIC/NLL for all models
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if doanalyse(1)==1,
    
allmodel_IDs={ 'onekonebeta'      ...
               'onektwobetamodel' ...
               'twokonebetamodel' ...
               'twoktwobetamodel' };

figure;

no_o_models=numel(allmodel_IDs);
   
for imodel=1:no_o_models,
      
    modelID=allmodel_IDs{imodel};

    %pick model:
    
    mod=allmodels.(modelID);
      
    nr_trials=48;   %%%% CHANGE THIS IF NECESSARY!!!
    
    % information you want to have:
    
    all_nnl=[];
    all_aic=[];
    all_bic=[];
    all_param=[];
    
    % loop over subjects
    for is=1:numel(mod)
        all_param=[all_param; mod{is}.x];
        param_names= mod{1}.xnames;
        nr_free_p=length(mod{is}.x);
        all_nnl=[all_nnl; mod{is}.fval];
        [aic, bic]=aicbic(-mod{is}.fval, nr_free_p, nr_trials);
        all_aic=[all_aic; aic];
        all_bic=[all_bic; bic];     
    end;
    
    
    output.all_aic_all(:,imodel)=all_aic
    output.all_bic_all(:,imodel)=all_bic
    output.all_nnl_all(:,imodel)=all_nnl
    output.sum_all_aic(:,imodel)=sum(all_aic)
    output.sum_all_bic(:,imodel)=sum(all_bic)
    output.sum_all_nnl(:,imodel)=sum(all_nnl)
    
    bar(mean(all_param));
    
    set(gca, 'xtick',1:numel(param_names),'xticklabel',param_names)
    
    %errorbar(std(all_param),'k.')
    
   figname=(modelID);
   full_figname=[figpath '/' figname '.jpg' ];
   saveas(gcf,full_figname);
   close all; 
 
end;

%%plot AIC, BIC and NLL

subplot(3,1,1)
plot(output.all_aic_all)
legend(allmodel_IDs); title('AIC');

 
hold on;

subplot(3,1,2)
plot(output.all_bic_all)
legend(allmodel_IDs); title('BIC');
hold on;

subplot(3,1,3)
plot(output.all_nnl_all)
 legend(allmodel_IDs); title('NLL');
figname=('modelfit_aic_bic_nll');
full_figname=[figpath '/' figname '.jpg' ];
saveas(gcf,full_figname);

close all

subplot(3,1,1)
bar(output.sum_all_aic)

hold on;

subplot(3,1,2)
bar(output.sum_all_bic)

hold on;

subplot(3,1,3)
bar(output.sum_all_nnl)

figname=('modelfit_aic_bic_nll_bar');
full_figname=[figpath '/' figname '.jpg' ];
saveas(gcf,full_figname);

close all

end %doanalyse



