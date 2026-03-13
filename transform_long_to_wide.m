%% Script para transformar output_all_models_long.csv a formato wide
%  Input:  output_all_models_long.csv (1008 filas, long format)
%  Output: output_wide_fit_metrics.xlsx (84 filas, wide format)
%
%  IMPORTANTE: Se exporta como .xlsx para evitar problemas de
%  interpretacion decimal al abrir CSV en Excel con configuracion
%  regional en español.

clear all; clc;

%% 1. Cargar datos
long_data = readtable('C:\Users\yangy\Desktop\Comp_Models_Seba_ALL\output_all_models_long.csv');
datos_grupo = readtable('C:\Users\yangy\Desktop\Comp_Models_Seba_ALL\Data\datos_long_models.csv');

%% 2. Extraer grupo por sujeto
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

%% 3. Asegurar tipos correctos en long_data
if iscell(long_data.subject_id) || isstring(long_data.subject_id)
    long_data.subject_id = str2double(long_data.subject_id);
end
if iscell(long_data.family)
    long_data.family = string(long_data.family);
end
if iscell(long_data.model)
    long_data.model = string(long_data.model);
end

%% 4. Mapeo de familia a letra
family_map = containers.Map({'parabolic','linear','hyperbolic'}, {'p','l','h'});

%% 5. Crear tabla wide
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

%% 6. Agregar grupo con innerjoin
wide_table = innerjoin(wide_table, grupo_table, 'Keys', 'subject_id');

%% 7. Guardar como .xlsx
writetable(wide_table, 'output_wide_fit_metrics.xlsx');
fprintf('Archivo guardado: %d filas x %d columnas\n', height(wide_table), width(wide_table));
