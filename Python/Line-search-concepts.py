#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jul  9 06:30:12 2021

@author: Sarat Moka

Python code for illustrating line search in an iteration of 
the basic gradient descent on a Rosenbrock function.

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
# Gradient descent algorithm
# =============================================================================
def GradientDescent(f, grad, t, alpha, niter):
    
    t_seq = [t]
    d_seq = []

    for _ in range(niter):
        g = grad(t)
        #norm = np.linalg.norm(g)
        d = -g #/norm
        
        # Theta update
        t = t + alpha*d
        
        t_seq.append(t)
        d_seq.append(d)
        
    print('Final point of GD:', t)
    t_seq = np.array(t_seq)
    d_seq = np.array(d_seq)
    return t_seq, d_seq


#%%
# =============================================================================
# Initial point and the initial descent direction
# =============================================================================
t = np.array([0.8, -0.0]) # initial point
d = -grad(t)



#%%
# =============================================================================
# Run this cell for plotting the function values along the ray
# =============================================================================
alpha = np.arange(0, 0.003, 0.00001)
size = alpha.shape[0]
y = np.zeros(size)

for i in range(size):
    y[i] = line(t, d, alpha[i])

plt.plot(alpha, y, '-r')
#plt.xlabel(r'$\alpha$', fontsize=25, loc='right')
plt.ylabel(r'$C\left(\theta^{(t)} + \alpha \, \theta_{\mathsf{d}}^{(t)}\right)$', fontsize=20)
#plt.legend(fontsize=20)
plt.xlim(0, 0.003)
plt.ylim(-5, 45)
plt.rcParams["figure.figsize"] = (10,10)
ind_min = np.argmin(y)
ind_min = np.argmin(y)
alpha_opt = alpha[ind_min]
plt.plot([alpha_opt, alpha_opt], [-5, y[ind_min]], '-g', linewidth=2)
plt.text(alpha[ind_min]-0.00005, -9, r'$\alpha^{(t)}$', fontsize=20)
plt.xticks(fontsize=12)
plt.show()


#%%
# =============================================================================
# Run this cell for contour plot of Rosenbrock function along with the ray
# =============================================================================
t_end = t + alpha[-1]*d
t_new = t + alpha_opt*d

t1_range = np.arange(-0.3, 1.1, 0.01)
t2_range = np.arange(-0.3, 1.2, 0.01)

A = np.meshgrid(t1_range, t2_range)
Z = f(A)
plt.contour(t1_range, t2_range, Z, levels=np.exp(np.arange(-15, 7, 0.2)), locator=ticker.LogLocator(), cmap=cm.PuBu_r, linewidths=3, zorder=0)


plt.plot(1, 1, 'o')
plt.text(1-0.37,1, 'Optimal point', fontsize=20)
plt.plot(t[0], t[1], 'o', color='black')
plt.text(t[0]-0.15,t[1]-0.06, r'Current point $\theta^{(t)}$', fontsize=20)

plt.xlabel(r'$\theta_1$', fontsize=20)
plt.ylabel(r'$\theta_2$', fontsize=20)
#plt.legend(fontsize=20)
plt.rcParams["figure.figsize"] = (10,10)

#plt.plot([t[0], t_new[0]], [t[1], t_new[1]], '-r')
#plt.arrow(t[0], t[1], t_new[0] - t[0], t_new[1] - t[1], head_width=.05, head_length=0.05, color='r', zorder=1)
plt.annotate("", xy=(t_end[0], t_end[1]), xytext=(t[0], t[1]),  arrowprops=dict(arrowstyle="->", linewidth=2, color='red'), fontsize=25, zorder=1)

plt.plot(t_new[0], t_new[1], 'o', color='green', zorder=2)
plt.text(t_new[0]+0.02,t_new[1]+0.02, r'Next point $\theta^{(t+1)}$', fontsize=20, zorder=1)

plt.show()

