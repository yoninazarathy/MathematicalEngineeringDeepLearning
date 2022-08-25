#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jan 13 22:56:40 2021

@author: Sarat Moka

Python code for generating 3d-plots of 
a convex function with a (unique) global minimum 
and a non-convex function with several local extrema.

"""

import numpy as np
import matplotlib.pyplot as plt

mycmap = plt.get_cmap('gist_earth')

# =============================================================================
# Covex and non-convex functions
# =============================================================================
f_non_convex = lambda t: 3*((1 - t[0])**2)*np.exp(-t[0]**2 - (t[1] + 1)**2) - 10*(t[0]/5 - t[0]**3 - t[1]**5)*np.exp(-t[0]**2 - t[1]**2) - (1/3)*np.exp(-(t[0]+1)**2 - t[1]**2)
f_convex = lambda t: t[0]**2 + t[1]**2


#%%
# =============================================================================
# This cell plots a convex function
# =============================================================================

t1_range = np.arange(-2.5, 2.5, 0.05)
t2_range = np.arange(-2.5, 2.5, 0.05)

A = np.meshgrid(t1_range, t2_range)
Z = f_convex(A)
X, Y = np.meshgrid(t1_range, t2_range)

fig = plt.figure()
ax = plt.axes(projection='3d')
ax.plot_surface(X, Y, Z, rstride=1, cstride=1, linewidth=0, antialiased=False, edgecolor='none', vmin =np.min(Z), vmax =1.5*np.max(Z))
ax.view_init(30, 70)
ax.set_xlabel(r'$\theta_1$')
ax.set_ylabel(r'$\theta_2$')
plt.show()

#%%
# =============================================================================
# This cell plots a non-convex function
# =============================================================================

t1_range = np.arange(-2.5, 2.5, 0.05)
t2_range = np.arange(-2.5, 2.5, 0.05)

A = np.meshgrid(t1_range, t2_range)
Z = f_non_convex(A)
X, Y = np.meshgrid(t1_range, t2_range)

fig = plt.figure()
ax = plt.axes(projection='3d')
ax.plot_surface(X, Y, Z, rstride=1, cstride=1, linewidth=0, antialiased=False, edgecolor='none', vmin =np.min(Z), vmax =1.5*np.max(Z))
ax.view_init(30, 70)
ax.set_xlabel(r'$\theta_1$')
ax.set_ylabel(r'$\theta_2$')
plt.show()