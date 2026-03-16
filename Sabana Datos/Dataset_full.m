
% Extract 2k1b parameters

clear all; clc;
 
long_data = readtable('Output Seba\output_all_models_long.csv');
 
if iscell(long_data.family), long_data.family = string(long_data.family); end
if iscell(long_data.model), long_data.model = string(long_data.model); end
 
idx_2k1b = long_data.model == "2K1B";
families = {'parabolic', 'linear', 'hyperbolic'};
prefixes = {'p', 'l', 'h'};
 
unique_subs = unique(long_data.subject_id);
result = table(unique_subs, 'VariableNames', {'subject_id'});
 
for f = 1:3
    subset = sortrows(long_data(idx_2k1b & long_data.family == families{f}, :), 'subject_id');
    result.([prefixes{f} '_2k1b_k_self'])  = subset.k_self;
    result.([prefixes{f} '_2k1b_k_other']) = subset.k_other;
    result.([prefixes{f} '_2k1b_beta'])    = subset.beta_self;
end
 
writetable(result, 'params_2k1b_all_families.xlsx');




% Add k_self - k_other column

clear all; clc;
 
T = readtable('params_2k1b_all_families.xlsx');
 
T.p_2k1b_diff_k = T.p_2k1b_k_self - T.p_2k1b_k_other;
T.l_2k1b_diff_k = T.l_2k1b_k_self - T.l_2k1b_k_other;
T.h_2k1b_diff_k = T.h_2k1b_k_self - T.h_2k1b_k_other;
 
writetable(T, 'params_2k1b_all_families.xlsx');




% Join dataset Huepe

clear all; clc;
 
params = readtable('params_2k1b_all_families.xlsx');
diego = readtable('Sabana Datos\pasar_a_diego_v2.csv');
 
% Asegurar que ambos IDs sean double
if iscell(diego.sub) || isstring(diego.sub)
    diego.sub = str2double(diego.sub);
end
 
% Renombrar para que coincida la key del join
diego.Properties.VariableNames{'sub'} = 'subject_id';
 
% Merge
merged = innerjoin(diego, params, 'Keys', 'subject_id');
 
writetable(merged, 'dataset_completo.xlsx');




% Add column

clear all; clc;
 
params = readtable('Sabana Datos\params_2k1b_all_families.xlsx');
diego = readtable('Sabana Datos\pasar_a_diego_v2.csv');
 
if iscell(diego.sub) || isstring(diego.sub)
    diego.sub = str2double(diego.sub);
end
 
grupo_table = table(diego.sub, diego.grupo, 'VariableNames', {'subject_id', 'grupo'});
grupo_table = unique(grupo_table, 'rows');
 
params = innerjoin(params, grupo_table, 'Keys', 'subject_id');
 
writetable(params, 'params_2k1b_all_families.xlsx');
 
