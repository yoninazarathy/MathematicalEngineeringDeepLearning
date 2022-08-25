#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jul  9 06:30:12 2021

@author: Sarat Moka

Python code for generating contour plots to show the progress
of the gradient descent algorithm in two cases: one with fixed alpha 
and the other one with a time varying alpha.

"""

import numpy as np
import matplotlib.pyplot as plt
from matplotlib import ticker, cm

textsize = 15

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

    return np.array([dx, dy])

# =============================================================================
# Gradient descent algorithm
# =============================================================================
def GradientDescent(f, grad, t, alpha, gamma, niter):

    
    t_seq = [t]
    d_seq = []

    for _ in range(niter):
        g = grad(t)
        # norm = np.linalg.norm(g)
        # d = -g/norm         
        d = -g 

        
        # Theta update
        t = t + alpha*d
        
        alpha *= gamma
        t_seq.append(t)
        d_seq.append(d)
        
    print('Final point of GD:', t)
    t_seq = np.array(t_seq)
    d_seq = np.array(d_seq)
    return t_seq, d_seq


#%%

# =============================================================================
# This cell producces the desired outputs.
# =============================================================================

t_init = np.array([0.2, -0.2]) # initial point
niter = 100000 # no of iteration


t1_range = np.arange(-0.3, 1.1, 0.01)
t2_range = np.arange(-0.3, 1.1, 0.01)


A = np.meshgrid(t1_range, t2_range)
Z = f(A)
plt.contour(t1_range, t2_range, Z, levels=np.exp(np.arange(-15, 7, 0.2)), locator=ticker.LogLocator(), cmap=cm.PuBu_r, linewidths=3)


# =============================================================================
# Select one the following two options for gamma. 
# Note that alpha_t = alpha_init * gamma^t.
# =============================================================================
gamma = 1
gamma = 0.99


alpha_init = 0.005 # Initial alpha
t_seq_gd, d_seq_gd = GradientDescent(f, grad, t_init, alpha_init, gamma, niter)
plt.plot(t_seq_gd[:, 0], t_seq_gd[:, 1], '-g', linewidth=2.5, label=r'$\alpha = %s$' %alpha_init, alpha = 0.6)


alpha_init = alpha_init/2
t_seq_gd, d_seq_gd = GradientDescent(f, grad, t_init, alpha_init, gamma, niter)
plt.plot(t_seq_gd[:, 0], t_seq_gd[:, 1], '-b', linewidth=2.5, label=r'$\alpha = %s$' %alpha_init, alpha = 0.6)


# =============================================================================
# Plotting execution paths.
# =============================================================================
plt.plot(1, 1, 'o')
plt.text(1-0.4, 1+0.025, 'Optimal point', fontsize=textsize)
plt.plot(t_init[0], t_init[1], 'o', color='black', zorder=2)
plt.text(t_init[0]+0.05, t_init[1], r'Initial point $\theta^{(0)}$', fontsize=textsize)

plt.xlabel(r'$\theta_1$', fontsize=textsize)
plt.ylabel(r'$\theta_2$', fontsize=textsize)
plt.legend(fontsize=textsize)
plt.rcParams["figure.figsize"] = (6,6)
plt.show()

