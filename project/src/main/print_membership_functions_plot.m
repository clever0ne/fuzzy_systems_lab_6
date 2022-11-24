function print_membership_functions_plot(var, range, count, type, plotname, filename)
    if (count ~= 3 && count~= 5 && count ~= 7)
        return;
    end

    tmin = min(min(range));
    tmax = max(max(range));

    n = 100;
    t = linspace(tmin, tmax, n * (count - 1) + 1);
    v = zeros(count, length(t));

    switch type
        case 'trimf'
            l = [zeros(1, n * (count - 2)), linspace(0, 1, n + 1)];
            r = [linspace(1, 0, n + 1), zeros(1, n * (count - 2))];
        case 'gaussmf'
            m = -n^2 / log(0.5) / 4;
            l = exp(-(n * (count - 1) :-1 : 0).^2 / m);
            r = exp(-(0 : 1 : n * (count - 1)).^2 / m);
        otherwise
            return;
    end

    for k = 1 : count - 1
        last = k * n + 1;
        first = last - n;
        v(k, first : end)  = r(1 : end - first + 1);
        v(k + 1, 1 : last) = l(end - last + 1 : end);
    end

    figure('Name', plotname);
    color = { '#0072BD', '#D95319', '#EDB120', '#7E2F8E', '#77AC30', '#4DBEEE', '#A2142F' };
    for k = 1 : count
        plot(t, v(k, :), '-', 'Color', color{k});
        hold on;
    end

    axis([tmin, tmax, 0, 1.2])
    xticks(linspace(tmin, tmax, count));
    grid on;

    if (strcmp(var, 'x_1') == true)
        if (count == 3)
            xticklabels({ '0', '\pi/2', '\pi' });
        elseif (count == 5)
            xticklabels({ '0', '\pi/4', '\pi/2', '3\pi/4', '\pi' });
        elseif (count == 7)
            xticklabels({ '0', '\pi/6', '\pi/3', '\pi/2', '2\pi/3', '5\pi/6', '\pi' });
        end
    end

    if (strcmp(var, 'x_2') == true)
        if (count == 3)
            xticklabels({ '-1', '0', '1' });
        elseif (count == 5)
            xticklabels({ '-1', '-1/2', '0', '1/2', '1' });
        elseif (count == 7)
            xticklabels({ '-1', '-2/3', '-1/3', '0', '1/3', '2/3', '1' });
        end
    end

    if (strcmp(var, 'y') == true)
        if (count == 3)
            xticklabels({ '0', '1/2', '1' });
        elseif (count == 5)
            xticklabels({ '0', '1/4', '1/2', '3/4', '1' });
        elseif (count == 7)
            xticklabels({ '0', '1/6', '1/3', '1/2', '2/3', '5/6', '1' });
        end
    end

    if (count == 3)
        legend('negative-middle', 'zero', 'positive-middle', ...
               'Interpreter', 'latex', 'FontSize', 10, 'Location', 'southeast')
    elseif (count == 5)
        legend('negative-big', 'negative-middle', 'zero', 'positive-middle', ...
               'positive-big', 'Interpreter', 'latex', 'FontSize', 10, 'Location', 'southeast')
    elseif (count == 7)
        legend('negative-big', 'negative-middle', 'negative-small', 'zero', 'positive-small', ...
               'positive-middle', 'positive-big', 'Interpreter', 'latex', 'FontSize', 10, 'Location', 'southeast')
    end

    set(gca, 'FontName', 'Euclid', 'FontSize', 12);
    xlabel(['$', var, '$'], 'Interpreter', 'latex', 'FontSize', 12);
    ylabel(['$\mu(', var, ')$'], 'Interpreter', 'latex', 'FontSize', 12);

    if (~exist('../../graphs', 'dir'))
        mkdir('../../graphs');
    end

    print(['../../graphs/', filename], '-dmeta', '-r0');
end