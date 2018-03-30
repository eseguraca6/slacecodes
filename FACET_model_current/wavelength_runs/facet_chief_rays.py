# -*- coding: utf-8 -*-
"""
Created on Fri Mar 30 09:46:03 2018

@author: pwfa-facet2
"""


import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit
#import pyzdde.arraytrace as at
import pyzdde.zdde as pyz

import random as rand

pos_transport = [2, 7, 11]

optical_pos = [2, 7, 11, 24, 28, 40, 52, 63, 68, 80, 84]

for i in range(13,18,2):
    pos_transport.append(i)

pos_transport.append(24)
pos_transport.append(28)

for i in range(30,35,2):   
    pos_transport.append(i)
    
pos_transport.append(40)

for i in range(42,47,2):   
    pos_transport.append(i)

pos_transport.append(52)

for i in range(54, 59, 2):  
    pos_transport.append(i)

pos_transport.append(63)
pos_transport.append(68)    
    
for i in range(70,75, 2): 
    pos_transport.append(i)
    
pos_transport.append(80)
pos_transport.append(84)
    
for i in range(86, 91, 2):  
    pos_transport.append(i)

def facet_chief_ray_tracker(file_name, surface_tbvariated, surface_pos_list, wavenum,  ll_angle, ul_angle):
    unmodified_beam_x =[]
    unmodified_beam_y = []
    
    link = pyz.createLink()
    link.zLoadFile(file_name)
    wavelength = wavenum /1000
    link.zSetWave(1, wavelength, 1) 
    
    for curr_surface in surface_pos_list:
        t_ccd = link.zGetTrace(waveNum=1, mode=0, surf=curr_surface,hx=0,hy=0,px=0,py=0)
        unmodified_beam_x.append(t_ccd[2])
        unmodified_beam_y.append(t_ccd[3])
    
    ##add initial offset to first mirror
    
    
    pyz.closeLink()
    return(unmodified_beam_x, unmodified_beam_y)
    
file = r"C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs\transport.zmx"

a = facet_chief_ray_tracker(file, 0, pos_transport, 800, 0, 0)

print(a[0])
print(a[1])
    
