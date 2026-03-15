
%%Script for running effort based decision-making model for self and other.
%%Calls functions run_pats_prosocial_motivation_model that uses fminsearch/fmincon
%%to run models with different numbers of parameters
%%Written by Pat Lockwood based September 2016
%%Modified: output in long format for all model families (parabolic, linear, hyperbolic)

%% 1. Loads in data to do modelling

clear all;
clc;

dir_data= 'C:\Users\yangy\Desktop\Comp_Models_Seba_ALL';
dir_analysis='C:\Users\yangy\Desktop\Comp_Models_Seba_ALL';

cd(dir_data);

pick_sample=4;

if pick_sample==1;
    numsubs=48;
    load model_data.mat
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

%% 2. Run all models

% --- Parabolic ---
allmodels.onekonebeta                = run_pats_prosocial_motivation_model(data, pick_sample,'one_k_one_beta');
allmodels.twokonebetamodel           = run_pats_prosocial_motivation_model(data, pick_sample,'two_k_one_beta');
allmodels.onektwobetamodel           = run_pats_prosocial_motivation_model(data, pick_sample,'one_k_two_beta');
allmodels.twoktwobetamodel           = run_pats_prosocial_motivation_model(data, pick_sample,'two_k_two_beta');

% --- Linear ---
allmodels.onekonebetamodellinear     = run_pats_prosocial_motivation_model(data, pick_sample,'one_k_one_beta_linear');
allmodels.twokonebetamodellinear     = run_pats_prosocial_motivation_model(data, pick_sample,'two_k_one_beta_linear');
allmodels.onektwobetamodellinear     = run_pats_prosocial_motivation_model(data, pick_sample,'one_k_two_beta_linear');
allmodels.twoktwobetamodellinear     = run_pats_prosocial_motivation_model(data, pick_sample,'two_k_two_beta_linear');

% --- Hyperbolic ---
allmodels.onekonebetamodelhyperbolic = run_pats_prosocial_motivation_model(data, pick_sample,'one_k_one_beta_hyperbolic');
allmodels.twokonebetamodelhyperbolic = run_pats_prosocial_motivation_model(data, pick_sample,'two_k_one_beta_hyperbolic');
allmodels.onektwobetamodelhyperbolic = run_pats_prosocial_motivation_model(data, pick_sample,'one_k_two_beta_hyperbolic');
allmodels.twoktwobetamodelhyperbolic = run_pats_prosocial_motivation_model(data, pick_sample,'two_k_two_beta_hyperbolic');


%% 3. Extract parameters into structured output

for j = 1:numsubs
    
    % --- PARABOLIC ---
    output.parabolic.param1K1B(j,:) = allmodels.onekonebeta{1,j}.x;
    output.parabolic.param1K2B(j,:) = allmodels.onektwobetamodel{1,j}.x;
    output.parabolic.param2K1B(j,:) = allmodels.twokonebetamodel{1,j}.x;
    output.parabolic.param2K2B(j,:) = allmodels.twoktwobetamodel{1,j}.x;
    output.parabolic.fval1K1B(j,1)  = allmodels.onekonebeta{1,j}.fval;
    output.parabolic.fval1K2B(j,1)  = allmodels.onektwobetamodel{1,j}.fval;
    output.parabolic.fval2K1B(j,1)  = allmodels.twokonebetamodel{1,j}.fval;
    output.parabolic.fval2K2B(j,1)  = allmodels.twoktwobetamodel{1,j}.fval;
    
    % --- LINEAR ---
    output.linear.param1K1B(j,:) = allmodels.onekonebetamodellinear{1,j}.x;
    output.linear.param1K2B(j,:) = allmodels.onektwobetamodellinear{1,j}.x;
    output.linear.param2K1B(j,:) = allmodels.twokonebetamodellinear{1,j}.x;
    output.linear.param2K2B(j,:) = allmodels.twoktwobetamodellinear{1,j}.x;
    output.linear.fval1K1B(j,1)  = allmodels.onekonebetamodellinear{1,j}.fval;
    output.linear.fval1K2B(j,1)  = allmodels.onektwobetamodellinear{1,j}.fval;
    output.linear.fval2K1B(j,1)  = allmodels.twokonebetamodellinear{1,j}.fval;
    output.linear.fval2K2B(j,1)  = allmodels.twoktwobetamodellinear{1,j}.fval;
    
    % --- HYPERBOLIC ---
    output.hyperbolic.param1K1B(j,:) = allmodels.onekonebetamodelhyperbolic{1,j}.x;
    output.hyperbolic.param1K2B(j,:) = allmodels.onektwobetamodelhyperbolic{1,j}.x;
    output.hyperbolic.param2K1B(j,:) = allmodels.twokonebetamodelhyperbolic{1,j}.x;
    output.hyperbolic.param2K2B(j,:) = allmodels.twoktwobetamodelhyperbolic{1,j}.x;
    output.hyperbolic.fval1K1B(j,1)  = allmodels.onekonebetamodelhyperbolic{1,j}.fval;
    output.hyperbolic.fval1K2B(j,1)  = allmodels.onektwobetamodelhyperbolic{1,j}.fval;
    output.hyperbolic.fval2K1B(j,1)  = allmodels.twokonebetamodelhyperbolic{1,j}.fval;
    output.hyperbolic.fval2K2B(j,1)  = allmodels.twoktwobetamodelhyperbolic{1,j}.fval;
    
