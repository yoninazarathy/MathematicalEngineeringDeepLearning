#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jul  9 06:30:12 2021

@author: Sarat Moka

Python code for showing performance of the gradient descent with momentum 
on a Rosenbrock function.

"""
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import ticker, cm


# =============================================================================
# Rosenbrock function
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
# Gradient descent with momentum
# =============================================================================
def MomentumGradientDescent(f, grad, t, alpha, beta, niter=1000):
    v = np.zeros(t.shape[0])
    t_seq = [t]
    v_seq = [v]
    
    
    #while norm > 10**(-8):
    for _ in range(niter):
        
        g = grad(t)
        #norm = np.linalg.norm(g)
        v = beta*v + (1 - beta)*g#/norm
        v_seq.append(v)
        
        t = t - alpha*v
        t_seq.append(t)
        
    print('Final point of MGD:', t)
    t_seq = np.array(t_seq)
    v_seq = np.array(v_seq)
    return t_seq, v_seq 

#%%
# =============================================================================
# Main code starts here
# =============================================================================

beta = np.array([0.9, 0.5, 0.0])
alpha_init = 0.001/(1 - beta) # Initial alpha
t_init = np.array([0.4, -0.2]) # initial point
niter = 1000 # no of iteration

t1_range = np.arange(-0.3, 1.1, 0.01)
t2_range = np.arange(-0.3, 1.1, 0.01)

A = np.meshgrid(t1_range, t2_range)
Z = f(A)
plt.contour(t1_range, t2_range, Z, levels=np.exp(np.arange(-15, 7, 0.2)), locator=ticker.LogLocator(), cmap=cm.PuBu_r, linewidths=3)


# =============================================================================
# Calling the gradient descent with momentum for three different betas
# =============================================================================
t_seq_mgd, d_seq_mgd = MomentumGradientDescent(f, grad, t_init, alpha_init[0], beta[0], niter)
plt.plot(t_seq_mgd[:, 0], t_seq_mgd[:, 1], '-g', linewidth=2.5, label=r'$\beta = 0.9$ ', alpha=0.6  )

t_seq_mgd, d_seq_mgd = MomentumGradientDescent(f, grad, t_init, alpha_init[1], beta[1], niter)
plt.plot(t_seq_mgd[:, 0], t_seq_mgd[:, 1], '-.b', linewidth=2.5, label=r'$\beta = 0.5$', alpha=0.6 )

t_seq_mgd, d_seq_mgd = MomentumGradientDescent(f, grad, t_init, alpha_init[2], beta[2], niter)
plt.plot(t_seq_mgd[:, 0], t_seq_mgd[:, 1], '--r', linewidth=2.5, label=r'$\beta = 0.0$', alpha=0.6  )


# =============================================================================
# Plotting 
# =============================================================================
plt.plot(1, 1, 'o')
plt.text(1-0.12,1+0.03, 'Optimal point', fontsize=15)
plt.plot(t_init[0], t_init[1], 'o', color='black')
plt.text(t_init[0]+0.02,t_init[1]-0.02, 'Initial point', fontsize=15)

plt.xlabel(r'$\theta_1$', fontsize=20)
plt.ylabel(r'$\theta_2$', fontsize=20)
plt.legend(fontsize=20)
plt.rcParams["figure.figsize"] = (6,6)
plt.show()