function [residual, T_order, T] = dynamic_resid(y, x, params, steady_state, T_order, T)
if nargin < 6
    T_order = -1;
    T = NaN(3, 1);
end
[T_order, T] = dynare_test.sparse.dynamic_resid_tt(y, x, params, steady_state, T_order, T);
residual = NaN(4, 1);
    residual(1) = (y(7)) - (T(1));
    residual(2) = (y(6)+y(9)) - (y(7)+y(5)*(1-params(3)));
    residual(3) = (1/y(6)) - (params(1)*1/y(10)*T(3));
    residual(4) = (y(8)) - (params(4)*y(4)+x(1));
end
