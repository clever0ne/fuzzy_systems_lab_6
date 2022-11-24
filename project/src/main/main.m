clc; clear; close all;

n = 25;
x1_min =  0;
x1_max = pi;
x2_min = -1;
x2_max =  1;
y_min  =  0;
y_max  =  1;

x1 = linspace(x1_min, x1_max, n);
x2 = linspace(x2_min, x2_max, n);
x = reshape(cat(3, repmat(x1, length(x2), 1)', ...
                   repmat(x2, length(x1), 1)), [], 2, 1);

f = @(x1, x2) sin(x1 - 2 * x2).^2 .* exp(-abs(x2));
y = f(x1, x2');
print_surface_plot(x1, x2, y, 'Original Function', 'original_function.emf');

fis1 = readfis('../model/mamdani_gaussmf_5in_gaussmf_5out.fis');

n_train = 1000;
n_test  = 1000;

x1_train = x1_min + (x1_max - x1_min) * rand(n_train, 1)';
x1_test  = x1_min + (x1_max - x1_min) * rand(n_test,  1)';

x2_train = x2_min + (x2_max - x2_min) * rand(n_train, 1)';
x2_test  = x2_min + (x2_max - x2_min) * rand(n_test,  1)';

x_train = [x1_train; x2_train];
x_test  = [x1_test;  x2_test ];

y_train = f(x_train(1, :), x_train(2, :))';
y_test  = f(x_test (1, :), x_test (2, :))';

x1_disp = [fis1.inputs(1).mf(1).params(1);
           fis1.inputs(1).mf(2).params(1);
           fis1.inputs(1).mf(3).params(1)];
x1_mean =  fis1.inputs(1).mf(4).params(2) - mean([x1_min, x1_max]);

x2_disp = [fis1.inputs(2).mf(1).params(1);
           fis1.inputs(2).mf(2).params(1);
           fis1.inputs(2).mf(3).params(1)];
x2_mean =  fis1.inputs(2).mf(4).params(2) - mean([x2_min, x2_max]);

y_disp  = [fis1.outputs.mf(1).params(1);
           fis1.outputs.mf(2).params(1);
           fis1.outputs.mf(3).params(1);
           fis1.outputs.mf(5).params(1)];
y_mean  = [fis1.outputs.mf(2).params(2);
           fis1.outputs.mf(3).params(2)];

x1_disp_lower = 0.3 * x1_disp;
x2_disp_lower = 0.3 * x2_disp;
y_disp_lower  = 0.3 *  y_disp;

x1_disp_upper = 1.3 * x1_disp;
x2_disp_upper = 1.3 * x2_disp;
y_disp_upper  = 1.3 *  y_disp;

x1_mean_lower = x1_mean - 0.3 * (x1_max - x1_min);
x2_mean_lower = x2_mean - 0.3 * (x2_max - x2_min);
y_mean_lower  =  y_mean - 0.3 * ( y_max -  y_min);

x1_mean_upper = x1_mean + 0.3 * (x1_max - x1_min);
x2_mean_upper = x2_mean + 0.3 * (x2_max - x2_min);
y_mean_upper  =  y_mean + 0.3 * ( y_max -  y_min);

w_rule = 0.95 * ones(7, 1);
w_rule_lower = zeros(7, 1);
w_rule_upper = ones(7, 1);

params0 = [x1_disp; x1_mean;
           x2_disp; x2_mean;
            y_disp; y_mean; w_rule]';

lower = [x1_disp_lower; x1_mean_lower;
         x2_disp_lower; x2_mean_lower;
         y_disp_lower; y_mean_lower; w_rule_lower]';

upper = [x1_disp_upper; x1_mean_upper;
         x2_disp_upper; x2_mean_upper;
         y_disp_upper; y_mean_upper; w_rule_upper]';

rmse = @(p, s, fis, x, y) ...
    sqrt(sum(sum((y - evalfis(update_fis_params(fis, p, s), x)).^2)) / numel(y));
options = optimset('Display', 'iter', 'MaxIter', 25);

scale = [1/pi, 1/pi, 1/pi, 1/pi, 1/2, 1/2, 1/2, 1/2, ones(1, 13)];
params = fmincon(rmse, scale .* params0, [], [], [], [], ...
                 scale .* lower, scale .* upper, [], ...
                 options, scale, fis1, x_train, y_train);
fis2 = update_fis_params(fis1, params, scale);

scale = ones(1, 21);
params = fmincon(rmse, scale .* params0, [], [], [], [], ...
                 scale .* lower, scale .* upper, [], ...
                 options, scale, fis1, x_train, y_train);
fis3 = update_fis_params(fis1, params, scale);

y1 = reshape(evalfis(fis1, x), length(x1), length(x2))';
rmse1 = sqrt(sum(sum((y_test - evalfis(fis1, x_test)).^2)) / numel(y_test));
print_surface_plot(x1, x2, y1, 'Mamdani FIS Before Optmization', ...
                   'mamdani_gauss_5in_gauss_5out_surface_default.emf', rmse1);

y2 = reshape(evalfis(fis2, x), length(x1), length(x2))';
rmse2 = sqrt(sum(sum((y_test - evalfis(fis2, x_test)).^2)) / numel(y_test));
print_surface_plot(x1, x2, y2, 'Mamdani FIS After Optmization With Scale', ...
                   'mamdani_gauss_5in_gauss_5out_surface_custom.emf', rmse2);

y3 = reshape(evalfis(fis3, x), length(x1), length(x2))';
rmse3 = sqrt(sum(sum((y_test - evalfis(fis3, x_test)).^2)) / numel(y_test));
print_surface_plot(x1, x2, y3, 'Mamdani FIS After Optmization Without Scale', ...
                   'mamdani_gauss_5in_gauss_5out_surface_suton_no_scale.emf', rmse3);

% print_surface_plot(x1, x2, y1, '', 'mamdani_5in_5out_surface.emf', rmse1);
% print_membership_functions_plot('x_1', x1, 5, 'gaussmf', 'Gauss MF', 'x1_5in.emf');
% print_membership_functions_plot('x_2', x2, 5, 'gaussmf', 'Gauss MF', 'x2_5in.emf');
% print_membership_functions_plot('y',    y, 5, 'gaussmf', 'Gauss MF', 'y_5out.emf');
