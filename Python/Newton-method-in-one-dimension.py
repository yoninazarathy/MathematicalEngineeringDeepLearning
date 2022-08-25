#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jul  9 11:23:43 2022

@author: Sarat Moka

Python code for showing quadratic approximation in Newton's method 
for one dimensional case.

"""

import numpy as np
import matplotlib.pyplot as plt

# =============================================================================
# Example function C and its first and second order derivatives C1 and C2, respectively.
# =============================================================================
a = np.array([1,-4,-2,10, 15])
C = lambda t : a[0]*(t**4) + a[1]*(t**3) + a[2]*(t**2) + a[3]*t + a[4]
C1 = lambda t : 4*a[0]*(t**3) + 3*a[1]*(t**2) + 2*a[2]*t + a[3]
C2 = lambda t : 12*a[0]*(t**2) + 6*a[1]*t + 2*a[2]

#%%
# =============================================================================
# Run this cell to get convex quadratic aproximation
# =============================================================================
r = 2.5
Q = lambda t: C(r) + (t - r)*C1(r) + ((t - r)**2)*C2(r)/2


t1_arr = np.arange(-1, 4, 0.01)

C_arr = C(t1_arr)

t2_arr = np.arange(1.5, 4.2, 0.01)
Q_arr = Q(t2_arr)

plt.plot(t1_arr, C_arr, label=r'$C(\theta)$')
plt.plot(t2_arr, Q_arr, 'r', alpha=1, label=r'$Q(\theta)$')
plt.ylim((-10, 45))
plt.xlim((-1, 4.2))
plt.plot([r, r], [-10, C(r)], 'g')
plt.text(r-0.05, -14, r'$\theta^{(t)}$', fontsize=20)
plt.plot([3.64, 3.64], [-10, Q(3.64)], 'g')
plt.plot([-1, r], [C(r), C(r)], '--g', alpha=1)
plt.text(3.55, -14, r'$\theta^{(t+1)}$', fontsize=20)
plt.text(-1.6, C(r)-0.5, r'$C(\theta^{(t)})$', fontsize=20)
plt.xticks([])
plt.yticks([])
plt.legend(fontsize=20)
plt.rcParams["figure.figsize"] = (9.3,6.1)
plt.show()


#%%
# =============================================================================
# Run this cell to get concave quadratic aproximation
# =============================================================================
r = 1.7
Q = lambda t: C(r) + (t - r)*C1(r) + ((t - r)**2)*C2(r)/2

t1_arr = np.arange(-1,4, 0.01)

C_arr = C(t1_arr)

t2_arr = np.arange(-1, 3, 0.01)
Q_arr = Q(t2_arr)

ind_min = np.argmax(Q_arr)
t_min = t2_arr[ind_min]

plt.plot(t1_arr, C_arr, label=r'$C(\theta)$')
plt.plot(t2_arr, Q_arr, 'r', alpha=1, label=r'$Q(\theta)$')
plt.ylim((-10, 45))
plt.xlim((-1, 4.2))
plt.plot([r, r], [-10, C(r)], 'g')
plt.text(r-0.07, -14, r'$\theta^{(t)}$', fontsize=20)
plt.plot([t_min, t_min], [-10, Q(t_min)], 'g')
plt.plot([-1, r], [C(r), C(r)], '--g', alpha=1)
plt.text(t_min-0.05, -14, r'$\theta^{(t+1)}$', fontsize=20)
plt.text(-1.6, C(r)-0.5, r'$C(\theta^{(t)})$', fontsize=20)
plt.xticks([])
plt.yticks([])
plt.legend(fontsize=20)
plt.rcParams["figure.figsize"] = (9.3,6.1)
plt.show()

