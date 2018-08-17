# -*- coding: utf-8 -*-
"""
Created on Tue Aug 14 16:13:36 2018

@author: pwfa-facet2
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit
#import pyzdde.arraytrace as at
import pyzdde.zdde as pyz

import random as rand


file = r'C:\Users\pwfa-facet2\Desktop\slacecodes\zcam.zmx'

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
    
    ccd2x = link.zOperandValue('POPD', 19, 1, 0, 11)
    ccd2y = link.zOperandValue('POPD', 19, 1, 0, 12)

    ccd3x = link.zOperandValue('POPD', 19, 1, 0, 11)
    ccd3y = link.zOperandValue('POPD', 19, 1, 0, 12)

    #ccd4x = link.zOperandValue('POPD', 37, 1, 0, 11)
    #ccd4y = link.zOperandValue('POPD', 37, 1, 0, 12)

    
    
    beam_pos_vec = np.matrix([ [ccd1x], [ccd1y],
                              [ccd2x], [ccd2y],
                              [ccd3x], [ccd3y]])

    pyz.closeLink()
    return(beam_pos_vec)
def algo_facet2_var(file, var_arr):
    link = pyz.createLink()
    link.zLoadFile(file)
    l_var = -var_arr[0]
    h_var = var_arr[0]
    var1x = np.random.uniform(l_var, h_var)
    var1y = np.random.uniform(l_var, h_var)
    l_var = -var_arr[1]
    h_var = var_arr[1]
    var2x = np.random.uniform(l_var, h_var)
    var2y = np.random.uniform(l_var, h_var)
    h_var = var_arr[2]
    l_var = -var_arr[2]
    var3x = np.random.uniform(l_var, h_var)
    var3y = np.random.uniform(l_var, h_var)
    #h_var = var_arr[3]
    #var4x = np.random.uniform(l_var, h_var)
    #var4y = np.random.uniform(l_var, h_var)

    vec = np.matrix([ 
            [var1x],
            [var1y],
            [var2x],
            [var2y],
            [var3x],
            [var3y]])
    """
            [var4x],
            [var4y]])
    """
    print('input variations:')
    print(np.transpose(vec))
    #var M1
    surface_control_xvar(file, 3, var1x)
    surface_control_yvar(file, 3, var1y)
    
    surface_control_xvar(file, 12, var2x)
    surface_control_yvar(file, 12, var2y)
    
    surface_control_xvar(file, 23, var3x)
    surface_control_yvar(file, 23, var3y)
    
    #surface_control_xvar(file, 30, var4x)
    #surface_control_yvar(file, 30, var4y)
    print('variations finished')
    print('======')
    pyz.closeLink()
    np.savetxt(r'C:\Users\pwfa-facet2\Desktop\slacecodes\raytracing\zcam-var.csv', vec)
    return(vec)
def ccd_vector(file):
    link=pyz.createLink()
    link.zLoadFile(file)
    arr = []
    ccd1x = link.zOperandValue('POPD', 10, 1, 0, 11)
    ccd1y = link.zOperandValue('POPD', 10, 1, 0, 12)
    ccd2x = link.zOperandValue('POPD', 19, 1, 0, 11)
    ccd2y = link.zOperandValue('POPD', 19, 1, 0, 12)
    ccd3x = link.zOperandValue('POPD', 28, 1, 0, 11)
    ccd3y = link.zOperandValue('POPD', 28, 1, 0, 12)
    
    ccd4x = link.zOperandValue('POPD', 37, 1, 0, 11)
    ccd4y = link.zOperandValue('POPD', 37, 1, 0, 12)
    ccd5x = link.zOperandValue('POPD', 46, 1, 0, 11)
    ccd5y = link.zOperandValue('POPD', 46, 1, 0, 12)
    ccd6x = link.zOperandValue('POPD', 55, 1, 0, 11)
    ccd6y = link.zOperandValue('POPD', 55, 1, 0, 12)
    arr =[ccd1x,ccd1y, ccd2x,ccd2y, ccd3x,ccd3y,
          ccd4x,ccd4y, ccd5x,ccd5y, ccd6x,ccd6y]
    pyz.closeLink()
    return(arr) 
def set_start_vars_fix(file):
    link= pyz.createLink()
    link.zLoadFile(file)
    surface_control_xvar(file, 3, 0)
    surface_control_yvar(file, 3, 0)
    surface_control_xcorr(file, 4, 0)
    surface_control_ycorr(file, 4, 0)
    
    surface_control_xvar(file, 12, 0)
    surface_control_yvar(file, 12, 0)
    surface_control_xcorr(file, 13, 0)
    surface_control_ycorr(file, 13, 0)
    
    surface_control_xvar(file, 21, 0)
    surface_control_yvar(file, 21, 0)
    surface_control_xcorr(file, 22, 0)
    surface_control_ycorr(file, 22, 0)
    
    surface_control_xvar(file, 30, 0)
    surface_control_yvar(file, 30, 0)
    surface_control_xcorr(file, 31, 0)
    surface_control_ycorr(file, 31, 0)
    
    surface_control_xvar(file, 39, 0)
    surface_control_yvar(file, 39, 0)
    surface_control_xcorr(file, 40, 0)
    surface_control_ycorr(file, 40, 0)
    
    surface_control_xvar(file, 48, 0)
    surface_control_yvar(file, 48, 0)
    surface_control_xcorr(file, 49, 0)
    surface_control_ycorr(file, 49, 0)
    
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

    chief_angle4_x = conf_array[6]
    chief_angle4_y = conf_array[7]
    
    chief_angle5_x = conf_array[8]
    chief_angle5_y = conf_array[9]
    
    chief_angle6_x = conf_array[10]
    chief_angle6_y = conf_array[11]
    
    chief_surface(file, 2, chief_angle1_x, chief_angle1_y)
    chief_surface(file, 11, chief_angle2_x, chief_angle2_y)
    chief_surface(file, 20, chief_angle3_x, chief_angle3_y)
    
    chief_surface(file, 29, chief_angle4_x, chief_angle4_y)
    chief_surface(file, 38, chief_angle5_x, chief_angle5_y)
    chief_surface(file, 47, chief_angle6_x, chief_angle6_y)
    
    
    set_start_vars_fix(file)
    
    link.zSaveFile(file)  
    pyz.closeLink()
    print('config set for testing!') 
#execute variations 
configuration_angles = [0, -45, 0, 45, 45, 0, -45,0,0,45,45,0];
config_simulation(file, configuration_angles)

def callibration(file):
    vec1x =[]
    vec1y=[]
    vec2x =[]
    vec2y=[]
    vec3x =[]
    vec3y=[]
    vec4x =[]
    vec4y=[]
    vec5x =[]
    vec5y=[]
    vec6x =[]
    vec6y=[]
    for i in range(1,13):
        pos = [3, 12, 21, 30, 39, 48]
        if i == 1:
            #this is mirror 1
            surface_control_xvar(file, 3, 1 )
            vec1x = ccd_vector(file);
            print('vec1x:')
            print(vec1x)
            surface_control_xvar(file, 3, 0)
            print('clean-up:')
            t = ccd_vector(file)
            print(t)
        elif i == 2:
            #this is mirror 1
            surface_control_yvar(file, 3, 1 )
            vec1y = ccd_vector(file);
            print('vec1y:')
            print(vec1y)
            surface_control_yvar(file, 3, 0)
            print('clean-up:')
            t = ccd_vector(file)
            print(t)
        elif i == 3:
            #this is mirror 1
            surface_control_xvar(file, 12, 1 )
            vec2x = ccd_vector(file)
            print('vec2x:')
            print(vec2x)
            surface_control_xvar(file, 12, 0)
            print('clean-up:')
            t = ccd_vector(file)
            print(t)
        elif i == 4:
            #this is mirror 1
            surface_control_yvar(file, 12, 1 )
            vec2y = ccd_vector(file);
            print('vec2y:')
            print(vec2y)
            surface_control_yvar(file, 12, 0)
            print('clean-up:')
            t = ccd_vector(file)
            print(t)
        elif i == 5:
            #this is mirror 1
            surface_control_xvar(file, 21, 1 )
            vec3x = ccd_vector(file);
            print('vec3x:')
            print(vec3x)
            surface_control_xvar(file, 21, 0)
            print('clean-up:')
            t = ccd_vector(file)
            print(t)
        elif i == 6:
            #this is mirror 1
            surface_control_yvar(file, 21, 1 )
            vec3y = ccd_vector(file);
            print('vec3y:')
            print(vec3y)
            surface_control_yvar(file, 21, 0)
            print('clean-up:')
            t = ccd_vector(file)
            print(t) 
        elif i == 7:
            #this is mirror 1
            surface_control_xvar(file, 30, 1 )
            vec4x = ccd_vector(file);
            print('vec1x:')
            print(vec4x)
            surface_control_xvar(file, 30, 0)
            print('clean-up:')
            t = ccd_vector(file)
            print(t)
        elif i == 8:
            #this is mirror 1
            surface_control_yvar(file, 30, 1 )
            vec4y = ccd_vector(file);
            print('vec4y:')
            print(vec4y)
            surface_control_yvar(file, 30, 0)
            print('clean-up:')
            t = ccd_vector(file)
            print(t)
        elif i == 9:
            #this is mirror 1
            surface_control_xvar(file, 39, 1 )
            vec5x = ccd_vector(file)
            print('vec5x:')
            print(vec5x)
            surface_control_xvar(file, 39, 0)
            print('clean-up:')
            t = ccd_vector(file)
            print(t)
        elif i == 10:
            #this is mirror 1
            surface_control_yvar(file, 39, 1 )
            vec5y = ccd_vector(file);
            print('vec5y:')
            print(vec5y)
            surface_control_yvar(file, 39, 0)
            print('clean-up:')
            t = ccd_vector(file)
            print(t)
        elif i == 11:
            #this is mirror 1
            surface_control_xvar(file, 48, 1 )
            vec6x = ccd_vector(file);
            print('vec6x:')
            print(vec6x)
            surface_control_xvar(file, 48, 0)
            print('clean-up:')
            t = ccd_vector(file)
            print(t)
        elif i == 12:
            #this is mirror 1
            surface_control_yvar(file, 48, 1 )
            vec6y = ccd_vector(file);
            print('vec6y:')
            print(vec6y)
            surface_control_yvar(file, 48, 0)
            print('clean-up:')
            t = ccd_vector(file)
            print(t) 
    c_m = np.column_stack((vec1x, vec1y,vec2x, vec2y,vec3x, vec3y,vec4x, vec4y,vec5x, vec5y,vec6x, vec6y))
    print('c_m')
    print(repr(c_m))
    np.savetxt('zmat'+'.csv', list(zip(vec1x, vec1y,vec2x, vec2y,vec3x, vec3y,vec4x, vec4y,vec5x, vec5y,vec6x, vec6y)))


#surface_control_yvar(file,20,1)
#print(ccd_vector(file))

callibration(file)