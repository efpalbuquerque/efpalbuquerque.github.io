function residual = static_resid(T, y, x, params, T_flag)
% function residual = static_resid(T, y, x, params, T_flag)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T         [#temp variables by 1]  double   vector of temporary terms to be filled by function
%   y         [M_.endo_nbr by 1]      double   vector of endogenous variables in declaration order
%   x         [M_.exo_nbr by 1]       double   vector of exogenous variables in declaration order
%   params    [M_.param_nbr by 1]     double   vector of parameter values in declaration order
%                                              to evaluate the model
%   T_flag    boolean                 boolean  flag saying whether or not to calculate temporary terms
%
% Output:
%   residual
%

if T_flag
    T = dynare_test.static_resid_tt(T, y, x, params);
end
residual = zeros(4, 1);
    residual(1) = (y(3)) - (T(1));
    residual(2) = (y(1)+y(2)) - (y(3)+y(1)*(1-params(3)));
    residual(3) = (1/y(2)) - (1/y(2)*params(1)*T(3));
    residual(4) = (y(4)) - (y(4)*params(4)+x(1));

end
