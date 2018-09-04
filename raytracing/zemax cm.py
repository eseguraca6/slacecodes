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


file = r'C:\Users\pwfa-facet2\Desktop\slacecodes\zcam.zmx'

                         #[45, 0, 0, -45, 0,-45, 0, 45, 0, -45, 45, 0]

def chief_surface(file, surface, anglex, angley):
    link = pyz.createLink()
    link.zLoadFile(file)
    
    #chief x
    link.zSetSurfaceParameter(surface,3, anglex)
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
    link.zSetSurfaceParameter(15, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(15, 4, 0)
    link.zSetSurfaceParameter(15, 5, 0)

    link.zSetSurfaceParameter(19, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(19, 4, 0)
    link.zSetSurfaceParameter(19, 5, 0)
#fix
    link.zSetSurfaceParameter(16, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(16, 4, 0)
    link.zSetSurfaceParameter(16, 5, 0)

    link.zSetSurfaceParameter(19, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(19, 4, 0)
    link.zSetSurfaceParameter(19, 5, 0)

#var
    link.zSetSurfaceParameter(27, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(27, 4, 0)
    link.zSetSurfaceParameter(27, 5, 0)

    link.zSetSurfaceParameter(32, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(32, 4, 0)
    link.zSetSurfaceParameter(32, 5, 0)
#fix
    link.zSetSurfaceParameter(28, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(28, 4, 0)
    link.zSetSurfaceParameter(28, 5, 0)

    link.zSetSurfaceParameter(30, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(30, 4, 0)
    link.zSetSurfaceParameter(30, 5, 0)
    
#var
    link.zSetSurfaceParameter(36, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(36, 4, 0)
    link.zSetSurfaceParameter(36, 5, 0)

    link.zSetSurfaceParameter(40, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(40, 4, 0)
    link.zSetSurfaceParameter(40, 5, 0)

#fix
    link.zSetSurfaceParameter(37, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(37, 4, 0)
    link.zSetSurfaceParameter(37, 5, 0)
    
    link.zSetSurfaceParameter(39, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(39, 4, 0)
    link.zSetSurfaceParameter(39, 5, 0)

#var
    link.zSetSurfaceParameter(48, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(48, 4, 0)
    link.zSetSurfaceParameter(48, 5, 0)

    link.zSetSurfaceParameter(52, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(52, 4, 0)
    link.zSetSurfaceParameter(52, 5, 0)
#fix
    link.zSetSurfaceParameter(49, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(49, 4, 0)
    link.zSetSurfaceParameter(49, 5, 0)

    link.zSetSurfaceParameter(51, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(51, 4, 0)
    link.zSetSurfaceParameter(51, 5, 0)

#var
    link.zSetSurfaceParameter(57, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(57, 4, 0)
    link.zSetSurfaceParameter(57, 5, 0)

    link.zSetSurfaceParameter(61, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(61, 4, 0)
    link.zSetSurfaceParameter(61, 5, 0)
#fix
    link.zSetSurfaceParameter(58, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(58, 4, 0)
    link.zSetSurfaceParameter(58, 5, 0)

    link.zSetSurfaceParameter(60, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(60, 4, 0)
    link.zSetSurfaceParameter(60, 5, 0)
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
    chief_surface(file, 14, chief_angle2_x, chief_angle2_y)
    chief_surface(file, 26, chief_angle3_x, chief_angle3_y)
    
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
    ccd1x = link.zOperandValue('POPD', 13, 1, 0, 11)
    ccd1y = link.zOperandValue('POPD', 13, 1, 0, 12)
    
    ccd2x = link.zOperandValue('POPD', 25, 1, 0, 11)
    ccd2y = link.zOperandValue('POPD', 25, 1, 0, 12)

    ccd3x = link.zOperandValue('POPD', 34, 1, 0, 11)
    ccd3y = link.zOperandValue('POPD', 34, 1, 0, 12)

    ccd4x = link.zOperandValue('POPD', 46, 1, 0, 11)
    ccd4y = link.zOperandValue('POPD', 46, 1, 0, 12)
    
    ccd5x = link.zOperandValue('POPD', 55, 1, 0, 11)
    ccd5y = link.zOperandValue('POPD', 55, 1, 0, 12)

    ccd6x = link.zOperandValue('POPD', 67, 1, 0, 11)
    ccd6y = link.zOperandValue('POPD', 67, 1, 0, 12)

    #ccd4x = link.zOperandValue('POPD', 37, 1, 0, 11)
    #ccd4y = link.zOperandValue('POPD', 37, 1, 0, 12)

    
    
    beam_pos_vec = np.matrix([ [ccd1x], [ccd1y],
                              [ccd2x], [ccd2y],
                              [ccd3x], [ccd3y],
                              [ccd4x], [ccd4y],
                              [ccd5x], [ccd5y],
                              [ccd6x], [ccd6y]
                              ])

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
    h_var = var_arr[3]
    var4x = np.random.uniform(l_var, h_var)
    var4y = np.random.uniform(l_var, h_var)
    h_var = var_arr[4]
    var5x = np.random.uniform(l_var, h_var)
    var5y = np.random.uniform(l_var, h_var)
    h_var = var_arr[5]
    var6x = np.random.uniform(l_var, h_var)
    var6y = np.random.uniform(l_var, h_var)
    vec = np.matrix([ 
            [var1x],
            [var1y],
            [var2x],
            [var2y],
            [var3x],
            [var3y],
            [var4x],
            [var4y],
            [var5x],
            [var5y],
            [var6x],
            [var6y]])

    print('input variations:')
    print(np.transpose(vec))
    #var M1
    surface_control_xvar(file, 3, var1x)
    surface_control_yvar(file, 3, var1y)
    
    surface_control_xvar(file, 15, var2x)
    surface_control_yvar(file, 15, var2y)
    
    surface_control_xvar(file, 27, var3x)
    surface_control_yvar(file, 27, var3y)
    
    surface_control_xvar(file, 36, var4x)
    surface_control_yvar(file, 36, var4y)
    
    surface_control_xvar(file, 48, var5x)
    surface_control_yvar(file, 48, var5y)
    
    surface_control_xvar(file, 57, var6x)
    surface_control_yvar(file, 57, var6y)
        
    print('variations finished')
    print('======')
    pyz.closeLink()
    np.savetxt(r'C:\Users\pwfa-facet2\Desktop\slacecodes\raytracing\zcam-varwithlenses.csv', vec)
    return(vec)
def ccd_vector(file):
    link=pyz.createLink()
    link.zLoadFile(file)
    arr = []
    ccd1x = link.zOperandValue('POPD', 13, 1, 0, 11)
    ccd1y = link.zOperandValue('POPD', 13, 1, 0, 12)
    ccd2x = link.zOperandValue('POPD', 25, 1, 0, 11)
    ccd2y = link.zOperandValue('POPD', 25, 1, 0, 12)
    ccd3x = link.zOperandValue('POPD', 34, 1, 0, 11)
    ccd3y = link.zOperandValue('POPD', 34, 1, 0, 12)
    arr =[ccd1x,ccd1y, ccd2x,ccd2y, ccd3x,ccd3y]
    pyz.closeLink()
    return(arr) 
r = np.arange(-1,1.1,0.1)
beam_1x =[]
beam_1y =[]
beam_2x =[]
beam_2y =[]
beam_3x =[]
beam_3y =[]
beam_4x =[]
beam_4y =[]
beam_5x =[]
beam_5y =[]
beam_6x =[]
beam_6y =[]



c_m =np.matrix([[ 6.07834809e-01, -6.96633255e+01,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00],
       [ 4.92469225e+01,  0.00000000e+00,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00],
       [ 3.10661640e-01, -3.53511012e+01,  8.82415130e-01,
         1.01131537e+02,  0.00000000e+00,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00],
       [ 2.51698809e+01,  0.00000000e+00, -7.14934863e+01,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00],
       [-3.58080135e-01,  4.16968983e+01,  2.62916396e+00,
         3.01321826e+02,  0.00000000e+00, -1.51098045e+02,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00],
       [-2.90117387e+01,  0.00000000e+00, -2.13015497e+02,
         0.00000000e+00,  2.13750030e+02,  1.86494194e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00],
       [-5.84199395e-01,  6.77188715e+01,  3.10993563e+00,
         3.55834384e+02,  0.00000000e+00, -1.97678482e+02,
         0.00000000e+00,  5.61007094e+01,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00],
       [-4.73319756e+01,  0.00000000e+00, -2.51967733e+02,
         0.00000000e+00,  2.79402160e+02,  2.43986540e+00,
        -7.93604660e+01,  6.92428323e-01,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00],
       [-7.72127096e-01,  8.85268220e+01,  3.76004198e-01,
         4.04136283e+01,  0.00000000e+00, -1.06730593e+02,
         0.00000000e+00,  2.51705443e+02, -3.57641693e+00,
        -4.09910469e+02,  0.00000000e+00,  0.00000000e+00],
       [-6.25579232e+01,  0.00000000e+00, -3.04639506e+01,
         0.00000000e+00,  1.49986646e+02,  1.31733246e+00,
        -3.56002211e+02,  3.10669828e+00,  2.89762161e+02,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00],
       [-4.90167437e-01,  5.59997654e+01, -4.47258586e-01,
        -5.33218959e+01,  0.00000000e+00, -3.92914981e+01,
         0.00000000e+00,  1.91688660e+02, -2.91458963e+00,
        -3.32482159e+02,  0.00000000e+00,  7.03393548e+01],
       [-3.97134838e+01,  0.00000000e+00,  3.62369983e+01,
         0.00000000e+00,  5.46823337e+01,  4.84959040e-01,
        -2.70010378e+02,  2.36593546e+00,  2.36140754e+02,
         0.00000000e+00, -9.94998148e+01, -8.68170153e-01]])

np.savetxt('zmatrix'+'.csv', c_m)
    
def algo_fix(file):
    link=pyz.createLink()
    link.zLoadFile(file)
    
    #extract current beam positions
    curr_beam_vec = ccd_screens(file)
    print('current beam offset position:')
    print(np.transpose(curr_beam_vec))
    
    beam1x=[]
    beam2x=[]
    beam3x=[]
    beam1y=[]
    beam2y=[]
    beam3y=[]
    
    beam4x=[]
    beam4y=[]
    beam5x=[]
    beam5y=[]
    beam6x=[]
    beam6y=[]
    
    beam1x.append(curr_beam_vec.item(0))
    beam2x.append(curr_beam_vec.item(2))
    beam3x.append(curr_beam_vec.item(4))
    
    beam1y.append(curr_beam_vec.item(1))
    beam2y.append(curr_beam_vec.item(3))
    beam3y.append(curr_beam_vec.item(5))    
    
    beam4x.append(curr_beam_vec.item(6))
    beam5x.append(curr_beam_vec.item(8))
    beam6x.append(curr_beam_vec.item(10))
    
    beam4y.append(curr_beam_vec.item(7))
    beam5y.append(curr_beam_vec.item(9))
    beam6y.append(curr_beam_vec.item(11))    
    
    int1x=[]
    int2x=[]
    int3x=[]
    
    int1y=[]
    int2y=[]
    int3y=[]
    
    int4x=[]
    int5x=[]
    int6x=[]
    
    int4y=[]
    int5y=[]
    int6y=[]
    
    int1x.append(curr_beam_vec.item(0))
    int2x.append(curr_beam_vec.item(2))
    int3x.append(curr_beam_vec.item(4))
    
    int1y.append(curr_beam_vec.item(1))
    int2y.append(curr_beam_vec.item(3))
    int3y.append(curr_beam_vec.item(5))    
    
    int4x.append(curr_beam_vec.item(6))
    int5x.append(curr_beam_vec.item(8))
    int6x.append(curr_beam_vec.item(10))
    
    int4y.append(curr_beam_vec.item(7))
    int5y.append(curr_beam_vec.item(9))
    int6y.append(curr_beam_vec.item(11))  
    
    #extract variations 
    finv = np.linalg.inv(c_m)
    curr_var_vec = np.matmul(finv, curr_beam_vec)
    
    
    print('=======')
    print('current variations:')
    print(np.transpose(curr_var_vec))

    pyz.closeLink() 
    #np.savetxt(r'C:\Users\pwfa-facet2\Desktop\slacecodes\raytracing\zemax-pred.csv',np.c_[curr_beam_vec, curr_var_vec], fmt='%.18e')
    
    
    #feed initial corrections
    
    surface_control_xcorr(file, 4, -1*curr_var_vec.item(0))
    surface_control_xcorr(file, 16, -1*curr_var_vec.item(2))
    surface_control_xcorr(file, 28, -1*curr_var_vec.item(4))
    
    surface_control_ycorr(file, 4, -1*curr_var_vec.item(1))
    surface_control_ycorr(file, 16, -1*curr_var_vec.item(3))
    surface_control_ycorr(file, 28, -1*curr_var_vec.item(5))
    
    surface_control_xcorr(file, 37, -1*curr_var_vec.item(6))
    surface_control_xcorr(file, 49, -1*curr_var_vec.item(8))
    surface_control_xcorr(file, 58, -1*curr_var_vec.item(10))
    
    surface_control_ycorr(file, 37, -1*curr_var_vec.item(7))
    surface_control_ycorr(file, 49, -1*curr_var_vec.item(9))
    surface_control_ycorr(file, 58, -1*curr_var_vec.item(11))
 
    status = 'not done'
    
    var1x=[]
    var2x=[]
    var3x=[]
    
    var1y=[]
    var2y=[]
    var3y=[]
    
    var4x=[]
    var5x=[]
    var6x=[]
    
    var4y=[]
    var5y=[]
    var6y=[]
    
    var1x=[]
    var2x=[]
    var3x=[]
    
    var1y=[]
    var2y=[]
    var3y=[]
    
    var4x=[]
    var5x=[]
    var6x=[]
    
    var4y=[]
    var5y=[]
    var6y=[]
      

    var1x.append(curr_var_vec.item(0))
    var1y.append(curr_var_vec.item(1))
    
    var2x.append(curr_var_vec.item(2))
    var2y.append(curr_var_vec.item(3))
    
    var3x.append(curr_var_vec.item(4))
    var3y.append(curr_var_vec.item(5))
    
    var4x.append(curr_var_vec.item(6))
    var4y.append(curr_var_vec.item(7))
    
    var5x.append(curr_var_vec.item(8))
    var5y.append(curr_var_vec.item(9))
    
    var6x.append(curr_var_vec.item(10))
    var6y.append(curr_var_vec.item(11))
    i =0
    
    int_mat = np.ones((4,10))
    
    while status == 'not done':
        print('current iteration:', i)
        beam_mod = ccd_screens(file);
        print('current vector:')
        
        print(np.transpose(beam_mod))
        
        beam1x.append(beam_mod.item(0))
        beam2x.append(beam_mod.item(2))
        beam3x.append(beam_mod.item(4))
        
        beam1y.append(beam_mod.item(1))
        beam2y.append(beam_mod.item(3))
        beam3y.append(beam_mod.item(5))
        
        beam4x.append(beam_mod.item(6))
        beam5x.append(beam_mod.item(8))
        beam6x.append(beam_mod.item(10))
        
        beam4y.append(beam_mod.item(7))
        beam5y.append(beam_mod.item(9))
        beam6y.append(beam_mod.item(11))


        int1x.append(beam1x[i]+beam_mod.item(0))
        int2x.append(beam2x[i]+beam_mod.item(2))
        int3x.append(beam3x[i]+beam_mod.item(4))
    
        int1y.append(beam1y[i]+beam_mod.item(1))
        int2y.append(beam2y[i]+beam_mod.item(3))
        int3y.append(beam3y[i]+beam_mod.item(5))    
    
        int4x.append(beam4x[i]+beam_mod.item(6))
        int5x.append(beam5x[i]+beam_mod.item(8))
        int6x.append(beam6x[i]+beam_mod.item(10))
    
        int4y.append(beam4y[i]+beam_mod.item(7))
        int5y.append(beam5y[i]+beam_mod.item(9))
        int6y.append(beam6y[i]+beam_mod.item(11))
          
        if np.abs(beam_mod.item(0)) <= .0001 and np.abs(beam_mod.item(1)) <= .0001 and \
          np.abs(beam_mod.item(2)) <= .0001 and np.abs(beam_mod.item(3)) <= .0001 and \
           np.abs(beam_mod.item(4)) <= .0001 and np.abs(beam_mod.item(5)) <= .0001 and \
           np.abs(beam_mod.item(6)) <= .0001 and np.abs(beam_mod.item(7)) <= .0001 and \
          np.abs(beam_mod.item(8)) <= .0001 and np.abs(beam_mod.item(9)) <= .0001 and \
           np.abs(beam_mod.item(10)) <= .0001 and np.abs(beam_mod.item(11)) <= .0001:
           
            status = "done"
            pyz.closeLink()
            np.savetxt('var3mirlowrangewithlenses'+'.csv', list(zip(var1x, var1y,var2x, var2y,var3x, var3y, \
                                                       var4x, var4y,var5x, var5y,var6x, var6y, \
                                                       beam1x, beam1y,beam2x, beam2y,beam3x, beam3y, \
                                                       beam4x, beam4y,beam5x, beam5y,beam6x, beam6y)))
        #get new variations
        elif i == 10:
            status = "done"
            pyz.closeLink()
        else:    
            curr_vars = np.matmul(finv, beam_mod)
            curr_int_comp = np.matrix([ [int1x[i+1]],[int1y[i+1]],
                                        [int2x[i+1]],[int2y[i+1]],   
                                        [int3x[i+1]],[int3y[i+1]],
                                        [int4x[i+1]],[int4y[i+1]],
                                        [int5x[i+1]],[int5y[i+1]],
                                        [int6x[i+1]],[int6y[i+1]]
                                        ])
            curr_int_vars = np.matmul(finv,curr_int_comp)
            print('integral raw:')
            print(curr_int_vars)
            
            
            print("new variations to add:")
            print(curr_vars)
            factor_p = 1
            n_v1x = 1*(curr_vars.item(0) + factor_p*var1x[i]) #+ 1*curr_int_vars.item(0)
            n_v1y = 1*(curr_vars.item(1) + factor_p*var1y[i])#+ 1*curr_int_vars.item(1)
            n_v2x = 1*(curr_vars.item(2) + factor_p*var2x[i])#+ 1*curr_int_vars.item(2)
            n_v2y = 1*(curr_vars.item(3) + factor_p*var2y[i])#+ 1*curr_int_vars.item(3)
            n_v3x = 1*(curr_vars.item(4) +factor_p*var3x[i])#+ 1*curr_int_vars.item(4)
            n_v3y = 1*(curr_vars.item(5) + var3y[i])#+ 1*curr_int_vars.item(5)
            
            n_v4x = 1*(curr_vars.item(6) + factor_p*var4x[i])#+ 1*curr_int_vars.item(6)
            n_v4y = 1*(curr_vars.item(7) + factor_p*var4y[i])#+ 1*curr_int_vars.item(7)
            n_v5x = 1*(curr_vars.item(8) + factor_p*var5x[i])#+ 1*curr_int_vars.item(8)
            n_v5y = 1*(curr_vars.item(9) + factor_p*var5y[i])#+ 1*curr_int_vars.item(9)
            n_v6x = 1*(curr_vars.item(10) +factor_p*var6x[i])#+ 1*curr_int_vars.item(10)
            n_v6y = 1*(curr_vars.item(11) +factor_p*var6y[i])#+ 1*curr_int_vars.item(11)
            
            var1x.append(n_v1x)
            var2x.append(n_v2x)
            var3x.append(n_v3x)
    
            var1y.append(n_v1y)
            var2y.append(n_v2y)
            var3y.append(n_v3y)  
            
            var4x.append(n_v4x)
            var5x.append(n_v5x)
            var6x.append(n_v6x)
    
            var4y.append(n_v4y)
            var5y.append(n_v5y)
            var6y.append(n_v6y)  
            
            surface_control_xcorr(file, 4, -n_v1x)
            surface_control_xcorr(file, 16, -n_v2x)
            surface_control_xcorr(file, 28, -n_v3x)
    
            surface_control_ycorr(file, 4, -n_v1y)
            surface_control_ycorr(file, 16, -n_v2y)
            surface_control_ycorr(file, 28, -n_v3y)
            
            surface_control_xcorr(file, 37, -n_v4x)
            surface_control_xcorr(file, 49, -n_v5x)
            surface_control_xcorr(file, 58, -n_v6x)
    
            surface_control_ycorr(file, 37, -n_v4y)
            surface_control_ycorr(file, 49, -n_v5y)
            surface_control_ycorr(file, 58, -n_v6y)
            
            
            i = i+1;
        
    
    return(curr_beam_vec, curr_var_vec)
    
    
var_vec = [1.5/10, 2.6/10, 6.3/10, 1.5/10, 2.6/10, 6.3/10]
configuration_angles =  [0, -45,
                         0 ,45,
                         45,0,
                         -45,0,
                         0,45,
                         45,0]
config_simulation(file, configuration_angles)
f2=algo_facet2_var(file, var_vec)
#move the x-axis 
f1=algo_fix(file)

