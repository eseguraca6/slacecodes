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

link = pyz.createLink()

link.zLoadFile(file)
#link.ipzGetLDE()
setfile = link.zGetFile().lower().replace('.zmx', '.CFG')

link.zModifyPOPSettings(setfile, endSurf=22)
link.zModifyPOPSettings(setfile, paramN=( (1, 2, 3, 4), (5, 5,
                                     0, 0) ))
link.zModifyPOPSettings(setfile, widex=50)
link.zModifyPOPSettings(setfile, widey=50)
irr_data, grid_data = link.zGetPOP(setfile, displayData=True, txtFile = r"C:\Users\pwfa-facet2\Desktop\slacecodes\mirror_test_surf_22.txt", keepFile=True)
waists_gridx, waists_gridy = irr_data.widthX, irr_data.widthY 
#print(waists_gridx, waists_gridy)                         

#facet_ccd(800, 20, 5, 10, 22, file)
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
fig = plt.figure(figsize=(10,10))
f1 = fig.add_subplot(221)
f1.scatter(degrees, chief_y, marker = '^', color = 'orange', label='CCD Pos')
f1.plot(degrees, space_th, linestyle = ':', label = 'Theory')
f1.set_xlabel('Degree Offset Mirror 1 (deg)')
f1.set_ylabel('Beam Position (Y) On Screen After Mirror 2 (mm)')
f1.legend(loc = 'lower right')
f2 = fig.add_subplot(222)
f2.scatter(degrees, chief_x, label='CCD Pos')
f2.set_xlabel('Degree Offset Mirror 1 (deg)')
f2.set_ylabel('Beam Position (X) On Screen After Mirror 2 (mm)')
f2.legend(loc = 'lower right')
fig.tight_layout()
fig.suptitle('Beam Position Under Variable Mirror Offset')
fig.subplots_adjust(top=0.9)
fig.savefig('noaperturebeamoffset.pdf')