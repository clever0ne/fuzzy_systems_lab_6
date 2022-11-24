function errFISmg = F_errFISmg(param, FISiter, inputFIS, target, Msht)
% Расчет ошибки при новых параметрах (param) нечеткой системы FISiter

% Установка новых параметров нечеткой системы
FISiter = F_changeFISmg(param, FISiter, Msht);

% Нечеткий вывод:
outFIS = evalfis(inputFIS, FISiter);
 
% Расчет ошибки:
errFISmg = sqrt(sum((target-outFIS).^2)/numel(outFIS));	% среднекв.знач.ошибки