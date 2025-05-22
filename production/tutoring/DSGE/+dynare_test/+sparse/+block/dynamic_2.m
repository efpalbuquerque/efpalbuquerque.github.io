function [y, T, residual, g1] = dynamic_2(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(2, 1);
  T(1)=exp(y(8));
  y(7)=T(1)*y(5)^params(2);
  residual(1)=(y(6)+y(9))-(y(7)+y(5)*(1-params(3)));
  T(2)=params(2)*exp(y(12));
  T(3)=1+T(2)*y(9)^(params(2)-1)-params(3);
  residual(2)=(1/y(6))-(params(1)*1/y(10)*T(3));
if nargout > 3
    g1_v = NaN(3, 1);
g1_v(1)=(-(1-params(3)+T(1)*getPowerDeriv(y(5),params(2),1)));
g1_v(2)=1;
g1_v(3)=(-1)/(y(6)*y(6));
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 2, 2);
end
end
