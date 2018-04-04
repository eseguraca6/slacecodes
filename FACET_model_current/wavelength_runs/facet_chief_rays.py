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

pos_transport = [2, 8, 12]

optical_pos = [2, 7, 11, 24, 28, 40, 52, 63, 68, 80, 84]

for i in range(14,20,2):
    pos_transport.append(i)

pos_transport.append(26)
pos_transport.append(30)

for i in range(32,37,2):   
    pos_transport.append(i)
    
pos_transport.append(44)

for i in range(46,51,2):   
    pos_transport.append(i)

pos_transport.append(58)

for i in range(59, 65, 2):  
    pos_transport.append(i)

pos_transport.append(69)
pos_transport.append(76)    
    
for i in range(78,83, 2): 
    pos_transport.append(i)
    
pos_transport.append(90)
pos_transport.append(94)
    
for i in range(96, 101, 2):  
    pos_transport.append(i)

def facet_chief_ray_tracker(file_name, surface_tbvariated, surface_pos_list, wavenum,  angle_variation):
    
    link = pyz.createLink()
    link.zLoadFile(file_name)
    wavelength = wavenum /1000
    link.zSetWave(1, wavelength, 1) 
    
    link.zSetSurfaceParameter(4, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(6, 3, 0)
    link.zSetSurfaceParameter(4, 4, 0)
    link.zSetSurfaceParameter(6, 4, 0)

    link.zSaveFile(file)
    
    offset_x =[]
    offset_y = []
    
    #modify entries 
    link.zSetSurfaceParameter(surface_tbvariated, 3, angle_variation)
    link.zSetSurfaceParameter(surface_tbvariated+2, 3, -angle_variation)
    link.zSaveFile(file_name)
    
    for curr_surface in surface_pos_list:
        t_ccdx = link.zOperandValue('POPD', curr_surface, 1, 0, 11)
        t_ccdy = link.zOperandValue('POPD', curr_surface, 1, 0, 12)
       #print(t_ccdx, t_ccdy)
        offset_x.append(t_ccdx)
        offset_y.append(t_ccdy)
    
    pyz.closeLink()
    return(offset_x, offset_y)
    
file = r"C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs\transportwithoffsetentries.zmx"

transport = [0]
transport.append(transport[-1]+541)
transport.append(transport[-1]+27)

for i in range(0,3):
    transport.append(transport[-1]+517)

transport.append(transport[-1]+517)
transport.append(transport[-1]+100)

for i in range(0,3):
    transport.append(transport[-1]+770.5)

transport.append(transport[-1]+770.5)

for i in range(0,3):
    transport.append(transport[-1]+1530.25)

transport.append(transport[-1]+1530.25)

for i in range(0,3):
    transport.append(transport[-1]+503.25)

transport.append(transport[-1]+503.25)
transport.append(transport[-1]+381.7)

for i in range(0,3):
    transport.append(transport[-1]+2934.575)

transport.append(transport[-1]+2934.575)
transport.append(transport[-1]+381.7)

for i in range(0,3):
    transport.append(transport[-1]+472.5)



a = facet_chief_ray_tracker(file, 4, pos_transport, 800, .3)
b = facet_chief_ray_tracker(file, 4, pos_transport, 800, .2)
c = facet_chief_ray_tracker(file, 4, pos_transport, 800, .4)
d = facet_chief_ray_tracker(file, 4, pos_transport, 800, .5)
e = facet_chief_ray_tracker(file, 4, pos_transport, 800, .1)
f = facet_chief_ray_tracker(file, 4, pos_transport, 800, 0)

np.savetxt('facetwithoffset_3_static_space.csv', list(zip(a[0], a[1],pos_transport, transport)))
np.savetxt('facetwithoffset_2_static_space.csv', list(zip(b[0], b[1], pos_transport, transport)))
np.savetxt('facetwithoffset_1_static_space.csv', list(zip(e[0], e[1], pos_transport, transport)))
np.savetxt('facetwithoffset_4_static_space.csv', list(zip(c[0], c[1],  pos_transport, transport)))
np.savetxt('facetwithoffset_5_static_space.csv', list(zip(d[0], d[1], pos_transport, transport)))
np.savetxt('facetwithoffset_0_static_space.csv', list(zip(f[0], f[1], pos_transport, transport)))
"""
p= plt.figure(figsize=(12,8))
p0 = p.add_subplot(111)
p0.scatter(transport, a[1], marker = 'd', s=80, label = 'No Offset')
p0.scatter(transport,a[3], marker = '^', s=60, label = 'Offset at Mirror-1')
p0.legend(loc='best')
p.suptitle('Beam Position in FACET-II Laser Transport')
p.subplots_adjust(top=0.8)
p.tight_layout()    
p.savefig('simpletest.pdf')

"""
