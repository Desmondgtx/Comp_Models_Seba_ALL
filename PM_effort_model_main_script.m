
%%Script for running effort based decision-making model for self and other.
%%Calls functions run_pats_prosocial_motivation_model that uses fminsearch
%%to run models with different numbers of parameters
%%then calls visualize_model function to plot the parmeters from the
%%different models, do model comparison and save in a variable called
%%output. In output the parameters of the model (k and beta values depending on what model was run) 
% are stored in output for each subject so they can be
%%correlated with other other measures
%%Written by Pat Lockwood based September 2016

%% 1. Loads in data to do modelling

clear all;
clc;

dir_data= 'C:\Users\yangy\Desktop\Comp_Models_Seba'; % where your data files are
dir_analysis='C:\Users\yangy\Desktop\Comp_Models_Seba'; % where your analysis files are, e.g. this script and each model function

cd(dir_data);

pick_sample=4;  %% specify which sample to pick as three different samples in original study. 
                %%Each datafile contains varibles that specify for each subject ther effort level, reward level, agent, choice
                %% these variables are stored in a seperate variable called data.chosen data.effort etc where each column is a subject and each row is a trial
                
if pick_sample==1;
      
    numsubs=48;   % specify number of subjects
    
    load model_data.mat % Load the sorted data file
    
elseif pick_sample==2;
    
    numsubs=45;
    
    load data_win.mat
    
elseif pick_sample==3;
    
    numsubs=45;
    
    load data_lose.mat
    
elseif pick_sample ==4;
    
    numsubs=84;
    
    load datos_filtrados_long.mat;
end

cd(dir_analysis)

%% Modelling
%%%%%%%%%

%%% 1. Run models:
% runs a function called 'run_pats_prosocial_motivation_model' that takes
% the model ID and runs each of the different models with different
% discount (k) and temperature (beta) parameters

allmodels.onekonebeta                = run_pats_prosocial_motivation_model(data, pick_sample,'one_k_one_beta');            % Parabolic model with one discount rate (k) and one beta
allmodels.twokonebetamodel           = run_pats_prosocial_motivation_model(data, pick_sample,'two_k_one_beta');            % Parabolic model with two discount rates (k) and one beta
allmodels.onektwobetamodel           = run_pats_prosocial_motivation_model(data, pick_sample,'one_k_two_beta');            % Parabolic model with one discount rates (k) and two betas
allmodels.twoktwobetamodel           = run_pats_prosocial_motivation_model(data, pick_sample,'two_k_two_beta');            % Parabolic model with two discount rates (k) and two betas
% allmodels.onekonebetamodellinear     = run_pats_prosocial_motivation_model(data, pick_sample,'one_k_one_beta_linear');     % linear model with one discount rate (k) and one beta
% allmodels.twokonebetamodellinear     = run_pats_prosocial_motivation_model(data, pick_sample,'two_k_one_beta_linear');     % linear model with two discount rates (k) and one beta
% allmodels.twoktwobetamodellinear     = run_pats_prosocial_motivation_model(data, pick_sample,'two_k_two_beta_linear');     % linear model with two discount rates (k) and two betas
% allmodels.onektwobetamodellinear     = run_pats_prosocial_motivation_model(data, pick_sample,'one_k_two_beta_linear');     % linear model with one discount rates (k) and two betas
% allmodels.onekonebetamodelhyperbolic = run_pats_prosocial_motivation_model(data, pick_sample,'one_k_one_beta_hyperbolic'); % hyperbolic model with one discount rate (k) and one beta
% allmodels.twokonebetamodelhyperbolic = run_pats_prosocial_motivation_model(data, pick_sample,'two_k_one_beta_hyperbolic'); % hyperbolic model with two discount rates (k) and one beta
% allmodels.twoktwobetamodelhyperbolic = run_pats_prosocial_motivation_model(data, pick_sample,'two_k_two_beta_hyperbolic'); % hyperbolic model with two discount rates (k) and two betas
% allmodels.onektwobetamodelhyperbolic = run_pats_prosocial_motivation_model(data, pick_sample,'one_k_two_beta_hyperbolic'); % hyperbolic model with one discount rate (k) and two betas