end

save('output_all_models.mat', 'output')











%% 4. Export to CSV - Long Format
%  Columns: subject_id | family | model | k_self | k_other | beta_self | beta_other | NLL | AIC | BIC
%  Total rows = 84 sujetos x 3 familias x 4 modelos = 1008 filas

% Load subject IDs
datos_long = readtable('Data\datos_long_models.csv');
unique_subs = unique(datos_long.sub);

families = {'parabolic', 'linear', 'hyperbolic'};
nr_trials = 48;

% Model configurations: {model_name, param_field, fval_field, n_free_params}
model_configs = {
    '1K1B', 'param1K1B', 'fval1K1B', 2;
    '1K2B', 'param1K2B', 'fval1K2B', 3;
    '2K1B', 'param2K1B', 'fval2K1B', 3;
    '2K2B', 'param2K2B', 'fval2K2B', 4;
};

% Pre-allocate
total_rows = numsubs * length(families) * size(model_configs, 1);
subject_id_col  = zeros(total_rows, 1);
family_col      = cell(total_rows, 1);
model_col       = cell(total_rows, 1);
k_self_col      = NaN(total_rows, 1);
k_other_col     = NaN(total_rows, 1);
beta_self_col   = NaN(total_rows, 1);
beta_other_col  = NaN(total_rows, 1);
NLL_col         = zeros(total_rows, 1);
AIC_col         = zeros(total_rows, 1);
BIC_col         = zeros(total_rows, 1);

row_idx = 0;

for f = 1:length(families)
    fam = families{f};
    
    for m = 1:size(model_configs, 1)
        model_name  = model_configs{m, 1};
        param_field = model_configs{m, 2};
        fval_field  = model_configs{m, 3};
        n_params    = model_configs{m, 4};
        
        params = output.(fam).(param_field);
        fvals  = output.(fam).(fval_field);
        
        for j = 1:numsubs
            row_idx = row_idx + 1;
            
            subject_id_col(row_idx) = unique_subs(j);
            family_col{row_idx}     = fam;
            model_col{row_idx}      = model_name;
            NLL_col(row_idx)        = fvals(j);
            
            % AIC y BIC
            [aic_val, bic_val] = aicbic(-fvals(j), n_params, nr_trials);
            AIC_col(row_idx) = aic_val;
            BIC_col(row_idx) = bic_val;
            
            % Asignar parametros segun estructura del modelo
            switch model_name
                case '1K1B'
                    % [k, beta] - mismo k y beta para self y other
                    k_self_col(row_idx)     = params(j, 1);
                    k_other_col(row_idx)    = params(j, 1);
                    beta_self_col(row_idx)  = params(j, 2);
                    beta_other_col(row_idx) = params(j, 2);
                case '1K2B'
                    % [k, beta_self, beta_other] - mismo k, betas separados
                    k_self_col(row_idx)     = params(j, 1);
                    k_other_col(row_idx)    = params(j, 1);
                    beta_self_col(row_idx)  = params(j, 2);
                    beta_other_col(row_idx) = params(j, 3);
                case '2K1B'
                    % [k_self, k_other, beta] - k separados, mismo beta
                    k_self_col(row_idx)     = params(j, 1);
                    k_other_col(row_idx)    = params(j, 2);
                    beta_self_col(row_idx)  = params(j, 3);
                    beta_other_col(row_idx) = params(j, 3);
                case '2K2B'
                    % [k_self, k_other, beta_self, beta_other] - todo separado
                    k_self_col(row_idx)     = params(j, 1);
                    k_other_col(row_idx)    = params(j, 2);
                    beta_self_col(row_idx)  = params(j, 3);
                    beta_other_col(row_idx) = params(j, 4);
            end
        end
    end
