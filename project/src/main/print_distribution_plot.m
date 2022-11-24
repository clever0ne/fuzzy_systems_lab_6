function print_distribution_plot(x1, x2, y, plotname, filename)
    figure('Name', plotname);
    plot3(x1, x2, y, 'r.');
    
    xticks(linspace(0, pi, 5));
    yticks(linspace(-1, 1, 5));
    axis([0, pi, -1, 1, 0, 1]);
    grid on;
    
    set(gca, 'XTickLabel', { '0'; '\pi/4'; '\pi/2'; '3\pi/4'; '\pi' });
    set(gca, 'FontName', 'Euclid', 'FontSize', 12);

    title(plotname, 'Interpreter', 'latex')
    xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', 12);
    ylabel('$x_2$', 'Interpreter', 'latex', 'FontSize', 12);
    zlabel('$y$',   'Interpreter', 'latex', 'FontSize', 12);
    
    if (~exist('../../graphs', 'dir'))
        mkdir('../../graphs');
    end

    print(['../../graphs/', filename], '-dmeta', '-r0');
end