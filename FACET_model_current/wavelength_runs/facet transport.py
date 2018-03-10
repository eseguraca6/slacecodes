# -*- coding: utf-8 -*-
"""
Created on Fri Mar  9 17:01:17 2018

@author: pwfa-facet2
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit

import pyzdde.zdde as pyz






def gaussian(x,const, mean,sigma):
    mean_factor = x - mean
    e_arg = np.exp(-np.divide( np.square(mean_factor), 2*np.square(sigma)))
    return(const*e_arg )
    
def waist_extractor(pos_list, cfgfile, link):
    tmp_data = []
    tmp_grid =[]
    for i in pos_list:
        link.zModifyPOPSettings(cfgfile, endSurf=i)
        irr_data, grid_data = link.zGetPOP(cfgfile, displayData=True)
        tmp_data.append(irr_data)
        tmp_grid.append(grid_data)

    tmp_x = []
    for i in tmp_data:
        dx = i[-2] / 512
        tmpx = [-i[-2] / 2 + dx * j for j in range(512)]
        tmp_x.append(tmpx)

    tmp_waist =[]
    for i in range(len(tmp_grid)):
        popt, pcov = curve_fit(gaussian, tmp_x[i], tmp_grid[i][256], maxfev=18000)
        tmp_waist.append(2 * np.abs(popt[2]))
    return(tmp_waist)
    

def beam_settings(zlink):
    wavelength = wv /1000
    link.zSetSurfaceData(2, 3, start_pos)
    link.zSetWave(1, wavelength, 1) 
    print(link.zGetWave(1))
    setfile = link.zGetFile().lower().replace('.zmx', '.CFG')
    GAUSS_WAIST, WAIST_X, WAIST_Y, beam_waist = 0, 1, 2, bwaist
    DECENTER_X, DECENTER_Y = x_off, y_off
    S_512 = 5
    grid_size = gridsize
    cfgfile = link.zSetPOPSettings('irr', setfile, 4, endSurf=4, field=1, wave=1, beamType=GAUSS_WAIST,
                             paramN=((WAIST_X, WAIST_Y), (beam_waist, beam_waist), (DECENTER_X, DECENTER_Y)), sampx=S_512, sampy=S_512,
                             widex=grid_size, widey=grid_size, tPow=1)
    return(setfile, cfgfile)

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
    
######################################

#tisaph_f_1mm_settings = beam_settings(link, 800, 1, 20, 0,0,541)



def facet_transport(wv, gridsize, bwaist, x_off, y_off, start_pos, pos_arr):
    file = r"C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs\transport.zmx"
    link = pyz.createLink()
    link.zLoadFile(file)
    wavelength = wv/1000
    

    #link.ipzGetLDE()

    link.zSetSurfaceData(3, 3, start_pos)
    link.zSetWave(1, wavelength, 1)
    print(link.zGetWave(1))
    setfile = link.zGetFile().lower().replace('.zmx', '.CFG')
    GAUSS_WAIST, WAIST_X, WAIST_Y, beam_waist = 0, 1, 2, bwaist
    DECENTER_X, DECENTER_Y = 0, 0
    S_512 = 5
    grid_size = 6
    cfgfile = link.zSetPOPSettings('irr', setfile, 2, endSurf=2, field=1, wave=1, beamType=GAUSS_WAIST,
                             paramN=((WAIST_X, WAIST_Y), (beam_waist, beam_waist), (DECENTER_X, DECENTER_Y)), sampx=S_512, sampy=S_512,
                             widex=grid_size, widey=grid_size, tPow=1)
    
    waists_values = waist_extractor(pos_arr, cfgfile, link)
    pyz.closeLink()
    fpath = r"C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs"
    waist_file = fpath+"\\"+str(wv)+"_"+str(bwaist)+"_"+str(start_pos)+'.csv'
    np.savetxt(waist_file, waists_values)
    return(waists_values)

facet_transport(800, 25, 5, 0,0, 541, pos_transport)
facet_transport(800, 25, 1, 0,0, 541, pos_transport)

facet_transport(527, 25, 5, 0,0, 541, pos_transport)
facet_transport(527, 25, 1, 0,0, 541, pos_transport)

facet_transport(800, 25, 5, 0,0, 2000, pos_transport)
facet_transport(800, 25, 1, 0,0, 2000, pos_transport)

facet_transport(527, 25, 5, 0,0, 2000, pos_transport)
facet_transport(527, 25, 1, 0,0, 2000, pos_transport)
    

