
# %%
import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp

### Linear Supply and Demand Equilibrium

# Define parameters

a = 1.0      # Base labor supply intercept
b = 0.5      # Sensitivity of supply to wage
c = 10.0     # Base labor demand intercept
d = 0.4      # Sensitivity of demand to wage
k = 0.1      # Speed of wage adjustment


# Compute equilibrium wage
equilibriumW = (c - a) / (b + d)
equilibriumW

# Define the derivative function for wage dynamics
def wage_dynamics(t, W):
    return k * ((c - d * W) - (a + b * W))

# Time span and initial condition
t_span = (0, 50)
W0 = [0.5 * equilibriumW]  # starting below equilibrium
W0

# Solve the differential equation
sol = solve_ivp(wage_dynamics, t_span, W0, dense_output=True)

# Generate time points for plotting
t = np.linspace(t_span[0], t_span[1], 400)
W = sol.sol(t)[0]

# Plotting the wage dynamics
plt.figure(figsize=(8, 5))
plt.plot(t, W, label='Wage W(t)')
plt.axhline(equilibriumW, color='red', linestyle='--', label='Equilibrium Wage')
plt.xlabel('Time')
plt.ylabel('Wage')
plt.title('Wage Dynamics Over Time')
plt.legend()
plt.grid(True)
plt.show()

### Unemployment

# Define parameters for unemployment dynamics
delta = 0.05   # Job separation rate
mu = 0.1       # Job finding rate

# Calculate steady-state unemployment rate
equilibriumU = delta / (delta + mu)

# Define the derivative function for unemployment dynamics
def unemployment_dynamics(t, U):
    return delta * (1 - U) - mu * U

# Time span and initial condition
t_span2 = (0, 100)
U0 = [0.2]  # initial unemployment rate

# Solve the differential equation for unemployment dynamics
sol2 = solve_ivp(unemployment_dynamics, t_span2, U0, dense_output=True)

# Generate time points for plotting
t2 = np.linspace(t_span2[0], t_span2[1], 400)
U = sol2.sol(t2)[0]

# Plotting the unemployment dynamics
plt.figure(figsize=(8, 5))
plt.plot(t2, U, label='Unemployment Rate U(t)')
plt.axhline(equilibriumU, color='red', linestyle='--', label='Steady-State U')
plt.xlabel('Time')
plt.ylabel('Unemployment Rate')
plt.title('Unemployment Dynamics Over Time')
plt.legend()
plt.grid(True)
plt.show()


##### Alternative Plots


# similar to ggplot2
import pandas as pd
from plotnine import ggplot, aes, geom_line, geom_hline, labs, theme_minimal

# Create a DataFrame from your simulation data
data = pd.DataFrame({'Time': t, 'Wage': W})

# Create the ggplot-like plot
plot = (ggplot(data, aes(x='Time', y='Wage'))
        + geom_line(color='blue')
        + geom_hline(yintercept=equilibriumW, linetype='dashed', color='red')
        + labs(title='Wage Dynamics Over Time', x='Time', y='Wage')
        + theme_minimal()
       )

# To display the plot (if you're in a Jupyter Notebook, simply type `plot`)
print(plot)


# Interactive

import ipywidgets as widgets
from ipywidgets import interact

def interactive_wage_dynamics(W0_factor=0.5, k_value=0.1):
    # Update parameters
    W0_initial = [W0_factor * equilibriumW]
    
    def wage_dynamics_interactive(t, W):
        return k_value * ((c - d * W) - (a + b * W))
    
    sol_int = solve_ivp(wage_dynamics_interactive, t_span, W0_initial, dense_output=True)
    t_int = np.linspace(t_span[0], t_span[1], 400)
    W_int = sol_int.sol(t_int)[0]
    
    plt.figure(figsize=(8, 5))
    plt.plot(t_int, W_int, label='Wage W(t)')
    plt.axhline(equilibriumW, color='red', linestyle='--', label='Equilibrium Wage')
    plt.xlabel('Time')
    plt.ylabel('Wage')
    plt.title(f'Interactive Wage Dynamics: W0_factor={W0_factor}, k={k_value}')
    plt.legend()
    plt.grid(True)
    plt.show()

interact(interactive_wage_dynamics, W0_factor=widgets.FloatSlider(min=0.1, max=1.5, step=0.1, value=0.5),
         k_value=widgets.FloatSlider(min=0.01, max=0.5, step=0.01, value=0.1))