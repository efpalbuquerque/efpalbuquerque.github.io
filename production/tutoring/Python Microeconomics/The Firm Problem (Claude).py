import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from scipy.optimize import minimize
import matplotlib.cm as cm
from matplotlib.colors import Normalize

# Define the firm's production function (Cobb-Douglas)
def production_function(inputs, A, alpha, beta):
    L, K = inputs
    return A * (L ** alpha) * (K ** beta)

# Define the cost function
def cost_function(inputs, w, r):
    L, K = inputs
    return w * L + r * K

# Define the constrained optimization problem
def objective(inputs, w, r):
    return cost_function(inputs, w, r)

def constraint(inputs, A, alpha, beta, Q0):
    return production_function(inputs, A, alpha, beta) - Q0

# Parameters
w = 10      # wage rate
r = 5       # rental rate of capital
A = 1       # productivity parameter
alpha = 0.6  # labor share
beta = 0.4   # capital share
Q0 = 100     # required output level

# Initial guess
initial_guess = [10, 10]

# Define the constraint dictionary
con = {'type': 'eq', 'fun': constraint, 'args': (A, alpha, beta, Q0)}

# Solve the optimization problem
result = minimize(objective, initial_guess, args=(w, r), constraints=con, method='SLSQP')

# Optimal values
optimal_L, optimal_K = result.x
optimal_cost = cost_function([optimal_L, optimal_K], w, r)

print(f"Optimal Labor (L): {optimal_L:.4f}")
print(f"Optimal Capital (K): {optimal_K:.4f}")
print(f"Minimized Cost: {optimal_cost:.4f}")

# Analytical solution for Cobb-Douglas production function
def analytical_solution(w, r, A, alpha, beta, Q0):
    # Conditional factor demands
    L = (Q0/A)**(1/(alpha+beta)) * (alpha/w)**(beta/(alpha+beta)) * (beta/r)**(-alpha/(alpha+beta))
    K = (Q0/A)**(1/(alpha+beta)) * (alpha/w)**(-beta/(alpha+beta)) * (beta/r)**(alpha/(alpha+beta))
    return L, K

analytical_L, analytical_K = analytical_solution(w, r, A, alpha, beta, Q0)
analytical_cost = cost_function([analytical_L, analytical_K], w, r)

print("\nAnalytical Solution:")
print(f"Optimal Labor (L): {analytical_L:.4f}")
print(f"Optimal Capital (K): {analytical_K:.4f}")
print(f"Minimized Cost: {analytical_cost:.4f}")

# Function to generate points on an isoquant curve
def isoquant(L, A, alpha, beta, Q):
    return (Q / (A * (L ** alpha))) ** (1 / beta)

# Function to generate points on an isocost curve
def isocost(L, w, r, C):
    return (C - w * L) / r

# Set up the plotting range
L_range = np.linspace(0.1, optimal_L * 2, 1000)
K_range = np.linspace(0.1, optimal_K * 2, 1000)
L_grid, K_grid = np.meshgrid(L_range, K_range)

# Calculate production values over the grid
Z = A * (L_grid ** alpha) * (K_grid ** beta)

# Create figure for multiple plots
plt.figure(figsize=(20, 15))

# 1. Isoquant vs Isocost Plot with Equilibrium Point
plt.subplot(2, 3, 1)
plt.title('Cost Minimization: Isoquant and Isocost')
plt.xlabel('Labor (L)')
plt.ylabel('Capital (K)')

# Plot isoquant for Q0
isoquant_curve = [isoquant(l, A, alpha, beta, Q0) for l in L_range]
plt.plot(L_range, isoquant_curve, 'b-', linewidth=2, label=f'Isoquant (Q = {Q0})')

# Plot isocost for optimal cost
isocost_curve = [isocost(l, w, r, optimal_cost) for l in L_range]
plt.plot(L_range, isocost_curve, 'r--', linewidth=2, label=f'Isocost (C = {optimal_cost:.2f})')

# Mark optimal point
plt.plot(optimal_L, optimal_K, 'ro', markersize=8)
plt.text(optimal_L + 1, optimal_K + 1, 'Equilibrium', fontsize=10)

# Set plot range and add legend
plt.xlim(0, optimal_L * 2)
plt.ylim(0, optimal_K * 2)
plt.legend()
plt.grid(True)

# 2. 3D Production Function Plot
ax = plt.subplot(2, 3, 2, projection='3d')
ax.set_title('Cobb-Douglas Production Function')
ax.set_xlabel('Labor (L)')
ax.set_ylabel('Capital (K)')
ax.set_zlabel('Output (Q)')

# Plot the production function surface
surf = ax.plot_surface(L_grid, K_grid, Z, cmap=cm.viridis, alpha=0.7, linewidth=0)

# Mark the optimal point on the 3D surface
ax.scatter([optimal_L], [optimal_K], [Q0], color='red', s=50, marker='o')

# 3. Combined Plot: Isoquants and Optimal Isocost Line
plt.subplot(2, 3, 3)
plt.title('Cost Minimization: Isoquants and Optimal Isocost Line')
plt.xlabel('Labor (L)')
plt.ylabel('Capital (K)')

# Plot multiple isoquants
for q in [Q0*0.7, Q0*0.85, Q0, Q0*1.15, Q0*1.3]:
    isoquant_curve = [isoquant(l, A, alpha, beta, q) for l in L_range]
    plt.plot(L_range, isoquant_curve, 'b-', linewidth=1)
    # Label the isoquant
    idx = len(L_range) // 3
    plt.text(L_range[idx], isoquant_curve[idx], f'Q={q:.1f}', fontsize=8, color='blue')

