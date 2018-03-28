# -*- coding: utf-8 -*-
"""
Created on Thu Mar 22 10:34:00 2018

@author: pwfa-facet2
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit
#import pyzdde.arraytrace as at
import pyzdde.zdde as pyz

import random as rand




def facet_ccd(wv, gridsize, bwaist, xdeg_off, pos_ccd, f_name):
    link = pyz.createLink()
    link.zLoadFile(f_name)
    wavelength = wv/1000
    
    waistx=[]
    waisty = []
    #link.ipzGetLDE()
    #change start position
    #link.zSetSurfaceData(2, 3, start_pos)
    link.zSetSurfaceParameter(4, 3, xdeg_off)
    link.zSetSurfaceParameter(6, 3, -xdeg_off)
    link.zSaveFile(file)
    link.zSetWave(1, wavelength, 1)
    print(link.zGetWave(1))
    
    """
    setfile = link.zGetFile().lower().replace('.zmx', '.CFG')
    S_512 = 5
    grid_size = gridsize
    GAUSS_WAIST, WAIST_X, WAIST_Y, DECENTER_X, DECENTER_Y = 0, 1, 2, 3, 4
    beam_waist, x_off, y_off = bwaist, 0, 0
    cfgfile = link.zSetPOPSettings('irr', setfile, startSurf=2, endSurf=2, field=1, wave=1, beamType=GAUSS_WAIST,
                             paramN=( (WAIST_X, WAIST_Y, DECENTER_X, DECENTER_Y), (beam_waist, beam_waist,
                                     x_off, y_off) ), sampx=S_512, sampy=S_512,
                             widex=grid_size, widey=grid_size, tPow=1, auto=0)
    link.zModifyPOPSettings(setfile, endSurf=pos_ccd)
    link.zModifyPOPSettings(setfile, paramN=( (1, 2, 3, 4), (5, 5,
                                     0, 0) ))
    link.zModifyPOPSettings(setfile, widex=gridsize)
    link.zModifyPOPSettings(setfile, widey=gridsize)
    irr_data, grid_data = link.zGetPOP(setfile, displayData=True)
    waists_gridx, waists_gridy = irr_data.widthX, irr_data.widthY 
    print(waists_gridx, waists_gridy)                         
    pyz.closeLink()
    irr_file = outfile + "\\" +str(xdeg_off)+".csv"
    np.savetxt(irr_file, grid_data)
    screen_width_file = outfile + "\\" +str(xdeg_off)+"_"+"widths.txt"
    np.savetxt(screen_width_file, ((waists_gridx, waists_gridy)))
    """


file = r"C:\Users\pwfa-facet2\Desktop\slacecodes\centroid_test.zmx"
outfile =r"C:\Users\pwfa-facet2\Desktop\slacecodes\offsets_m1"

#link.ipzGetLDE()


def vector_generator_cdd(start_angle, end_angle, f):
    
    #generate random angles
    alpha_1 = np.random.uniform(start_angle, end_angle) # offset on mirror 1
    alpha_2 = np.random.uniform(start_angle, end_angle) #offset on mirror 2
    offset_1_pos_x = []
    offset_1_pos_y = []
    offset_2_pos_x = []
    offset_2_pos_y = []
    link = pyz.createLink()
    link.zLoadFile(f)
    #for i in range(len(alpha_1)):
    i = alpha_1
    j = alpha_2
    link.zSetSurfaceParameter(4, 3, i)
    link.zSetSurfaceParameter(6, 3, -i)
    link.zSetSurfaceParameter(17, 4, j)
    link.zSetSurfaceParameter(19, 4, -j)
    link.zSaveFile(file)
    ccd1 = link.zGetTrace(waveNum=1, mode=0, surf=22,hx=0,hy=0,px=0,py=0)
    ccd2 = link.zGetTrace(waveNum=1, mode=0, surf=24,hx=0,hy=0,px=0,py=0)
        #errors, vig, x,y,z, dcos...
    offset_1_pos_x.append(ccd1[2]) # x-pos change (tilt on x)
    offset_1_pos_y.append(ccd1[3]) # y-pos change (tilt on x)
    offset_2_pos_x.append(ccd2[2]) # x-pos change (tilt on y)
    offset_2_pos_y.append(ccd2[3]) # x-pos change (tilt on y)
        
        
    pyz.closeLink()
    return(offset_1_pos_x, offset_1_pos_y,offset_2_pos_x, offset_2_pos_y, alpha_1, alpha_2)


"""
degrees = range(-10,12,2)
chief_y = []
chief_x = []
for i in range(-10,12,2):
    link.zSetSurfaceParameter(4, 3, i)
    link.zSetSurfaceParameter(6, 3, -i)
    link.zSaveFile(file)
    a =link.zGetTrace(waveNum=1, mode=0, surf=22,hx=0,hy=0,px=0,py=0)
    print(a[3])
    print(i)
    chief_y.append(a[3])
    chief_x.append(a[2])

    
    
