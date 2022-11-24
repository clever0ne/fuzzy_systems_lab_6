function fis = update_fis_params(fis, params, scale)
    if (nargin < 3 || isempty(scale) == true)
        scale = ones(1, length(params));
    end

    params = params ./ scale;

    fis.input(1).mf(1).params(1) = params(1);
    fis.input(1).mf(2).params(1) = params(2);
    fis.input(1).mf(3).params(1) = params(3);	
    fis.input(1).mf(4).params(1) = params(2);
    fis.input(1).mf(5).params(1) = params(1);

    fis.input(1).mf(2).params(2) = pi / 2 - params(4);
    fis.input(1).mf(4).params(2) = pi / 2 + params(4);

    fis.input(2).mf(1).params(1) = params(5);
    fis.input(2).mf(2).params(1) = params(6);
    fis.input(2).mf(3).params(1) = params(7);
    fis.input(2).mf(4).params(1) = params(6);
    fis.input(2).mf(5).params(1) = params(5);

    fis.input(2).mf(2).params(2) = 0 - params(8);
    fis.input(2).mf(4).params(2) = 0 + params(8);

    fis.output.mf(1).params(1) = params(9);
    fis.output.mf(2).params(1) = params(10);
    fis.output.mf(3).params(1) = params(11);
    fis.output.mf(5).params(1) = params(12);
     
    fis.output.mf(2).params(2) = params(13);
    fis.output.mf(3).params(2) = params(14);

    fis.rule(1).weight  = params(15);
    fis.rule(2).weight  = params(16);
    fis.rule(3).weight  = params(16);
    fis.rule(4).weight  = params(17);
    fis.rule(5).weight  = params(17);
    fis.rule(6).weight  = params(18);
    fis.rule(7).weight  = params(18);
    fis.rule(8).weight  = params(19);
    fis.rule(9).weight  = params(19);
    fis.rule(10).weight = params(20);
    fis.rule(11).weight = params(20);
    fis.rule(12).weight = params(21);
    fis.rule(13).weight = params(21);
end
