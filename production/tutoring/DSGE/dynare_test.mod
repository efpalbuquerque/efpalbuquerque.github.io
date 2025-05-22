% rbc.mod
% A simple representative agent neoclassical growth model.
% This model features:
%  - A Cobb-Douglas production function: y = exp(a) * k^alpha
%  - A resource constraint: c + k(+1) = y + (1-delta)*k
%  - An Euler equation from household optimization
%  - A technology shock process

var k, c, y, a;
varexo eps;

parameters beta, alpha, delta, rho, sigma;

% Parameter values
beta  = 0.99;     % Discount factor
alpha = 0.36;     % Capital share in production
delta = 0.025;    % Depreciation rate
rho   = 0.95;     % Persistence of the technology shock
sigma = 0.02;     % Standard deviation of the technology shock

model;
  % Production function
  y = exp(a)*k^alpha;
  
  % Resource constraint
  c + k(+1) = y + (1-delta)*k;
  
  % Euler equation (intertemporal condition)
  1/c = beta*(1/c(+1))*(alpha*exp(a(+1))*k(+1)^(alpha-1) + 1-delta);
  
  % Technology shock process (AR(1))
  a = rho*a(-1) + eps;
end;

initval;
  k = 10;
  c = 1;
  y = exp(0)*k^alpha;
  a = 0;
  eps = 0;
end;

shocks;
  var eps = sigma^2;
end;

steady;
check;
stoch_simul(order=1, irf=20);
