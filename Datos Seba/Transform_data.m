%% Script para transformar datos_long.csv al formato data_all_seb.mat

clear all;

% Cargar datos desde CSV
datos_long = readtable('C:\Users\yangy\Desktop\Comp_Models_Seba\Data\datos_long_models.csv');

% Obtener información de la estructura de los datos
unique_subs = unique(datos_long.sub);
num_subs = length(unique_subs);
num_trials = max(datos_long.trial);

fprintf('\nNúmero de sujetos: %d\n', num_subs); % 101
fprintf('Número de trials: %d\n', num_trials); % 48

% Inicializar matrices para el formato wide
% Crear matrices de trials x sujetos (igual que data_all_seb.mat)
data.chosen = zeros(num_trials, num_subs);
data.effort = zeros(num_trials, num_subs);
data.reward = zeros(num_trials, num_subs);
data.agent = zeros(num_trials, num_subs);

% Llenar las matrices transformando de long a wide
for i = 1:height(datos_long)
    sub_id = datos_long.sub(i);
    trial_num = datos_long.trial(i);
    
    % Encontrar el índice del sujeto en el array de sujetos únicos
    sub_idx = find(unique_subs == sub_id);
    
    % Asignar valores a las matrices
    % Nota: decision en el CSV corresponde a chosen en el .mat
    data.chosen(trial_num, sub_idx) = datos_long.decision(i);
    data.effort(trial_num, sub_idx) = datos_long.effort(i);
    data.reward(trial_num, sub_idx) = datos_long.reward(i);
    data.agent(trial_num, sub_idx) = datos_long.agent(i);
end

% Mostrar estadísticas básicas
fprintf('Proporción de trabajar: %.2f%%\n', sum(data.chosen(:)==1)/numel(data.chosen)*100);


% Guardar el archivo .mat en el mismo formato que data_all_seb.mat
save('datos_filtrados_long.mat', 'data');




%%

% Segmentar por grupo
grupo_vulnerable = datos_long(datos_long.grupo == 1, :); 
grupo_no_vulnerable = datos_long(datos_long.grupo == 0, :); 

% Guardar CSVs separados
writetable(grupo_vulnerable, 'Data\datos_vulnerable.csv'); % 43
writetable(grupo_no_vulnerable, 'Data\datos_no_vulnerable.csv'); % 41




%%

% Cargar datos desde CSV
datos_long = readtable('C:\Users\yangy\Desktop\Comp_Models_Seba\Data\datos_no_vulnerable.csv');

% Obtener información de la estructura de los datos
unique_subs = unique(datos_long.sub);
num_subs = length(unique_subs);
num_trials = max(datos_long.trial);

fprintf('\nNúmero de sujetos: %d\n', num_subs); % 101
fprintf('Número de trials: %d\n', num_trials); % 48

% Inicializar matrices para el formato wide
% Crear matrices de trials x sujetos (igual que data_all_seb.mat)
data.chosen = zeros(num_trials, num_subs);
data.effort = zeros(num_trials, num_subs);
data.reward = zeros(num_trials, num_subs);
data.agent = zeros(num_trials, num_subs);

% Llenar las matrices transformando de long a wide
for i = 1:height(datos_long)
    sub_id = datos_long.sub(i);
    trial_num = datos_long.trial(i);
    
    % Encontrar el índice del sujeto en el array de sujetos únicos
    sub_idx = find(unique_subs == sub_id);
    
    % Asignar valores a las matrices
    % Nota: decision en el CSV corresponde a chosen en el .mat
    data.chosen(trial_num, sub_idx) = datos_long.decision(i);
    data.effort(trial_num, sub_idx) = datos_long.effort(i);
    data.reward(trial_num, sub_idx) = datos_long.reward(i);
    data.agent(trial_num, sub_idx) = datos_long.agent(i);
end

% Mostrar estadísticas básicas
fprintf('Proporción de trabajar: %.2f%%\n', sum(data.chosen(:)==1)/numel(data.chosen)*100);

% Guardar el archivo .mat en el mismo formato que data_all_seb.mat
save('datos_filtrados_no_vulnerable.mat', 'data');




%%

% Cargar datos desde CSV
datos_long = readtable('C:\Users\yangy\Desktop\Comp_Models_Seba\Data\datos_vulnerable.csv');

% Obtener información de la estructura de los datos
unique_subs = unique(datos_long.sub);
num_subs = length(unique_subs);
num_trials = max(datos_long.trial);

fprintf('\nNúmero de sujetos: %d\n', num_subs); % 101
fprintf('Número de trials: %d\n', num_trials); % 48

% Inicializar matrices para el formato wide
% Crear matrices de trials x sujetos (igual que data_all_seb.mat)
data.chosen = zeros(num_trials, num_subs);
data.effort = zeros(num_trials, num_subs);
data.reward = zeros(num_trials, num_subs);
data.agent = zeros(num_trials, num_subs);

% Llenar las matrices transformando de long a wide
for i = 1:height(datos_long)
    sub_id = datos_long.sub(i);
    trial_num = datos_long.trial(i);
    
    % Encontrar el índice del sujeto en el array de sujetos únicos
    sub_idx = find(unique_subs == sub_id);
    
    % Asignar valores a las matrices
    % Nota: decision en el CSV corresponde a chosen en el .mat
    data.chosen(trial_num, sub_idx) = datos_long.decision(i);
    data.effort(trial_num, sub_idx) = datos_long.effort(i);
    data.reward(trial_num, sub_idx) = datos_long.reward(i);
    data.agent(trial_num, sub_idx) = datos_long.agent(i);
end

% Mostrar estadísticas básicas
fprintf('Proporción de trabajar: %.2f%%\n', sum(data.chosen(:)==1)/numel(data.chosen)*100);

% Guardar el archivo .mat en el mismo formato que data_all_seb.mat
save('datos_filtrados_vulnerable.mat', 'data');
