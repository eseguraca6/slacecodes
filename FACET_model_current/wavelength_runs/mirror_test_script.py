# -*- coding: utf-8 -*-
"""
Created on Mon Mar 12 11:35:19 2018

@author: pwfa-facet2
"""

import pyzdde.zdde as pyz
import numpy as np
import matplotlib.pyplot as plt

file = r"C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs\image_test\mtest.zmx"

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

def facet_transport(wv, gridsize, bwaist, x_off, y_off, start_pos, pos_arr, f_name):

    link = pyz.createLink()
    link.zLoadFile(f_name)
    wavelength = wv/1000
    

    #link.ipzGetLDE()
    #change start position
    link.zSetSurfaceData(2, 3, start_pos)
    link.zSetWave(1, wavelength, 1)
    print(link.zGetWave(1))
    setfile = link.zGetFile().lower().replace('.zmx', '.CFG')
    GAUSS_WAIST, WAIST_X, WAIST_Y, beam_waist = 0, 1, 2, bwaist
    DECENTER_X, DECENTER_Y = x_off, y_off
    S_512 = 5
    grid_size = gridsize
    cfgfile = link.zSetPOPSettings('irr', setfile, startSurf=2, endSurf=2, field=1, wave=1, beamType=GAUSS_WAIST,
                             paramN=((WAIST_X, WAIST_Y), (beam_waist, beam_waist), (DECENTER_X, DECENTER_Y)), sampx=S_512, sampy=S_512,
                             widex=grid_size, widey=grid_size, tPow=1)
    
    waists_values = waist_extractor(pos_arr, cfgfile, link)
    pyz.closeLink()
    fpath = r"C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs"
    waist_file = fpath+"\\"+str(wv)+"_"+str(bwaist)+"_"+str(start_pos)+'.csv'
    np.savetxt(waist_file, waists_values)
    irr_file= fpath+"\\"+str(wv)+"_"+str(bwaist)+"_"+str(start_pos)+ "_irr"'.csv'
    #link.zSaveFile(
    return(waists_values)
    
    
link = pyz.createLink()

link.zLoadFile(file)

link.ipzGetLDE()

link.zSetSurfaceParameter(5, 3,45)
link.zSetSurfaceParameter(7, 3, 45)
link.zSetSurfaceParameter(5, 2,0)
link.zSetSurfaceParameter(7, 2, 0)
#link.zSetSurfaceParameter(6, 6, 0)
#link.zSetSurfaceParameter(4, 1, 10)
#link.zSetSurfaceParameter(6, 1, 0)
#link.zSetSurfaceParameter(6, 6, 1)
#link.zSetSurfaceData(4,54, -47)
#link.zSetSurfaceData(6,54, -47)
link.zSaveFile(file)
"""


link.zSetSurfaceParameter(4, 2, 0)
link.zSetSurfaceParameter(6, 2, 0)

link.zSetSurfaceParameter(4, 6, 1)


"""

link.zSetWave(1, 0.800, 1)
setfile = link.zGetFile().lower().replace('.zmx', '.CFG')
GAUSS_WAIST, WAIST_X, WAIST_Y, DECENTER_X, DECENTER_Y = 0, 1, 2, 3, 4
beam_waist, x_off, y_off = 3, 1,1
S_512 = 6
grid_size=15
cfgfile = link.zSetPOPSettings('irr', setfile, startSurf=2, endSurf=2, field=1, wave=1, beamType=GAUSS_WAIST,
                             paramN=( (WAIST_X, WAIST_Y, DECENTER_X, DECENTER_Y), (beam_waist, beam_waist,
                                     x_off, y_off) ), sampx=S_512, sampy=S_512,
                             widex=grid_size, widey=grid_size, tPow=1)

irr_data, irr_grid_plot = link.zGetPOP(settingsFile=setfile, displayData=True)
print(irr_data)
fpath = r"C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs\image_test"
outfile = (fpath+"\\"+"irrdata.txt")
np.savetxt(outfile, (irr_data.widthX, irr_data.widthY))
pyz.closeLink()

fig = plt.figure(figsize=(10,10))
ax = fig.add_subplot(111)
ax.set_title('Beam Spot on CCD', fontsize=14)

irrmax = np.max(irr_grid_plot)
ext = [-irr_data.widthX/2, irr_data.widthX/2, 
       -irr_data.widthY/2, irr_data.widthY/2]


file = r"C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs\image_test\mtest.zmx"


ax.imshow(irr_grid_plot, extent=ext, cmap = 'jet', vmin=0, vmax=irrmax, origin='upper')
fig.savefig('beam')
