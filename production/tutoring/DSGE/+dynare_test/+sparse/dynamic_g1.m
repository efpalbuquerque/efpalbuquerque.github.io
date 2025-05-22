function [g1, T_order, T] = dynamic_g1(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T_order, T)
if nargin < 9
    T_order = -1;
    T = NaN(3, 1);
end
[T_order, T] = dynare_test.sparse.dynamic_g1_tt(y, x, params, steady_state, T_order, T);
g1_v = NaN(14, 1);
g1_v(1)=(-params(4));
g1_v(2)=(-(exp(y(8))*getPowerDeriv(y(5),params(2),1)));
g1_v(3)=(-(1-params(3)));
g1_v(4)=1;
g1_v(5)=(-1)/(y(6)*y(6));
g1_v(6)=1;
g1_v(7)=(-1);
g1_v(8)=(-T(1));
g1_v(9)=1;
g1_v(10)=1;
g1_v(11)=(-(params(1)*1/y(10)*params(2)*exp(y(12))*getPowerDeriv(y(9),params(2)-1,1)));
g1_v(12)=(-(T(3)*params(1)*(-1)/(y(10)*y(10))));
g1_v(13)=(-(params(1)*1/y(10)*T(2)));
g1_v(14)=(-1);
if ~isoctave && matlab_ver_less_than('9.8')
    sparse_rowval = double(sparse_rowval);
    sparse_colval = double(sparse_colval);
end
g1 = sparse(sparse_rowval, sparse_colval, g1_v, 4, 13);
end
