#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jul  9 06:30:12 2021

@author: Sarat Moka

Python code for showing the zig-zagging property of exact line search  
using a Rosenbrock function.

"""
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import ticker, cm

# =============================================================================
# Rosenbrock function definition
# =============================================================================
f = lambda t: (1 - t[0])**2 + 100*(t[1] - t[0]**2)**2

# =============================================================================
# Gradient of the Rosenbrock function
# =============================================================================
def grad(t):
    dx = -2*(1 - t[0]) - 4*100*t[0]*(t[1] - (t[0]**2))
    dy = 2*100*(t[1] - (t[0]**2))
    #print('dx, dy', dx, dy)
    return np.array([dx, dy])

# =============================================================================
# Function to get values on the ray 
# =============================================================================
def line(t, d, alpha):
    
    return f(t + alpha*d)

# =============================================================================
# First order derivative with respect to alpha. Needed in line search.
# =============================================================================
def derivative(t, td, alpha):
    gamma = t + alpha*td
    deriv = - 2*td[0]*(1 - gamma[0]) + 200*(gamma[1] - gamma[0]**2)*(td[1] - 2*td[0]*gamma[0])

    return deriv

# =============================================================================
# Second order derivative with respect to alpha. Needed in line search.
# =============================================================================
def second_derivative(t, td, alpha):
    
    gamma = t + alpha*td
    
    s_deriv = 2*(td[0]**2) + 200*((td[1] - 2*gamma[0]*td[0])**2 - 2*(td[0]**2)*(gamma[1] - gamma[0]**2))
    
    return s_deriv

# =============================================================================
# Newton's method for finding an optimal alpha
# =============================================================================
def newton_method(t, td, alpha_init, niter):
    
    alpha = alpha_init
    
    for _ in range(niter):
        deriv = derivative(t, td, alpha)
        s_deriv = second_derivative(t, td, alpha)
    
        d = - deriv/s_deriv         
        alpha = alpha + d
       
    return alpha


# =============================================================================
# Gradient descent algorithm with exact line search in each iteration
# =============================================================================
def LineSearchGradientDescent(t, alpha_init, niter):
    
    t_seq = [t]
    td_seq = []

    for _ in range(niter):
        
        g = grad(t)
        #norm = np.linalg.norm(g)
        td = -g #/norm
        
        # Theta update
        alpha = newton_method(t, td, alpha_init, niter)
        t = t + alpha*td
        
        t_seq.append(t)
        td_seq.append(td)
        
    print('Final point of GD:', t)
    t_seq = np.array(t_seq)
    td_seq = np.array(td_seq)
    return t_seq, td_seq

#%%
# =============================================================================
# Run this cell for calling the gradient descent algorithm 
# with exact line search in each iteration
# =============================================================================
alpha_init = 0 # Initial alpha
t_init = np.array([0.4, -0.2]) # initial point
niter = 1000 # no of iteration

t_seq_gd, td_seq_gd = LineSearchGradientDescent(t_init, alpha_init, niter)


#%%
# =============================================================================
# Run this cell for plotting. Zoom in to see the zig-zagging property.
# =============================================================================
t1_range = np.arange(-0.3, 1.1, 0.001)
t2_range = np.arange(-0.3, 1.1, 0.001)

A = np.meshgrid(t1_range, t2_range)
Z = f(A)
plt.contour(t1_range, t2_range, Z, levels=np.exp(np.arange(-15, 7, 0.2)), locator=ticker.LogLocator(), cmap=cm.PuBu_r, linewidths=3)

plt.plot(t_seq_gd[:, 0], t_seq_gd[:, 1], '-g', linewidth=2.5)


plt.plot(1, 1, 'o')
plt.text(1-0.4,1, 'Optimal point', fontsize=25)
plt.plot(t_init[0], t_init[1], 'o', color='black')
plt.text(t_init[0]+0.02,t_init[1]-0.02, 'Initial point', fontsize=25)

plt.xlabel(r'$\theta_1$', fontsize=25)
plt.ylabel(r'$\theta_2$', fontsize=25)
#plt.legend(fontsize=20)
plt.rcParams["figure.figsize"] = (10,10)
plt.show()

