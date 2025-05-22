function [y, T, residual, g1] = static_2(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(3, 1);
  residual(1)=(y(1)+y(2))-(y(3)+y(1)*(1-params(3)));
  T(1)=exp(y(4));
  T(2)=1+T(1)*params(2)*y(1)^(params(2)-1)-params(3);
  residual(2)=(1/y(2))-(1/y(2)*params(1)*T(2));
  residual(3)=(y(3))-(T(1)*y(1)^params(2));
if nargout > 3
    g1_v = NaN(7, 1);
g1_v(1)=1;
g1_v(2)=(-1)/(y(2)*y(2))-T(2)*params(1)*(-1)/(y(2)*y(2));
g1_v(3)=1-(1-params(3));
g1_v(4)=(-(1/y(2)*params(1)*T(1)*params(2)*getPowerDeriv(y(1),params(2)-1,1)));
g1_v(5)=(-(T(1)*getPowerDeriv(y(1),params(2),1)));
g1_v(6)=(-1);
g1_v(7)=1;
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 3, 3);
end
end
