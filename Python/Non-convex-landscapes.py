#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jul 10 08:59:10 2021

@author: Sarat Moka

Python code for comparing L2 loss and the CE loss with an simple scenario.

"""
import numpy as np
import matplotlib.pyplot as plt

X = np.array([-3,-2,-1,1,2,3])
y = np.array([1, 0, 0, 1, 1, 0])

# =============================================================================
# Definition of Sigmoid function
# =============================================================================
def sigmoid(u):
    
    return 1/(1 + np.exp(-u))

# =============================================================================
# Definition of CE loss function
# =============================================================================
def celoss(w1, w2):

    n = y.shape[0]
    s = 0.0
    
    for i in range(n):
        y_hat = sigmoid(sigmoid(X[i]*w1)*w2)
        s += y[i]*np.log(y_hat) + (1 - y[i])*np.log(1 - y_hat)
    
    return -s/n

# =============================================================================
# Definition of L2 loss function
# =============================================================================
def loss2(w1, w2):
    
    n = y.shape[0]
    s = 0.0
    for i in range(n):
        y_hat = sigmoid(sigmoid(X[i]*w1)*w2)
        s += (y[i] - y_hat)**2
    
    return s


# =============================================================================
# Main code starts here
# =============================================================================
w1_min = -20
w1_max = 20
w2_min = -20
w2_max = 20

w1_range = np.arange(w1_min, w1_max, 1)
w2_range = np.arange(w2_min, w2_max, 1)

w1_grid, w2_grid = np.meshgrid(w1_range, w2_range)

# =============================================================================
# Select one of the following two options
# =============================================================================
loss_grid = loss2(w1_grid, w2_grid)
#loss_grid = celoss(w1_grid, w2_grid)


# =============================================================================
# Plotting the landscape
# =============================================================================
fig = plt.figure()
ax = plt.axes(projection='3d')

#ax.plot_wireframe(t1_arr, t2_arr, cost_arr,  color='black')
ax.plot_surface(w1_grid, w2_grid, loss_grid, cmap='Blues_r', linewidth=0,  antialiased=False, edgecolor='none', vmin =np.min(loss_grid), vmax =1.5*np.max(loss_grid)) #cmap='Blues_r',
ax.set_xlabel(r'$w1$', fontsize=20)
ax.set_yticks(2*np.array([-10, -5, 0, 5, 10]))
ax.set_xticks(2*np.array([-10, -5, 0, 5, 10]))
ax.set_ylabel(r'$w2$', fontsize=20)
ax.set_zlabel(r'$C(\theta)$', fontsize=20)  
ax.view_init(25, -120)