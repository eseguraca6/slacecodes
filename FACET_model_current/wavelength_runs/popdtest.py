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


a =link.zGetTrace(waveNum=1, mode=0, surf=22,hx=0,hy=0,px=0,py=0)
print(a)
pyz.closeLink()