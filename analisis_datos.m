%% Análisis datos

clear all;
clc;

% 1) ver el BIC total de cada modelo

% one_k_one_beta     one_k_two_beta     two_k_one_beta      two_k_two_beta    
% 3879.58610951623	5216.93519856285	4054.3179600344	    5542.11566808483


%% 2) dividir la muestra en vulnerable y no vulnerable y sumar separadamente los BIC por grupo (o correr los modelos con cada muestra grupal por separado)

% No Vulnerables
% one_k_one_beta     one_k_two_beta     two_k_one_beta      two_k_two_beta 
% 1991.50778818007	2615.37586486393	2071.44102533671	2774.09486308465

% Vulnerables
% one_k_one_beta     one_k_two_beta     two_k_one_beta      two_k_two_beta 
% 1888.07832133616	2601.55933369892	1982.87693469769	2768.02080500018


%% 3) pescar el modelo 2k1b y ver diferencia  k_other - k_self (por sujeto y ver la dispersión) 

% Importar datos
params_NV = readtable('No_vulnerables\id_2k2b_2k1b_parameters.csv');

% Calcular diferencias
params_NV.diff_kother_minus_kself = params_NV.k_other_2K1B - params_NV.k_self_2K1B;
params_NV.diff_kself_minus_kother = params_NV.k_self_2K1B - params_NV.k_other_2K1B;

% Graficar dispersión
figure;
subplot(1,2,1);
scatter(1:height(params_NV), params_NV.diff_kother_minus_kself, 'filled');
hold on;
yline(mean(params_NV.diff_kother_minus_kself), 'r--', 'LineWidth', 2);
xlabel('Sujeto'); ylabel('k_{other} - k_{self}');
title('No Vulnerables: k_{other} - k_{self}');

subplot(1,2,2);
histogram(params_NV.diff_kother_minus_kself, 15);
xline(mean(params_NV.diff_kother_minus_kself), 'r--', 'LineWidth', 2);
xlabel('k_{other} - k_{self}'); ylabel('Frecuencia');
title(sprintf('Media = %.4f, SD = %.4f', mean(params_NV.diff_kother_minus_kself), std(params_NV.diff_kother_minus_kself)));

sgtitle('Dispersión No Vulnerables - Modelo 2K1B');


figure;
subplot(1,2,1);
scatter(1:height(params_NV), params_NV.diff_kself_minus_kother, 'filled');
hold on;
yline(mean(params_NV.diff_kself_minus_kother), 'r--', 'LineWidth', 2);
xlabel('Sujeto'); ylabel('k_{self} - k_{other}');
title('No Vulnerables: k_{self} - k_{other}');

subplot(1,2,2);
histogram(params_NV.diff_kself_minus_kother, 15);
xline(mean(params_NV.diff_kself_minus_kother), 'r--', 'LineWidth', 2);
xlabel('k_{self} - k_{other}'); ylabel('Frecuencia');
title(sprintf('Media = %.4f, SD = %.4f', mean(params_NV.diff_kself_minus_kother), std(params_NV.diff_kself_minus_kother)));

sgtitle('Dispersión No Vulnerables - Modelo 2K1B');








% Importar datos
params_V = readtable('Vulnerables\id_2k2b_2k1b_parameters.csv');

% Calcular diferencias
params_V.diff_kother_minus_kself = params_V.k_other_2K1B - params_V.k_self_2K1B;
params_V.diff_kself_minus_kother = params_V.k_self_2K1B - params_V.k_other_2K1B;

% Graficar dispersión
figure;
subplot(1,2,1);
scatter(1:height(params_V), params_V.diff_kother_minus_kself, 'filled');
hold on;
yline(mean(params_V.diff_kother_minus_kself), 'r--', 'LineWidth', 2);
xlabel('Sujeto'); ylabel('k_{other} - k_{self}');
title('Vulnerables: k_{other} - k_{self}');

subplot(1,2,2);
histogram(params_V.diff_kother_minus_kself, 15);
xline(mean(params_V.diff_kother_minus_kself), 'r--', 'LineWidth', 2);
xlabel('k_{other} - k_{self}'); ylabel('Frecuencia');
title(sprintf('Media = %.4f, SD = %.4f', mean(params_V.diff_kother_minus_kself), std(params_V.diff_kother_minus_kself)));

sgtitle('Dispersión Vulnerables - Modelo 2K1B');


figure;
subplot(1,2,1);
scatter(1:height(params_V), params_V.diff_kself_minus_kother, 'filled');
hold on;
yline(mean(params_V.diff_kself_minus_kother), 'r--', 'LineWidth', 2);
xlabel('Sujeto'); ylabel('k_{self} - k_{other}');
title('Vulnerables: k_{self} - k_{other}');