%%% 2. Visualize and compare models:
% runs a function called visualize model that does the model comparison
% with AIC and BIC and plots some of the key variables
output = visualize_model_PM(allmodels,'onekonebeta',[1 0]);

%%% 3. Get discount (k) parameters for correlations:
% make a new variable called output that saves the k and beta parameters
% for the specific models you are interested in to run correlations with
% individual differences.

for j=1:numsubs;
    
output.param2K2B(j,:) = allmodels.twoktwobetamodel{1,j}.x;
output.param2K1B(j,:) = allmodels.twokonebetamodel{1,j}.x;

end


save('output.mat', "output")





%% Script para exportar output.mat a CSV para uso en R

% clear all;

% Load output file
% load output.mat;

% Load csv file
datos_long = readtable('Data\datos_long_models.csv');
unique_subs = unique(datos_long.sub);


% 1. Crear tabla principal con parámetros e IDs

% param2K2B: k_self, k_other, beta_self, beta_other
param2K2B_table = array2table(output.param2K2B, ...
    'VariableNames', {'k_self', 'k_other', 'beta_self', 'beta_other'});

% param2K1B: k_self, k_other, beta
param2K1B_table = array2table(output.param2K1B, ...
    'VariableNames', {'k_self_2K1B', 'k_other_2K1B', 'beta_2K1B'});

% Agregar IDs de sujetos
subject_ids = array2table(unique_subs, 'VariableNames', {'subject_id'});

% Combinar todo
main_table = [subject_ids, param2K2B_table, param2K1B_table];

% Guardar tabla principal
writetable(main_table, 'id_2k2b_2k1b_parameters.csv');


%% 2. Guardar métricas de ajuste (AIC, BIC, NLL) por modelo

% Las 4 columnas corresponden a los 4 modelos
model_names = {'onekonebeta', 'onektwobetamodel', 'twokonebetamodel', 'twoktwobetamodel'};

% AIC
aic_table = array2table([unique_subs, output.all_aic_all], ...
    'VariableNames', ['subject_id', strcat('AIC_', model_names)]);
writetable(aic_table, 'AIC_results.csv');

% BIC
bic_table = array2table([unique_subs, output.all_bic_all], ...
    'VariableNames', ['subject_id', strcat('BIC_', model_names)]);
writetable(bic_table, 'BIC_results.csv');

% NLL (Negative Log-Likelihood)
nll_table = array2table([unique_subs, output.all_nnl_all], ...
    'VariableNames', ['subject_id', strcat('NLL_', model_names)]);
writetable(nll_table, 'NLL_results.csv');


%% 3. Guardar resumen de modelos (sumas totales)

model_summary = array2table([output.sum_all_aic; output.sum_all_bic; output.sum_all_nnl], ...
    'VariableNames', model_names, ...
    'RowNames', {'sum_AIC', 'sum_BIC', 'sum_NLL'});
writetable(model_summary, 'model_summary.csv', 'WriteRowNames', true);


%% 4. Crear tabla completa (todo en un solo CSV)
complete_table = [subject_ids, param2K2B_table, param2K1B_table, ...
    array2table(output.all_aic_all, 'VariableNames', strcat('AIC_', model_names)), ...
    array2table(output.all_bic_all, 'VariableNames', strcat('BIC_', model_names)), ...
    array2table(output.all_nnl_all, 'VariableNames', strcat('NLL_', model_names))];

writetable(complete_table, 'output_complete.csv');



%% 5. Exportar solamente all_bic_all y param2K1B a CSV


model_names = {'onekonebeta', 'onektwobetamodel', 'twokonebetamodel', 'twoktwobetamodel'};
combined_table = array2table([unique_subs, output.all_bic_all, output.param2K1B], ...
    'VariableNames', ['subject_id', strcat('BIC_', model_names), {'k_self', 'k_other', 'beta'}]);
writetable(combined_table, 'id_BIC_models.csv');