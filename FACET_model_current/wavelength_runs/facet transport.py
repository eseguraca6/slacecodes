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
    return(tmp_waist, irr_data, grid_data)
    

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


file = r"C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs\transport.zmx"


def facet_ccd(wv, gridsize, bwaist, xoff, yoff, start_pos, pos_arr, f_name):
    link = pyz.createLink()
    link.zLoadFile(f_name)
    wavelength = wv/1000
    

    #link.ipzGetLDE()
    #change start position
    link.zSetSurfaceData(2, 3, start_pos)
    link.zSetWave(1, wavelength, 1)
    print(link.zGetWave(1))
    setfile = link.zGetFile().lower().replace('.zmx', '.CFG')
    S_512 = 5
    grid_size = gridsize
    GAUSS_WAIST, WAIST_X, WAIST_Y, DECENTER_X, DECENTER_Y = 0, 1, 2, 3, 4
    beam_waist, x_off, y_off = bwaist, xoff,yoff
    cfgfile = link.zSetPOPSettings('irr', setfile, startSurf=2, endSurf=2, field=1, wave=1, beamType=GAUSS_WAIST,
                             paramN=( (WAIST_X, WAIST_Y, DECENTER_X, DECENTER_Y), (beam_waist, beam_waist,
                                     x_off, y_off) ), sampx=S_512, sampy=S_512,
                             widex=grid_size, widey=grid_size, tPow=1, auto=0)
                             
   #ipath = r"C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs\\facet_2_2_offset_img\\"
    outfile =r"C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs\facet_2_2_offset_img\irradiancesetttings.txt"
    screen_width_file= r"C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs\facet_2_2_offset_img\widths.txt"
    waists_gridx = []
    waists_gridy = []
    with open(outfile, "w") as text_file:                      
        for i in range(len(pos_arr)):
            link.zModifyPOPSettings(cfgfile, endSurf=pos_arr[i])
            irr_data, grid_data = link.zGetPOP(cfgfile, displayData=True)
            #waistxy.write(float(irr_data.widthX) + '\t')
            #waistxy.write(float(irr_data.widthY) + '\n')
            #print(irr_data)
            waists_gridx.append(irr_data.widthX)
            waists_gridy.append(irr_data.widthY)
            text_file.write(str(irr_data) + '\n')
            #print(irr_data)
        #irr_data, irr_grid_plot = link.zGetPOP(settingsFile=setfile, displayData=True)
            fpath = r"C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs\facet_2_2_offset_img"
            grid_file = fpath+"\\"+str(wv)+"_"+str(bwaist)+"_"+str(grid_size)+"_"+str(start_pos)+"_pos"+str(pos_arr[i])+ "_irr_offset.csv"
            np.savetxt(grid_file,grid_data)
    np.savetxt(screen_width_file, list(zip(waists_gridx, waists_gridy)))

       
        #out_file = open(ipath+"\\"+"irrdata_pos"+str(start_pos)+".txt", "w")
       

    pyz.closeLink()
def facet_transport(wv, gridsize, bwaist, xoff, yoff, start_pos, pos_arr, f_name):

    link = pyz.createLink()
    link.zLoadFile(f_name)
    wavelength = wv/1000
    

    #link.ipzGetLDE()
    #change start position
    link.zSetSurfaceData(2, 3, start_pos)
    link.zSetWave(1, wavelength, 1)
    print(link.zGetWave(1))
    setfile = link.zGetFile().lower().replace('.zmx', '.CFG')
    S_512 = 5
    grid_size = gridsize
    GAUSS_WAIST, WAIST_X, WAIST_Y, DECENTER_X, DECENTER_Y = 0, 1, 2, 3, 4
    beam_waist, x_off, y_off = bwaist, xoff,yoff
    cfgfile = link.zSetPOPSettings('irr', setfile, startSurf=2, endSurf=2, field=1, wave=1, beamType=GAUSS_WAIST,
                             paramN=( (WAIST_X, WAIST_Y, DECENTER_X, DECENTER_Y), (beam_waist, beam_waist,
                                     x_off, y_off) ), sampx=S_512, sampy=S_512,
                             widex=grid_size, widey=grid_size, tPow=1)
    
    waists_values = waist_extractor(pos_arr, cfgfile, link)
    pyz.closeLink()
    fpath = r"C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs"
    waist_file = fpath+"\\"+str(wv)+"_"+str(bwaist)+"_"+str(start_pos)+'offset.csv'
    np.savetxt(waist_file, waists_values[0])
    irr_file= fpath+"\\"+str(wv)+"_"+str(bwaist)+"_"+str(start_pos)+ "_irr_offset"'.csv'
    np.savetxt(irr_file,waists_values[2])
    surf_pop_file= fpath+"\\"+str(wv)+"_"+str(bwaist)+"_"+str(start_pos)+ "_popinfo_offset"'.txt'
    #np.savetxt(surf_pop_file,waists_values[1] )
    return(waists_values)

facet_ccd(800, 35, 5, 0,0, 541, pos_transport, file)
#facet_ccd(800, 5, 1, 0,0, 541, pos_transport, file)
"""
facet_ccd(527, 25, 5, 0,0, 541, pos_transport, file)
facet_ccd(527, 5, 1, 0,0, 541, pos_transport, file)

facet_ccd(800, 25, 5, 0,0, 2000, pos_transport, file)
facet_ccd(800, 5, 1, 0,0, 2000, pos_transport, file)

facet_ccd(527, 25, 5, 0,0, 2000, pos_transport, file)
facet_ccd(527, 5, 1, 0,0, 2000, pos_transport, file)
"""   