pyz.closeLink()

def offset_th(spacing, degree):
    return(spacing*np.tan(2*np.deg2rad(degree)))

space_th = []

for i in degrees:
    space_th.append(offset_th(600, i))
print(space_th)
"""

data = vector_generator_cdd(0, 5, file)
print(data)

f = plt.figure(figsize=(8,8))
f0 = f.add_subplot(111)
f0.scatter(data[0], data[1], marker = 'd', color = 'green', label = 'CCD-1 Centroid Position '+ '(angle-1):'+'%.3g'%data[4])
f0.scatter(data[2], data[3], marker = 'd', color = 'blue', label = 'CCD-2 Centroid Position'+'(angle-2):'+'%.3g'%data[5])
f0.set_xlabel('Beam Position (X) (mm)')
f0.set_ylabel('Beam Position (Y) (mm)')
f0.legend(loc = 'lower right')

box = f0.get_position()
f0.set_position([box.x0, box.y0, box.width * 0.8, box.height])

f.tight_layout()
f.suptitle('Beam Position Under Variable Mirror Offset ')
f.subplots_adjust(top=0.9)
f.savefig('onescreen.pdf')

fig = plt.figure(figsize=(8,8))
f1 = fig.add_subplot(221)
f1.scatter(data[4], data[0], marker = '^', color = 'orange', label='CCD-1 Pos')
#f1.plot(degrees, space_th, linestyle = ':', label = 'Theory')
f1.set_xlabel('Degree Offset Mirror 1 (deg)')
f1.set_ylabel('Beam Position (X) On Screen1 (mm)')
f1.legend(loc = 'lower right')

f2 = fig.add_subplot(222)
f2.scatter(data[4], data[1], label='CCD-1 Pos', marker = '^', color = 'orange')
f2.set_xlabel('Degree Offset Mirror 1 (deg)')
f2.set_ylabel('Beam Position (Y) On Screen1 (mm)')
f2.legend(loc = 'lower right')

f3 = fig.add_subplot(223)
f3.scatter(data[5], data[3], label='CCD-2 Pos', marker = 'd', color = 'red')
f3.set_xlabel('Degree Offset Mirror 2 (deg)')
f3.set_ylabel('Beam Position (X) On Screen2 (mm)')
f3.legend(loc = 'lower right')

f4 = fig.add_subplot(224)
f4.scatter(data[5], data[4], label='CCD-2 Pos', marker = 'd', color = 'red')
f4.set_xlabel('Degree Offset Mirror 2 (deg)')
f4.set_ylabel('Beam Position (Y) On Screen2 (mm)')
f4.legend(loc = 'lower right')

fig.tight_layout()
fig.suptitle('Beam Position On Each Screen')
fig.subplots_adjust(top=0.9)
fig.savefig('noaperturebeamoffset.pdf')