# Plot the optimal isocost line
plt.plot(L_range, isocost_curve, 'r--', linewidth=2, label=f'Isocost (C = {optimal_cost:.2f})')

# Mark optimal point
plt.plot(optimal_L, optimal_K, 'ro', markersize=8)
plt.text(optimal_L + 1, optimal_K + 1, 
         f'Optimal Point\nL = {optimal_L:.2f}\nK = {optimal_K:.2f}\nQ = {Q0}\nCost = {optimal_cost:.2f}', 
         fontsize=8)

# Set plot range and add grid
plt.xlim(0, optimal_L * 2)
plt.ylim(0, optimal_K * 2)
plt.grid(True)

# 4. Isoquants Contour Plot
plt.subplot(2, 3, 4)
plt.title('Isoquants at Different Output Levels')
plt.xlabel('Labor (L)')
plt.ylabel('Capital (K)')

# Create contour plot of isoquants
CS = plt.contour(L_grid, K_grid, Z, levels=np.linspace(Q0/2, 1.5*Q0, 10), colors='blue')
plt.clabel(CS, inline=1, fontsize=8)

# Mark optimal point
plt.plot(optimal_L, optimal_K, 'ro', markersize=8)
plt.text(optimal_L + 1, optimal_K + 1, 'Optimal Point', fontsize=10)

# Set plot range and add grid
plt.xlim(0, optimal_L * 2)
plt.ylim(0, optimal_K * 2)
plt.grid(True)

# 5. Family of Isocost Lines
plt.subplot(2, 3, 5)
plt.title('Family of Isocost Lines')
plt.xlabel('Labor (L)')
plt.ylabel('Capital (K)')

# Plot multiple isocost lines
for c_factor in [0.7, 0.85, 1, 1.15, 1.3]:
    cost = optimal_cost * c_factor
    isocost_curve = [isocost(l, w, r, cost) for l in L_range]
    
    if c_factor == 1:
        plt.plot(L_range, isocost_curve, 'r-', linewidth=2, label=f'C = {cost:.2f}')
    else:
        plt.plot(L_range, isocost_curve, 'r--', linewidth=1, alpha=0.5, label=f'C = {cost:.2f}')

# Mark optimal point
plt.plot(optimal_L, optimal_K, 'ro', markersize=8)

# Set plot range, add legend and grid
plt.xlim(0, optimal_L * 2)
plt.ylim(0, optimal_K * 2)
plt.legend(fontsize=8)
plt.grid(True)

# 6. Expansion Path Plot
plt.subplot(2, 3, 6)
plt.title('Expansion Path')
plt.xlabel('Labor (L)')
plt.ylabel('Capital (K)')

# Calculate expansion path for different output levels
Q_levels = np.linspace(Q0/5, Q0*2, 20)
L_path = []
K_path = []

for q in Q_levels:
    L, K = analytical_solution(w, r, A, alpha, beta, q)
    L_path.append(L)
    K_path.append(K)

# Plot expansion path
plt.plot(L_path, K_path, 'r-', linewidth=2)

# Add points along the path
plt.scatter(L_path[::2], K_path[::2], color='red', s=30)

# Mark optimal point
plt.plot(optimal_L, optimal_K, 'ro', markersize=8)
plt.text(optimal_L + 1, optimal_K + 1, 'Optimal Point', fontsize=10)

# Add labels for the start and end points
plt.text(L_path[0], K_path[0], f'Q = {Q_levels[0]:.2f}', fontsize=8)
plt.text(L_path[-1], K_path[-1], f'Q = {Q_levels[-1]:.2f}', fontsize=8)

# Set plot range and add grid
plt.xlim(0, max(L_path) * 1.1)
plt.ylim(0, max(K_path) * 1.1)
plt.grid(True)

# Adjust layout
plt.tight_layout()
plt.savefig('cost_minimization_plots.png', dpi=300)
plt.show()

# Bonus: Create a single plot showing all key elements of cost minimization
plt.figure(figsize=(10, 8))
plt.title('Cost Minimization Analysis')
plt.xlabel('Labor (L)')
plt.ylabel('Capital (K)')

# Plot isoquants
CS = plt.contour(L_grid, K_grid, Z, levels=np.linspace(Q0*0.7, Q0*1.3, 5), colors='blue', alpha=0.7)
plt.clabel(CS, inline=1, fontsize=8)

# Plot optimal isocost line
isocost_curve = [isocost(l, w, r, optimal_cost) for l in L_range]
plt.plot(L_range, isocost_curve, 'r--', linewidth=2, label=f'Isocost (C = {optimal_cost:.2f})')

# Plot expansion path
plt.plot(L_path, K_path, 'g-', linewidth=2, label='Expansion Path')

# Mark optimal point
plt.plot(optimal_L, optimal_K, 'ro', markersize=10, label='Optimal Point')
plt.text(optimal_L + 1, optimal_K + 1, 
         f'L = {optimal_L:.2f}\nK = {optimal_K:.2f}\nQ = {Q0}\nC = {optimal_cost:.2f}', 
         fontsize=10)

# Set plot range, add legend and grid
plt.xlim(0, optimal_L * 2)
plt.ylim(0, optimal_K * 2)
plt.legend()
plt.grid(True)

plt.tight_layout()
plt.savefig('cost_minimization_summary.png', dpi=300)
plt.show()