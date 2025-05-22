% simple_dsge.m
% A simple DSGE model in Octave that incorporates an immigration shock.
% This model includes:
%   - NKPC: ?_t = ? * ?_{t+1} + ? * x_t
%   - IS curve: x_t = x_{t+1} - ? * (i - ?_{t+1} - r_nat)
% where r_nat = r_bar - ? * (immigration shock)

% Load the optim package if it's not already loaded
pkg load optim;

% Clear workspace and close figures
clear; close all; clc;

%% 1. Set Up Model Parameters
beta  = 0.99;      % Discount factor
sigma = 1.0;       % Intertemporal elasticity of substitution
kappa = 0.5;       % Slope of the New Keynesian Phillips Curve
r_bar = 0.02;      % Baseline natural rate of interest
alpha = 0.1;       % Parameter linking the immigration shock to the natural rate

% Time horizon for simulation
T = 20;

% Define an immigration shock (one-time shock in period 6)
immigration_shocks = zeros(T, 1);
immigration_shocks(6) = 1.0;

% Assume a constant nominal interest rate for simplicity
i = 0.05;

% Preallocate arrays for inflation (pi) and the output gap (x)
% We simulate from t = 0 to T (T+1 periods)
pi_path = zeros(T+1, 1);
x_path  = zeros(T+1, 1);

% Terminal condition (steady state): assume ? = 0 and x = 0 in period T+1
pi_path(T+1) = 0;
x_path(T+1)  = 0;

%% 2. Define the Model Equations
% The system of equations for period t:
%   1) NKPC: ?_t - [? * ?_{t+1} + ? * x_t] = 0
%   2) IS curve: x_t - [x_{t+1} - ? * (i - ?_{t+1} - (r_bar - ?*immigration_shock))] = 0
model_eq = @(vars, pi_next, x_next, i, imm_shock) [
  vars(1) - (beta * pi_next + kappa * vars(2));  
  vars(2) - (x_next - sigma*(i - pi_next - (r_bar - alpha*imm_shock)))
];

% Set options for fsolve (suppressing output)
options = optimset('Display', 'off');

%% 3. Backward Induction to Solve the Model
% We solve for ?_t and x_t from period T down to 1 using fsolve.
for t = T:-1:1
    % Create a function handle for period t using the known values for period t+1
    fun = @(vars) model_eq(vars, pi_path(t+1), x_path(t+1), i, immigration_shocks(t));
    % Use an initial guess (here, [0; 0])
    initial_guess = [0; 0];
    sol = fsolve(fun, initial_guess, options);
    % Save the solved values for the current period
    pi_path(t) = sol(1);
    x_path(t)  = sol(2);
end

%% 4. Plot the Impulse Responses
time = 0:T;  % Time vector

figure;
plot(time, pi_path, 'bo-', 'LineWidth', 2); hold on;
plot(time, x_path, 'rx-'