subplot(1,2,2);
histogram(params_V.diff_kself_minus_kother, 15);
xline(mean(params_V.diff_kself_minus_kother), 'r--', 'LineWidth', 2);
xlabel('k_{self} - k_{other}'); ylabel('Frecuencia');
title(sprintf('Media = %.4f, SD = %.4f', mean(params_V.diff_kself_minus_kother), std(params_V.diff_kself_minus_kother)));

sgtitle('Dispersión Vulnerables - Modelo 2K1B');


% Save data
writetable(params_NV, 'params_NV.csv');
writetable(params_V, 'params_V.csv');



%% 4) wilcoxon rank entre vulnerable y no vulnerable

% Importar datos
% params_NV = readtable('params_NV.csv');
% params_V = readtable('params_V.csv');

% Variables a comparar
variables = {'k_self_2K1B', 'k_other_2K1B', 'beta_2K1B', 'diff_kother_minus_kself'};
p_values = zeros(1,4);

for i = 1:length(variables)
    [p_values(i), ~, ~] = ranksum(params_NV.(variables{i}), params_V.(variables{i}));
end

% Boxplot comparativo
figure;
colors = [0.4 0.7 0.9; 0.9 0.5 0.4]; % Azul NV, Rojo V

for i = 1:length(variables)
    subplot(2,2,i);
    data = [params_NV.(variables{i}); params_V.(variables{i})];
    group = [ones(height(params_NV),1); 2*ones(height(params_V),1)];
    
    boxplot(data, group, 'Labels', {'NV', 'V'}, 'Colors', 'k', 'Symbol', 'o');
    h = findobj(gca, 'Tag', 'Box');
    for j = 1:length(h)
        patch(get(h(j), 'XData'), get(h(j), 'YData'), colors(j,:), 'FaceAlpha', 0.6);
    end
    
    ylabel(strrep(variables{i}, '_', '\_'));
    set(gca, 'FontSize', 10, 'Box', 'off');
    
    if p_values(i) < 0.05
        title(sprintf('p = %.4f *', p_values(i)));
    else
        title(sprintf('p = %.4f', p_values(i)));
    end
end




%% 5) Set de datos totales con grupo incluido

% Merge params_NV y params_V con identificador de grupo
params_NV.grupo = repmat({'No_Vulnerable'}, height(params_NV), 1);
params_V.grupo = repmat({'Vulnerable'}, height(params_V), 1);

params_all = [params_NV; params_V];
writetable(params_all, 'params_all.csv');






%% 6) ANOVA

params_all = readtable('C:\Users\yangy\Desktop\Comp_Models_Seba\params_all.csv');

% Visualización ANOVA

% Calcular medias y SEM por grupo
grupos = {'No_Vulnerable', 'Vulnerable'};
medias = zeros(2,2); sem = zeros(2,2);

for g = 1:2
    idx = strcmp(params_all.grupo, grupos{g});
    medias(g,:) = [mean(params_all.k_self_2K1B(idx)), mean(params_all.k_other_2K1B(idx))];
    n = sum(idx);
    sem(g,:) = [std(params_all.k_self_2K1B(idx))/sqrt(n), std(params_all.k_other_2K1B(idx))/sqrt(n)];
end

% Gráfico de interacción
figure;
b = bar(medias, 'grouped'); hold on;
b(1).FaceColor = [0.3 0.6 0.8]; b(2).FaceColor = [0.9 0.4 0.3];

