# -*- coding: utf-8 -*-
"""
Created on Fri Mar 30 14:53:54 2018

@author: pwfa-facet2
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit
#import pyzdde.arraytrace as at
import pyzdde.zdde as pyz

import random as rand

def ccd_system(start_angle, end_angle, file):
    alpha_1x = np.random.uniform(start_angle, end_angle)
    alpha_1y = np.random.uniform(start_angle, end_angle)
    alpha_2x = np.random.uniform(start_angle, end_angle)
    alpha_2y = np.random.uniform(start_angle, end_angle)
    
    link = pyz.createLink()
    link.zLoadFile(file)
    #no offset to chief ray
    link.zSetSurfaceParameter(4, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(6, 3, 0)
    link.zSetSurfaceParameter(4, 4, 0)
    link.zSetSurfaceParameter(6, 4, 0)
    
    link.zSetSurfaceParameter(17, 3, 0)
    link.zSetSurfaceParameter(19, 3, 0)
    link.zSetSurfaceParameter(17, 4, 0)
    link.zSetSurfaceParameter(19, 4, 0)
    link.zSaveFile(file)
    
    ccd1_noffset = link.zGetTrace(waveNum=1, mode=0, surf=22,hx=0,hy=0,px=0,py=0)
    ccd2_noffset = link.zGetTrace(waveNum=1, mode=0, surf=24,hx=0,hy=0,px=0,py=0)
    
    #add the offsets
    
    link.zSetSurfaceParameter(4, 3, alpha_1x)
    link.zSetSurfaceParameter(6, 3, -alpha_1x)
    link.zSetSurfaceParameter(4, 4, alpha_1y)
    link.zSetSurfaceParameter(6, 4, -alpha_1y)
    
    link.zSetSurfaceParameter(17, 3, alpha_2x)
    link.zSetSurfaceParameter(19, 3, -alpha_2x)
    link.zSetSurfaceParameter(17, 4, alpha_2y)
    link.zSetSurfaceParameter(19, 4, -alpha_2y)
    link.zSaveFile(file)
    
    ccd1_offset = link.zGetTrace(waveNum=1, mode=0, surf=22,hx=0,hy=0,px=0,py=0)
    ccd2_offset = link.zGetTrace(waveNum=1, mode=0, surf=24,hx=0,hy=0,px=0,py=0)
    
    pyz.closeLink()
    
    return(ccd1_noffset[2], ccd1_noffset[3],
           ccd1_offset[2], ccd1_offset[3],
           alpha_1x, alpha_1y,
           ccd2_offset[2], ccd2_offset[3],
           alpha_2x, alpha_2y)
    

file = r"C:\Users\pwfa-facet2\Desktop\slacecodes\centroid_test.zmx"

data = ccd_system(-0.6,0.6,file)

f = plt.figure(figsize=(15,8))
f0 = f.add_subplot(121)
f0.scatter(data[0], data[1], marker = 'd', color = 'green', label = 'No Offset', s=100)
f0.scatter(data[2], data[3], marker = 'd', color = 'blue', label = 'Variations: ('+ '%.3g'%data[4] + ', ' + '%.3g'%data[5] +')', s=100)
#f0.scatter(data[8], data[9], marker = 'd', color = 'orange', label = 'CCD-2 Centroid Position ('+ '%.3g'%data[10] + ' ' + '%.3g'%data[11] +')', s=100)
f0.legend(loc='best', fontsize=12)
f0.set_xlabel('Beam Position (X) (mm)', fontsize=20)
f0.set_ylabel('Beam Position (Y) (mm)', fontsize=20)
f0.set_title('CCD-1', fontsize=20)

f1 = f.add_subplot(122)
f1.scatter(data[0], data[1], marker = 'd', color = 'green', label = 'No Offset', s=120)
f1.scatter(data[6], data[7], marker = '^', color = 'blue', label = 'Variations: ('+ '%.3g'%data[8] + ', ' + '%.3g'%data[9] +')', s=120)
#f1.scatter(data[14], data[15], marker = '^', color = 'red', label = 'CCD-2 Centroid Position ('+ '%.3g'%data[16] + ' ' + '%.3g'%data[17] +')',s=120)
f1.set_xlabel('Beam Position (X) (mm)', fontsize=20)
f1.set_ylabel('Beam Position (Y) (mm)', fontsize=20)
f1.legend(loc ='best', fontsize=12)
f1.set_title('CCD-2', fontsize=20)

f1.tick_params(axis = 'both', labelsize=15)
f0.tick_params(axis = 'both', labelsize=15)

f.tight_layout()
f.suptitle('Effects of Angle Variations on Two-Mirror System on Beam Centroid', fontsize=30)
f.subplots_adjust(top=0.8)
f.savefig('updated screens.pdf')