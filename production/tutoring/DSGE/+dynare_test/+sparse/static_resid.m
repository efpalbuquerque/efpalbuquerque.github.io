function [residual, T_order, T] = static_resid(y, x, params, T_order, T)
if nargin < 5
    T_order = -1;
    T = NaN(3, 1);
end
[T_order, T] = dynare_test.sparse.static_resid_tt(y, x, params, T_order, T);
residual = NaN(4, 1);
    residual(1) = (y(3)) - (T(1));
    residual(2) = (y(1)+y(2)) - (y(3)+y(1)*(1-params(3)));
    residual(3) = (1/y(2)) - (1/y(2)*params(1)*T(3));
    residual(4) = (y(4)) - (y(4)*params(4)+x(1));
end
