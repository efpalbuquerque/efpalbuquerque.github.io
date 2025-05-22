function [T_order, T] = static_resid_tt(y, x, params, T_order, T)
if T_order >= 0
    return
end
T_order = 0;
if size(T, 1) < 3
    T = [T; NaN(3 - size(T, 1), 1)];
end
T(1) = exp(y(4))*y(1)^params(2);
T(2) = exp(y(4))*params(2)*y(1)^(params(2)-1);
T(3) = 1+T(2)-params(3);
end
