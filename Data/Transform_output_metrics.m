%% Script para transformar output_all_models_long.csv a formato wide
%  Input:  output_all_models_long.csv (1008 filas, long format)
%  Output: output_wide_fit_metrics.csv (84 filas, wide format)
%  Columnas: subject_id | p_1k1b_NLL | p_1k1b_AIC | ... | grupo

clear all; clc;

%% 1. Cargar datos
long_data = readtable('output_all_models_long.csv');
datos_grupo = readtable('Data\datos_long_models.csv');

%% 2. Extraer grupo por sujeto (0 = No Vulnerable, 1 = Vulnerable)
%  datos_long_models tiene 48 filas por sujeto, tomamos valor unico
%  sub puede venir como string "0155" o numerico, forzamos a double

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

%% 3. Asegurar que subject_id en long_data tambien sea double
if iscell(long_data.subject_id) || isstring(long_data.subject_id)
    long_data.subject_id = str2double(long_data.subject_id);
end

% Convertir family y model a string si son cell
if iscell(long_data.family)
    long_data.family = string(long_data.family);
end
if iscell(long_data.model)
    long_data.model = string(long_data.model);
end

%% 4. Definir mapeo de familia a letra
family_map = containers.Map({'parabolic','linear','hyperbolic'}, {'p','l','h'});

%% 5. Obtener sujetos unicos
unique_subs = unique(long_data.subject_id);
n_subs = length(unique_subs);

%% 6. Crear tabla wide
wide_table = table(unique_subs, 'VariableNames', {'subject_id'});

families = {'parabolic', 'linear', 'hyperbolic'};
models   = {'1K1B', '1K2B', '2K1B', '2K2B'};
metrics  = {'NLL', 'AIC', 'BIC'};

for f = 1:length(families)
    fam = families{f};
    fam_letter = family_map(fam);
    
    for m = 1:length(models)
        mod = models{m};
        
        % Filtrar filas de esta combinacion familia + modelo
        idx = long_data.family == fam & long_data.model == mod;
        subset = long_data(idx, :);
        subset = sortrows(subset, 'subject_id');
        
        for mt = 1:length(metrics)
            metric = metrics{mt};
            col_name = [fam_letter '_' lower(mod) '_' metric];
            wide_table.(col_name) = subset.(metric);
        end
    end
end

%% 7. Agregar columna de grupo con innerjoin
wide_table = innerjoin(wide_table, grupo_table, 'Keys', 'subject_id');

%% 8. Verificar y guardar
fprintf('Sujetos en wide_table: %d\n', height(wide_table));
fprintf('Sujetos en grupo_table: %d\n', height(grupo_table));
fprintf('Archivo guardado: %d filas x %d columnas\n', height(wide_table), width(wide_table));

writetable(wide_table, 'output_wide_fit_metrics.csv');