end

% Crear tabla y guardar
long_table = table(subject_id_col, family_col, model_col, ...
    k_self_col, k_other_col, beta_self_col, beta_other_col, ...
    NLL_col, AIC_col, BIC_col, ...
    'VariableNames', {'subject_id', 'family', 'model', ...
    'k_self', 'k_other', 'beta_self', 'beta_other', ...
    'NLL', 'AIC', 'BIC'});

writetable(long_table, 'output_all_models_long.csv');
fprintf('Long format saved: %d rows x %d columns\n', height(long_table), width(long_table));






%% 5. Model comparison summary (sum BIC por modelo - menor es mejor)

model_names_all = {};
sum_bic_all = [];
sum_aic_all = [];

for f = 1:length(families)
    fam = families{f};
    for m = 1:size(model_configs, 1)
        fvals = output.(fam).(model_configs{m, 3});
        n_p = model_configs{m, 4};
        
        all_aic = zeros(numsubs, 1);
        all_bic = zeros(numsubs, 1);
        for j = 1:numsubs
            [all_aic(j), all_bic(j)] = aicbic(-fvals(j), n_p, nr_trials);
        end
        
        model_names_all{end+1} = [fam '_' model_configs{m, 1}];
        sum_bic_all(end+1) = sum(all_bic);
        sum_aic_all(end+1) = sum(all_aic);
    end
end

comparison_table = table(model_names_all', sum_aic_all', sum_bic_all', ...
    'VariableNames', {'model', 'sum_AIC', 'sum_BIC'});
writetable(comparison_table, 'model_comparison_12models.csv');











%% 6. Script para transformar output_all_models_long.csv a formato wide
%  Input:  output_all_models_long.csv (1008 filas, long format)
%  Output: output_wide_fit_metrics.xlsx (84 filas, wide format)


% Cargar datos
long_data = readtable('C:\Users\yangy\Desktop\Comp_Models_Seba_ALL\Output Seba\output_all_models_long.csv');
datos_grupo = readtable('C:\Users\yangy\Desktop\Comp_Models_Seba_ALL\Datos Seba\datos_long_models.csv');

% Extraer grupo por sujeto
if iscell(datos_grupo.sub) || isstring(datos_grupo.sub)
    sub_nums = str2double(datos_grupo.sub);
else
    sub_nums = datos_grupo.sub;
end

if iscell(datos_grupo.grupo) || isstring(datos_grupo.grupo)
    grupo_nums = str2double(datos_grupo.grupo);
else
    grupo_nums = datos_grupo.grupo;
end

grupo_table = table(sub_nums, grupo_nums, 'VariableNames', {'subject_id', 'grupo'});
grupo_table = unique(grupo_table, 'rows');

% Asegurar tipos correctos en long_data
if iscell(long_data.subject_id) || isstring(long_data.subject_id)
    long_data.subject_id = str2double(long_data.subject_id);
end
if iscell(long_data.family)
    long_data.family = string(long_data.family);
end
if iscell(long_data.model)
    long_data.model = string(long_data.model);
end

% Mapeo de familia a letra
family_map = containers.Map({'parabolic','linear','hyperbolic'}, {'p','l','h'});

% Crear tabla wide
unique_subs = unique(long_data.subject_id);
wide_table = table(unique_subs, 'VariableNames', {'subject_id'});

families = {'parabolic', 'linear', 'hyperbolic'};
models   = {'1K1B', '1K2B', '2K1B', '2K2B'};
metrics  = {'NLL', 'AIC', 'BIC'};

for f = 1:length(families)
    fam = families{f};
    fam_letter = family_map(fam);
    
    for m = 1:length(models)
        mod = models{m};
        
        idx = long_data.family == fam & long_data.model == mod;
        subset = sortrows(long_data(idx, :), 'subject_id');
        
        for mt = 1:length(metrics)
            metric = metrics{mt};
            col_name = [fam_letter '_' lower(mod) '_' metric];
            wide_table.(col_name) = subset.(metric);
        end
    end
end

% Agregar grupo con innerjoin
wide_table = innerjoin(wide_table, grupo_table, 'Keys', 'subject_id');

% Guardar como .xlsx
writetable(wide_table, 'output_wide_fit_metrics.xlsx');
fprintf('Archivo guardado: %d filas x %d columnas\n', height(wide_table), width(wide_table));
