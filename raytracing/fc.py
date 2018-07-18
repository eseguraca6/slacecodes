# -*- coding: utf-8 -*-
"""
Created on Wed Jul 18 11:33:33 2018

@author: pwfa-facet2
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit
#import pyzdde.arraytrace as at
import pyzdde.zdde as pyz

import random as rand


file = r'C:\Users\pwfa-facet2\Desktop\slacecodes\facetcontrol.zmx'

def config_simulation(file, chief_angle1_x,chief_angle1_y, chief_angle1_z, chief_angle2_x,chief_angle2_y, chief_angle2_z):
    link = pyz.createLink()
    link.zLoadFile(file)
    link.zSetWave(1,.800, 1)
    setfile = link.zGetFile().lower().replace('.zmx', '.CFG')
    S_512 = 5
    grid_size = 20
    GAUSS_WAIST, WAIST_X, WAIST_Y, DECENTER_X, DECENTER_Y = 0, 1, 2, 3, 4
    beam_waist, x_off, y_off = 5, 0, 0
    cfgfile = link.zSetPOPSettings('irr', setfile, startSurf=2, endSurf=2, field=1,
                                   wave=1, beamType=GAUSS_WAIST, paramN=( (WAIST_X, WAIST_Y, DECENTER_X, DECENTER_Y), (beam_waist, beam_waist, x_off, y_off) ),
                                   sampx=S_512, sampy=S_512, widex=grid_size, widey=grid_size, tPow=1, auto=0, ignPol=1)
    link.zModifyPOPSettings(cfgfile, endSurf=26)
    link.zModifyPOPSettings(cfgfile, paramN=( (1, 2, 3, 4), (5, 5,
                                     0, 0) ))
    link.zModifyPOPSettings(cfgfile, widex=grid_size)
    link.zModifyPOPSettings(cfgfile, widey=grid_size)
    link.zModifyPOPSettings(cfgfile, ignPol=1)
#1 to ignore pol;0 to use
    link.zSaveFile(file)
    
    link.zSetSurfaceParameter(3,3, chief_angle1_x)
    link.zSetSurfaceParameter(3,4, chief_angle1_y)
    link.zSetSurfaceParameter(3,5, chief_angle1_z)
    
    link.zSetSurfaceParameter(9,3, chief_angle1_x)
    link.zSetSurfaceParameter(9,4, chief_angle1_y)
    link.zSetSurfaceParameter(9,5 , chief_angle1_z)
#var
    link.zSetSurfaceParameter(4, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(4, 4, 0)
    link.zSetSurfaceParameter(4, 5, 0)

    link.zSetSurfaceParameter(8, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(8, 4, 0)
    link.zSetSurfaceParameter(8, 5, 0)
#fix
    link.zSetSurfaceParameter(5, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(5, 4, 0)
    link.zSetSurfaceParameter(5, 5, 0)

    link.zSetSurfaceParameter(7, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(7, 4, 0)
    link.zSetSurfaceParameter(7, 5, 0)
#SAME FOR SECOND MIRROR
    link.zSetSurfaceParameter(12,3, chief_angle2_x)
    link.zSetSurfaceParameter(12,4, chief_angle2_y)
    link.zSetSurfaceParameter(12,5, chief_angle2_z)
    
    link.zSetSurfaceParameter(18,3, chief_angle2_x)
    link.zSetSurfaceParameter(18,4, chief_angle2_y)
    link.zSetSurfaceParameter(18,5, chief_angle2_z)
#var
    link.zSetSurfaceParameter(13, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(13, 4, 0)
    link.zSetSurfaceParameter(13, 5, 0)

    link.zSetSurfaceParameter(17, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(17, 4, 0)
    link.zSetSurfaceParameter(17, 5, 0)
#fix
    link.zSetSurfaceParameter(14, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(14, 4, 0)
    link.zSetSurfaceParameter(14, 5, 0)

    link.zSetSurfaceParameter(16, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(16, 4, 0)
    link.zSetSurfaceParameter(16, 5, 0)
    link.zSaveFile(file)  
    pyz.closeLink()
    print('config set for testing!')
    
    
def standard_var(low_angle, high_angle, file):
    link = pyz.createLink()
    link.zLoadFile(file)
    
    angles= np.arange(low_angle, high_angle+0.01, 0.01)
    beam_x = []
    beam_y = []
    
    #extract at surface 11
    for i in angles:
        #input in zemax system 
        link.zSetSurfaceParameter(4,3,i)
        link.zSetSurfaceParameter(8,3,-i)
        
        link.zSetSurfaceParameter(4,4,i)
        link.zSetSurfaceParameter(8,4,-i)
        link.zSaveFile(file) 
        #get output in surf 12
        offsetx = link.zOperandValue('POPD', 12, 1, 0, 11)
        offsety = link.zOperandValue('POPD', 12, 1, 0, 12)  
        beam_x.append(offsetx)
        beam_y.append(offsety) 
    np.savetxt(r'C:\Users\pwfa-facet2\Desktop\slacecodes\xyvar_400_700'+'.csv', list(zip(angles, beam_x, beam_y)))
    print('done')
config_simulation(file, 45,0,0,-45,0,0)
standard_var(-1,1,file)
