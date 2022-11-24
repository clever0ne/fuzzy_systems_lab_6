function print_surface_plot(x1, x2, y, plotname, filename, rmse)
    if (nargin < 6)
        rmse = 0;
    end

    figure('Name', plotname);
    surf(x1, x2, y);
    
    xticks(linspace(x1(1), x1(end), 5));
    yticks(linspace(x2(1), x2(end), 5));
    axis([x1(1), x1(end), x2(1), x2(end), min(min(min(y)), 0), 1]);
    
    set(gca, 'XTickLabel', { '0'; '\pi/4'; '\pi/2'; '3\pi/4'; '\pi' });
    set(gca, 'FontName', 'Euclid', 'FontSize', 12);

    xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', 12);
    ylabel('$x_2$', 'Interpreter', 'latex', 'FontSize', 12);
    zlabel('$y$',   'Interpreter', 'latex', 'FontSize', 12);

    if (rmse == 0)
        title('$y = {\rm sin}^2(x_1 - 2 x_2) \cdot e^{-|x_2|}$', 'Interpreter', 'latex');
    else
        if (isempty(plotname) == true)
            title('$\hat y = {\rm FIS}(x_1, x_2)$', 'Interpreter', 'latex');
        else
            title(plotname, 'Interpreter', 'latex');
        end
        text(0, 0.8, 0.8, ['${\rm RMSE} = ', num2str(rmse, '%.4f'), '$'], ...
             'Interpreter', 'latex', 'FontName', 'Euclid', 'FontSize', 12);
    end
    
    if (~exist('../../graphs', 'dir'))
        mkdir('../../graphs');
    end

    print(['../../graphs/', filename], '-dmeta', '-r0');
end