% Barras de error
x = [b(1).XEndPoints; b(2).XEndPoints];
errorbar(x', medias, sem, 'k', 'LineStyle', 'none', 'LineWidth', 1.5);

set(gca, 'XTickLabel', {'No Vulnerable', 'Vulnerable'}, 'FontSize', 12);
ylabel('k (effort discounting)'); legend({'k_{self}', 'k_{other}'}, 'Location', 'best');
title('Interacción Grupo × Agente');


%% Visualización estilo Lockwood et al. (2021) - Fig 2C

figure('Position', [100 100 500 400]);

% Datos
k_self_all = params_all.k_self_2K1B;
k_other_all = params_all.k_other_2K1B;
grupo = params_all.grupo;
idx_NV = strcmp(grupo, 'No_Vulnerable');
idx_V = strcmp(grupo, 'Vulnerable');

% P-values
p_values(1) = ranksum(k_self_all(idx_NV), k_self_all(idx_V));
p_values(2) = ranksum(k_other_all(idx_NV), k_other_all(idx_V));
p_values(3) = signrank(k_self_all, k_other_all);

% Medias y SEM
medias = [mean(k_self_all(idx_NV)), mean(k_self_all(idx_V)); ...
          mean(k_other_all(idx_NV)), mean(k_other_all(idx_V))];
sems = [std(k_self_all(idx_NV))/sqrt(sum(idx_NV)), std(k_self_all(idx_V))/sqrt(sum(idx_V)); ...
        std(k_other_all(idx_NV))/sqrt(sum(idx_NV)), std(k_other_all(idx_V))/sqrt(sum(idx_V))];

% Barras
b = bar(medias, 'grouped', 'EdgeColor', 'k', 'LineWidth', 1); hold on;
b(1).FaceColor = [0.85 0.32 0.31]; % Rojo NV (Self)
b(2).FaceColor = [1 0.6 0.6];      % Rojo claro V (Self)

% Cambiar colores Other (azul)
b(1).FaceColor = 'flat'; b(2).FaceColor = 'flat';
b(1).CData = [0.85 0.32 0.31; 0.2 0.4 0.8];  % Fila1=Self rojo, Fila2=Other azul oscuro
b(2).CData = [1 0.6 0.6; 0.6 0.8 1];          % Fila1=Self rojo claro, Fila2=Other azul claro

% Barras de error
x = [b(1).XEndPoints; b(2).XEndPoints];
errorbar(x', medias, sems, 'k', 'LineStyle', 'none', 'LineWidth', 1.5, 'CapSize', 6);

% Puntos individuales (solo dispersión vertical, posición X fija)
scatter(ones(sum(idx_NV),1)*x(1,1), k_self_all(idx_NV), 15, [0.5 0.5 0.5], 'filled', 'MarkerFaceAlpha', 0.5);
scatter(ones(sum(idx_V),1)*x(2,1), k_self_all(idx_V), 15, [0.5 0.5 0.5], 'filled', 'MarkerFaceAlpha', 0.5);
scatter(ones(sum(idx_NV),1)*x(1,2), k_other_all(idx_NV), 15, [0.5 0.5 0.5], 'filled', 'MarkerFaceAlpha', 0.5);
scatter(ones(sum(idx_V),1)*x(2,2), k_other_all(idx_V), 15, [0.5 0.5 0.5], 'filled', 'MarkerFaceAlpha', 0.5);

% Ejes
set(gca, 'XTick', [1 2], 'XTickLabel', {'Self', 'Other'}, 'FontSize', 12, 'Box', 'off');
ylabel('Discount Rate (k)'); ylim([0 max(k_other_all)*1.3]);

% Leyenda manual
legend({'No Vulnerable', 'Vulnerable'}, 'Location', 'northeast', 'Box', 'off');

% Significancias
y_max = max(k_other_all) * 1.1;
if p_values(1) < 0.05
    plot([x(1,1) x(2,1)], [y_max*0.55 y_max*0.55], 'k-', 'LineWidth', 1, 'HandleVisibility', 'off');
    text(1, y_max*0.57, '*', 'HorizontalAlignment', 'center', 'FontSize', 14);
end
if p_values(2) < 0.05
    plot([x(1,2) x(2,2)], [y_max*0.95 y_max*0.95], 'k-', 'LineWidth', 1, 'HandleVisibility', 'off');
    text(2, y_max*0.97, '*', 'HorizontalAlignment', 'center', 'FontSize', 14);
end
if p_values(3) < 0.05
    plot([1 2], [y_max*1.1 y_max*1.1], 'k-', 'LineWidth', 1, 'HandleVisibility', 'off');
    text(1.5, y_max*1.12, '*', 'HorizontalAlignment', 'center', 'FontSize', 14);
end

% Leyenda manual con cuadrados divididos
legend('off');

% Posición leyenda (ajustar según tu figura)
lx = 0.75; ly = 0.85; sz = 0.04;

% Cuadrado 1: Colores oscuros (Vulnerable)
annotation('textbox', [lx ly sz sz], 'String', '', 'BackgroundColor', [0.85 0.32 0.31], 'EdgeColor', 'k');
annotation('textbox', [lx+sz*0.5 ly sz*0.5 sz], 'String', '', 'BackgroundColor', [0.2 0.4 0.8], 'EdgeColor', 'none');
annotation('textbox', [lx+sz+0.01 ly sz*3 sz], 'String', 'Vulnerable', 'EdgeColor', 'none', 'FontSize', 10);

% Cuadrado 2: Colores claros (No Vulnerable)
annotation('textbox', [lx ly-sz-0.02 sz sz], 'String', '', 'BackgroundColor', [1 0.6 0.6], 'EdgeColor', 'k');
annotation('textbox', [lx+sz*0.5 ly-sz-0.02 sz*0.5 sz], 'String', '', 'BackgroundColor', [0.6 0.8 1], 'EdgeColor', 'none');
annotation('textbox', [lx+sz+0.01 ly-sz-0.02 sz*3 sz], 'String', 'No Vulnerable', 'EdgeColor', 'none', 'FontSize', 10);