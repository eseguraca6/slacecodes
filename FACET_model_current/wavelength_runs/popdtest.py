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
    #no offset to chief ray
    link.zSetSurfaceParameter(4, 3, 0)
    link.zSetSurfaceParameter(6, 3, 0)
    link.zSetSurfaceParameter(17, 4, 0)
    link.zSetSurfaceParameter(19, 4, 0)
    link.zSaveFile(f)
    
    ccd1_noffset = link.zGetTrace(waveNum=1, mode=0, surf=22,hx=0,hy=0,px=0,py=0)
    ccd2_noffset = link.zGetTrace(waveNum=1, mode=0, surf=24,hx=0,hy=0,px=0,py=0)

    
    alpha_2_norm = 0
   #offset only on m1 
    i = alpha_1
    j = alpha_2_norm
    link.zSetSurfaceParameter(4, 3, i)
    link.zSetSurfaceParameter(6, 3, -i)
    link.zSetSurfaceParameter(17, 4, j)
    link.zSetSurfaceParameter(19, 4, -j)
    link.zSaveFile(f)
    
    ccd1_offset_m1 = link.zGetTrace(waveNum=1, mode=0, surf=22,hx=0,hy=0,px=0,py=0)
    ccd2_offset_m1 = link.zGetTrace(waveNum=1, mode=0, surf=24,hx=0,hy=0,px=0,py=0)
        #errors, vig, x,y,z, dcos...
    

    ##offset on m1 and m2 (m2 added)
    
    j = alpha_2
    link.zSetSurfaceParameter(4, 3, i)
    link.zSetSurfaceParameter(6, 3, -i)
    link.zSetSurfaceParameter(17, 4, j)
    link.zSetSurfaceParameter(19, 4, -j)
    link.zSaveFile(f)
    
    ccd1_offset_m2 = link.zGetTrace(waveNum=1, mode=0, surf=22,hx=0,hy=0,px=0,py=0)
    ccd2_offset_m2 = link.zGetTrace(waveNum=1, mode=0, surf=24,hx=0,hy=0,px=0,py=0)
        
    pyz.closeLink()
    return(ccd1_noffset[2], ccd1_noffset[3], #0,1
           ccd2_noffset[2], ccd2_noffset[3], #2,3
           0,0, #4,5
           ccd1_offset_m1[2], ccd1_offset_m1[3], #6,7
           ccd2_offset_m1[2], ccd2_offset_m1[3], #8,9
           alpha_1, alpha_2_norm, #10,11
           ccd1_offset_m2[2], ccd1_offset_m2[3], #12,13
           ccd2_offset_m2[2], ccd2_offset_m2[3], #14,15
           alpha_1, alpha_2) #16,17

     
data = vector_generator_cdd(0, 5, file)

from matplotlib.legend import Legend

f = plt.figure(figsize=(12,10))
f0 = f.add_subplot(121)
f0.scatter(data[0], data[1], marker = 'd', color = 'green', label = 'No Offset', s=100)
f0.scatter(data[6], data[7], marker = 'd', color = 'blue', label = 'CCD-1 Centroid Position ('+ '%.3g'%data[10] + ' ' + '%.3g'%data[11] +')', s=100)
f0.scatter(data[8], data[9], marker = 'd', color = 'orange', label = 'CCD-2 Centroid Position ('+ '%.3g'%data[10] + ' ' + '%.3g'%data[11] +')', s=100)
f0.legend(loc='best', fontsize=12)
f0.set_xlabel('Beam Position (X) (mm)', fontsize=20)
f0.set_ylabel('Beam Position (Y) (mm)', fontsize=20)

f1 = f.add_subplot(122)
f1.scatter(data[0], data[1], marker = 'd', color = 'green', label = 'No Offset', s=120)
f1.scatter(data[12], data[13], marker = '^', color = 'blue', label = 'CCD-1 Centroid Position ('+ '%.3g'%data[16] + ' ' + '%.3g'%data[17] +')', s=120)
f1.scatter(data[14], data[15], marker = '^', color = 'red', label = 'CCD-2 Centroid Position ('+ '%.3g'%data[16] + ' ' + '%.3g'%data[17] +')',s=120)
f1.set_xlabel('Beam Position (X) (mm)', fontsize=20)
f1.set_ylabel('Beam Position (Y) (mm)', fontsize=20)
f1.legend(loc ='best', fontsize=12)

f1.tick_params(axis = 'both', labelsize=15)
f0.tick_params(axis = 'both', labelsize=15)

f.tight_layout()
f.suptitle('Effects of Angle Variations on Two-Mirror System on Beam Centroid', fontsize=30)
f.subplots_adjust(top=0.90)
f.savefig('onescreen.pdf')

"""

fig = plt.figure(figsize=(12,8))
f1 = fig.add_subplot(121)
f1.scatter(data[6], data[7], label='No Variations', marker = '<', color = 'green', s=80)
f1.scatter(data[0], data[1], label='Under Variations', marker = '<', color = 'red', s=80)
#f1.plot(degrees, space_th, linestyle = ':', label = 'Theory')
f1.set_xlabel('Beam Position (X) On Screen1 (mm)')
f1.set_ylabel('Beam Position (Y) On Screen1 (mm)')
f1.legend(loc = 'best')
f1.title.set_text('CCD-1')


f2 = fig.add_subplot(122)
f2.scatter(data[8], data[9], label='No Variations', marker = 'P', color = 'green', s=80)
f2.scatter(data[2], data[3], label='Under Variations', marker = 'P', color = 'red', s=80)



f2.set_xlabel('Beam Position (X) On Screen2 (mm)')
f2.set_ylabel('Beam Position (Y) On Screen2 (mm)')
f2.title.set_text('CCD-2')
f2.legend(loc = 'best')


fig.tight_layout()
fig.suptitle('Beam Position On Each Screen')
fig.subplots_adjust(top=0.9)
fig.savefig('ccds.pdf')



deg = plt.figure(figsize=(8,8))
d0 =  deg.add_subplot(121)
d0.scatter(0, data[6], marker = 'v', label = 'No Offset')
d0.scatter(data[4], data[1], marker = 'v', label = 'CCD-1')
d0.scatter(0, data[3], marker = 'v', label = 'CCD-2')
d0.set_xlabel('Angle Variations (Degrees)')
d0.set_ylabel('Beam Position (X) (mm)')
d0.legend(loc = 'best')
d0.title.set_text('(angle-1):'+'%.3g'%data[4]+ ' ' +'(angle-2):'+'%.3g'%data[5] )

d1 =  deg.add_subplot(122)
d1.scatter(0, data[7], marker = 'v', label = 'No Offset')
d1.scatter(data[4], data[0], marker = 'v', label = 'CCD-1')
d1.scatter(data[5], data[2], marker = 'v', label = 'CCD-2')
d1.set_xlabel('Angle Variations (Degrees)')
d1.set_ylabel('Beam Position (Y) (mm)')
d1.legend(loc = 'best')
d1.title.set_text('(angle-1):'+'%.3g'%data[4]+ ' ' +'(angle-2):'+'%.3g'%data[5] )

deg.tight_layout()
deg.savefig('degreerange.pdf')
"""