# -*- coding: utf-8 -*-
"""
Created on Wed Aug  1 15:08:55 2018

@author: pwfa-facet2
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit
#import pyzdde.arraytrace as at
import pyzdde.zdde as pyz

import random as rand


file = r'C:\Users\pwfa-facet2\Desktop\slacecodes\raytracing\4fc.zmx'

configuration_angles =  [0, -45,
                         0 ,45,
                         -45,0,
                         45,0]
                         
                         #[45, 0, 0, -45, 0,-45, 0, 45, 0, -45, 45, 0]

def chief_surface(file, surface, anglex, angley):
    link = pyz.createLink()
    link.zLoadFile(file)
    
    #chief x
    link.zSetSurfaceParameter(surface, 3, anglex)
    link.zSetSurfaceParameter(surface+6, 3, anglex)
    #chief y
    link.zSetSurfaceParameter(surface, 4, angley)
    link.zSetSurfaceParameter(surface+6, 4, angley)
    #chief z
    link.zSetSurfaceParameter(surface, 5, 0)
    link.zSetSurfaceParameter(surface+6, 5, 0)
    link.zSaveFile(file) 
    pyz.closeLink()
    
def set_start_vars_fix(file):
    link= pyz.createLink()
    link.zLoadFile(file)
#var
    link.zSetSurfaceParameter(3, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(3, 4, 0)
    link.zSetSurfaceParameter(3, 5, 0)

    link.zSetSurfaceParameter(7, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(7, 4, 0)
    link.zSetSurfaceParameter(7, 5, 0)

#fix
    link.zSetSurfaceParameter(4, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(4, 4, 0)
    link.zSetSurfaceParameter(4, 5, 0)
    
    link.zSetSurfaceParameter(6, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(6, 4, 0)
    link.zSetSurfaceParameter(6, 5, 0)

#var
    link.zSetSurfaceParameter(12, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(12, 4, 0)
    link.zSetSurfaceParameter(12, 5, 0)

    link.zSetSurfaceParameter(16, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(16, 4, 0)
    link.zSetSurfaceParameter(16, 5, 0)
#fix
    link.zSetSurfaceParameter(13, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(13, 4, 0)
    link.zSetSurfaceParameter(13, 5, 0)

    link.zSetSurfaceParameter(15, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(15, 4, 0)
    link.zSetSurfaceParameter(15, 5, 0)

#var
    link.zSetSurfaceParameter(23, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(23, 4, 0)
    link.zSetSurfaceParameter(23, 5, 0)

    link.zSetSurfaceParameter(27, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(27, 4, 0)
    link.zSetSurfaceParameter(27, 5, 0)
#fix
    link.zSetSurfaceParameter(24, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(24, 4, 0)
    link.zSetSurfaceParameter(24, 5, 0)

    link.zSetSurfaceParameter(26, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(26, 4, 0)
    link.zSetSurfaceParameter(26, 5, 0)
    link.zSaveFile(file)
    pyz.closeLink()

def config_simulation(file, conf_array):
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
    
    chief_angle1_x = conf_array[0]
    chief_angle1_y = conf_array[1]
    
    chief_angle2_x = conf_array[2]
    chief_angle2_y = conf_array[3]
    
    chief_angle3_x = conf_array[4]
    chief_angle3_y = conf_array[5]
    
    chief_surface(file, 2, chief_angle1_x, chief_angle1_y)
    chief_surface(file, 11, chief_angle2_x, chief_angle2_y)
    chief_surface(file, 22, chief_angle3_x, chief_angle3_y)
    
    set_start_vars_fix(file)
    
    link.zSaveFile(file)  
    pyz.closeLink()
    print('config set for testing!')

var_vec = [.12, .15, .23] #[0.0527, 0.0624, 0.0718, 0.1029]
def surface_control_xcorr(file, surface_num, val):
    link = pyz.createLink()
    link.zLoadFile(file)
    link.zSetSurfaceParameter(surface_num, 3, val)
    link.zSetSurfaceParameter(surface_num+2, 3, -val)
    link.zSaveFile(file)  
    pyz.closeLink()
    
def surface_control_ycorr(file, surface_num, val):
    link = pyz.createLink()
    link.zLoadFile(file)
    link.zSetSurfaceParameter(surface_num, 4, val)
    link.zSetSurfaceParameter(surface_num+2, 4, -val)
    link.zSaveFile(file)  
    pyz.closeLink()
    
def surface_control_xvar(file, surface_num, val):
    link = pyz.createLink()
    link.zLoadFile(file)
    link.zSetSurfaceParameter(surface_num, 3, val)
    link.zSetSurfaceParameter(surface_num+4, 3, -val)
    link.zSaveFile(file)  
    pyz.closeLink()
    
def surface_control_yvar(file, surface_num, val):
    link = pyz.createLink()
    link.zLoadFile(file)
    link.zSetSurfaceParameter(surface_num, 4, val)
    link.zSetSurfaceParameter(surface_num+4, 4, -val)
    link.zSaveFile(file)  
    pyz.closeLink()

beam_pos =[]

def ccd_screens(file):
    link = pyz.createLink()
    link.zLoadFile(file)
    ccd1x = link.zOperandValue('POPD', 10, 1, 0, 11)
    ccd1y = link.zOperandValue('POPD', 10, 1, 0, 12)
    
    ccd2x = link.zOperandValue('POPD', 21, 1, 0, 11)
    ccd2y = link.zOperandValue('POPD', 21, 1, 0, 12)

    ccd3x = link.zOperandValue('POPD', 34, 1, 0, 11)
    ccd3y = link.zOperandValue('POPD', 34, 1, 0, 12)

    #ccd4x = link.zOperandValue('POPD', 37, 1, 0, 11)
    #ccd4y = link.zOperandValue('POPD', 37, 1, 0, 12)

    
    
    beam_pos_vec = np.matrix([ [ccd1x], [ccd1y],
                              [ccd2x], [ccd2y],
                              [ccd3x], [ccd3y]])

    pyz.closeLink()
    return(beam_pos_vec)
    
r = np.arange(-1,1.1,0.1)
beam_1x =[]
beam_1y =[]
beam_2x =[]
beam_2y =[]
beam_3x =[]
beam_3y =[]

config_simulation(file, configuration_angles)
for i in r:
    surface_control_xvar(file,3,i)
    surface_control_xvar(file, 12,i)
    surface_control_xvar(file, 23,i)
    
    surface_control_yvar(file,3,i)
    surface_control_yvar(file, 12,i)
    surface_control_yvar(file, 23,i)
    
    curr_beam_pos = ccd_screens(file)
    
    beam_1x.append(curr_beam_pos.item(0))
    beam_1y.append(curr_beam_pos.item(1))
    
    beam_2x.append(curr_beam_pos.item(2))
    beam_2y.append(curr_beam_pos.item(3))
    
    beam_3x.append(curr_beam_pos.item(4))
    beam_3y.append(curr_beam_pos.item(5))

    print('not done')
    
print('finally done')
np.savetxt(r'C:\Users\pwfa-facet2\Desktop\slacecodes\raytracing\testm3config.csv', \
               list(zip(beam_1x, beam_1y, beam_2x, beam_2y, \
                        beam_3x, beam_3y)))
    