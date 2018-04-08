# -*- coding: utf-8 -*-
"""
Created on Sat Mar 31 15:03:06 2018

@author: pwfa-facet2
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit
#import pyzdde.arraytrace as at
import pyzdde.zdde as pyz

import random as rand

start_angle = 0
end_angle = .6


alpha_1x = np.random.uniform(start_angle, end_angle)
alpha_1y = np.random.uniform(start_angle, end_angle)
alpha_2x = np.random.uniform(start_angle, end_angle)
alpha_2y = np.random.uniform(start_angle, end_angle)

link = pyz.createLink()


file = r"C:\Users\pwfa-facet2\Desktop\slacecodes\centroid_test.zmx"

link.zLoadFile(file)

setfile = link.zGetFile().lower().replace('.zmx', '.CFG')
S_512 = 5
grid_size = 20
GAUSS_WAIST, WAIST_X, WAIST_Y, DECENTER_X, DECENTER_Y = 0, 1, 2, 3, 4
beam_waist, x_off, y_off = 5, 0, 0
cfgfile = link.zSetPOPSettings('irr', setfile, startSurf=2, endSurf=2, field=1, wave=1, beamType=GAUSS_WAIST,
                             paramN=( (WAIST_X, WAIST_Y, DECENTER_X, DECENTER_Y), (beam_waist, beam_waist,
                                     x_off, y_off) ), sampx=S_512, sampy=S_512,
                             widex=grid_size, widey=grid_size, tPow=1, auto=0)
link.zModifyPOPSettings(setfile, endSurf=24)
link.zModifyPOPSettings(setfile, paramN=( (1, 2, 3, 4), (5, 5,
                                     0, 0) ))
link.zModifyPOPSettings(setfile, widex=grid_size)
link.zModifyPOPSettings(setfile, widey=grid_size) 
link.zSaveFile(file)
angles_xtilt = np.arange(-1, 1.1, 0.1)



link.zSetSurfaceParameter(4, 3, 0) #3 = x-tilt, 4=y-tilt
link.zSetSurfaceParameter(6, 3, 0)
link.zSetSurfaceParameter(4, 4, 0)
link.zSetSurfaceParameter(6, 4, 0)
    
link.zSetSurfaceParameter(17, 3, 0)
link.zSetSurfaceParameter(19, 3, 0)
link.zSetSurfaceParameter(17, 4, 0)
link.zSetSurfaceParameter(19, 4, 0)
link.zSaveFile(file)



beam_y=[]
beam_x = []


for i in angles_xtilt:
    link.zSetSurfaceParameter(4, 3, i)
    link.zSetSurfaceParameter(6, 3, -i)
    link.zSaveFile(file)
    t_ccdx = link.zOperandValue('POPD', 24, 1, 0, 11)
    t_ccdy = link.zOperandValue('POPD', 24, 1, 0, 12)
    #print(t_ccdx, t_ccdy)
    beam_x.append(t_ccdx)
    beam_y.append(t_ccdy)
#ccd1 = link.zGetTrace(waveNum=1, mode=0, surf=24,hx=0,hy=0,px=0,py=0)
#print(ccd1)
pyz.closeLink()

"""
link.zSetSurfaceParameter(4, 3, 3) #3 = x-tilt, 4=y-tilt
link.zSetSurfaceParameter(6, 3, -3)
link.zSetSurfaceParameter(4, 4, 0)
link.zSetSurfaceParameter(6, 4, 0)
    
link.zSetSurfaceParameter(17, 3, 0)
link.zSetSurfaceParameter(19, 3, 0)
link.zSetSurfaceParameter(17, 4, 0)
link.zSetSurfaceParameter(19, 4, 0)
link.zSaveFile(file)

ccd1 = link.zGetTrace(waveNum=1, mode=0, surf=22,hx=0,hy=0,px=0,py=0)
ccd2 = link.zGetTrace(waveNum=1, mode=0, surf=24,hx=0,hy=0,px=0,py=0)

t = link.zOperandValue('POPD', 24, 1, 0, 12)

print(pyz.findZOperand('Physical Optics Propagation Data'))


print(t)
pyz.closeLink()
"""
th = 600*(np.tan(np.deg2rad(2*angles_xtilt)))
print(np.size(th))
a= plt.figure(figsize=(8,8))
a0 = a.add_subplot(121)
a0.scatter(angles_xtilt,beam_y)
a0.plot(angles_xtilt, th, color = 'red', linestyle = ":")
a1 = a.add_subplot(122)
a1.scatter(angles_xtilt, beam_x)

np.savetxt('dataoffsetsonm1alpha1xx.csv', list(zip(beam_x, beam_y, angles_xtilt)))

"""
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

data= [ccd1_noffset[2], ccd1_noffset[3],
           ccd1_offset[2], ccd1_offset[3],
           alpha_1x, alpha_1y,
           ccd2_offset[2], ccd2_offset[3],
           alpha_2x, alpha_2y]


print('ccd1 pos and angles:')
print(data[2], data[3], data[4], data[5])
print('ccd2 pos and angles:')
print(data[6], data[7], data[8], data[9])

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
f.savefig('test.pdf')
#add xtilt on m1 and ytilt on m2 

"""