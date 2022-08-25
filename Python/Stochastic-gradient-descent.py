#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jul  5 10:45:34 2021

@author: Sarat Moka

Python code for generating contour plots to show the progress
of the gradient descent and the stochastic gradient descent algorithms
for two hypothetical example functions.

"""

import numpy as np
import matplotlib.pyplot as plt
from shapely.geometry import Polygon
from descartes.patch import PolygonPatch

textsize = 15

#%%
# =============================================================================
# Function definitions
# =============================================================================
def C(i, tht):
    
    return c[i]*(tht[0] - X[i][0])**2 + (tht[1] - X[i][1])**2

def Cost(tht):
    n = X.shape[0]
    
    cost_ = 0
    for i in range(n):
        cost_ += C(i, tht)
    return cost_/n

def grad_C(i, tht):

    return np.array([2*c[i]*(tht[0] - X[i][0]), 2*(tht[1] - X[i][1])])

def grad_Cost(tht):
    n = X.shape[0]
    gC = np.zeros(X.shape[1])

    for i in range(n):
        gC = np.add(gC, grad_C(i, tht))
    
    return gC/n

# =============================================================================
# Gradient descent algorithm
# =============================================================================
def GradientDescent(Cost, grad_Cost, tht, alpha, gamma, niter):
    g = grad_Cost(tht)
    #norm = np.linalg.norm(g)
    d = -g#/norm
    
    t = tht
    t_seq = [t]
    d_seq = [d]

    for _ in range(niter):
        alpha *= gamma
        
        # Theta update
        t = t + alpha*d
        t_seq.append(t)
        
        g = grad_Cost(t)
        #norm = np.linalg.norm(g)
        d = -g#/norm
        d_seq.append(d)
        
    print('Final point of GD:', t)
    t_seq = np.array(t_seq)
    d_seq = np.array(d_seq)
    return t_seq, d_seq

# =============================================================================
# Stochastic gradient descent algorithm
# =============================================================================
def StochasticGradientDescent(C, grad_C, tht, alpha, gamma, niter):
    n = X.shape[0]
    I = np.random.choice(n)
    g = grad_C(I, tht)
    #norm = np.linalg.norm(g)
    d = -g#/norm
    
    t = tht
    t_seq = [t]
    d_seq = [d]

    for _ in range(niter):
        alpha *= gamma
        
        # Theta update
        t = t + alpha*d
        t_seq.append(t)
        

        I = np.random.choice(n)
        g = grad_C(I, t)
        #norm = np.linalg.norm(g)
        d = -g#/norm
        d_seq.append(d)
        
    print('Final point of SGD:', t)
    t_seq = np.array(t_seq)
    d_seq = np.array(d_seq)
    return t_seq, d_seq



#%%
np.random.seed(0)

# =============================================================================
# Select one of the following two options for X
# =============================================================================
X = np.array([[1,1], [2,0], [3,1], [2,3], [1,2]])
#X = np.array([[2,2], [2,2], [2,2], [2,2], [2,2]])

# =============================================================================
# Main code starts here
# =============================================================================
c = np.array([1,2,3,2,4])

alpha_init = 0.01 # Initial alpha
gamma = 1#0.99
beta = 0.8
t_init = np.array([6, 6]) # initial point
niter = 1000 # no of iterations

t1_range = np.arange(-3, 7, 0.5)
t2_range = np.arange(-3, 7, 0.5)

A = np.meshgrid(t1_range, t2_range)
Z = Cost(A)


# =============================================================================
# Plotting
# =============================================================================
fig, ax = plt.subplots()  
ax.contour(t1_range, t2_range, Z, levels=np.exp(np.arange(-100, 4.5, 0.1)), cmap='Blues')

t_seq_sgd, d_seq_sgd = StochasticGradientDescent(C, grad_C, t_init, alpha_init, gamma, niter)
ax.plot(t_seq_sgd[:, 0], t_seq_sgd[:, 1], '-b', label='SGD', alpha=1, linewidth=1)

t_seq_gd, d_seq_gd = GradientDescent(Cost, grad_Cost, t_init, alpha_init, gamma, niter)
ax.plot(t_seq_gd[:, 0], t_seq_gd[:, 1], '-r', label='GD', alpha=1, linewidth=1)

polygon1 = Polygon(X)
patch = PolygonPatch(polygon1, facecolor=[0,0.5,0], alpha=0.3, zorder=2)
x_pg, y_pg = polygon1.exterior.xy
ax.add_patch(patch)
ax.plot(x_pg, y_pg, c='g')
ax.plot(np.concatenate((X[:, 0], np.array([X[0, 0]]))), np.concatenate((X[:, 1], np.array([X[0, 1]]))), '-og')


plt.xlabel(r'$\theta_1$', fontsize=textsize)
plt.ylabel(r'$\theta_2$', fontsize=textsize)
plt.legend(loc='lower right', fontsize=textsize)
plt.plot(t_init[0], t_init[1], 'o', color='black', zorder=2)
plt.text(t_init[0]- 3.5, t_init[1], r'Initial point $\theta^{(0)}$', fontsize=textsize)
plt.rcParams["figure.figsize"] = (6,6)
plt.show()