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
    link.zSetSurfaceParameter(21, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(21, 4, 0)
    link.zSetSurfaceParameter(21, 5, 0)

    link.zSetSurfaceParameter(25, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(25, 4, 0)
    link.zSetSurfaceParameter(25, 5, 0)
#fix
    link.zSetSurfaceParameter(22, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(22, 4, 0)
    link.zSetSurfaceParameter(22, 5, 0)

    link.zSetSurfaceParameter(24, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(24, 4, 0)
    link.zSetSurfaceParameter(24, 5, 0)
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
    chief_surface(file, 20, chief_angle3_x, chief_angle3_y)
    
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
    
    surface_control_xvar(file, 12, var2x)
    surface_control_yvar(file, 12, var2y)
    
    surface_control_xvar(file, 21, var3x)
    surface_control_yvar(file, 21, var3y)
    
    surface_control_xvar(file, 30, var4x)
    surface_control_yvar(file, 30, var4y)
    
    surface_control_xvar(file, 39, var5x)
    surface_control_yvar(file, 39, var5y)
    
    surface_control_xvar(file, 48, var6x)
    surface_control_yvar(file, 48, var6y)
        
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



c_m =np.matrix([[ 6.38303116e-01, -7.31590121e+01,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00],
       [ 5.17154721e+01,  0.00000000e+00,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00],
       [ 1.57732472e+00, -1.80784827e+02,  9.39021577e-01,
         1.07625812e+02,  0.00000000e+00,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00],
       [ 1.27795229e+02,  0.00000000e+00, -7.60797542e+01,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00],
       [ 3.44226670e+00, -3.94534861e+02,  2.80396355e+00,
         3.21375845e+02,  0.00000000e+00, -1.51098045e+02,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00],
       [ 2.78893277e+02,  0.00000000e+00, -2.27177802e+02,
         0.00000000e+00,  2.13750030e+02,  1.86494194e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00],
       [ 4.17166893e+00, -4.78135183e+02,  3.53336578e+00,
         4.04976168e+02,  0.00000000e+00, -2.10194389e+02,
         0.00000000e+00,  5.90963438e+01,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00],
       [ 3.37989621e+02,  0.00000000e+00, -2.86274146e+02,
         0.00000000e+00,  2.97350353e+02,  2.59434417e+00,
        -8.36003222e+01,  7.29402224e-01,  0.00000000e+00,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00],
       [ 7.74808588e+00, -8.88045655e+02,  7.10978274e+00,
         8.14886640e+02,  0.00000000e+00, -4.99956552e+02,
         0.00000000e+00,  3.48858507e+02, -3.57641693e+00,
        -4.09910469e+02,  0.00000000e+00,  0.00000000e+00],
       [ 6.27751784e+02,  0.00000000e+00, -5.76036309e+02,
         0.00000000e+00,  7.07260825e+02,  6.17076113e+00,
        -4.93510794e+02,  4.30581918e+00,  2.89762161e+02,
         0.00000000e+00,  0.00000000e+00,  0.00000000e+00],
       [ 8.66477447e+00, -9.93111775e+02,  8.02647133e+00,
         9.19952759e+02,  0.00000000e+00, -5.74226882e+02,
         0.00000000e+00,  4.23128837e+02, -4.49310552e+00,
        -5.14976588e+02,  0.00000000e+00,  7.42703298e+01],
       [ 7.02022114e+02,  0.00000000e+00, -6.50306639e+02,
         0.00000000e+00,  8.12326944e+02,  7.08744972e+00,
        -5.98576914e+02,  5.22250777e+00,  3.64032491e+02,
         0.00000000e+00, -1.05066119e+02, -9.16688585e-01]])

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
    #extract variations 
    finv = np.linalg.inv(c_m)
    curr_var_vec = np.matmul(finv, curr_beam_vec)
    
    
    print('=======')
    print('current variations:')
    print(np.transpose(curr_var_vec))

    pyz.closeLink() 
    np.savetxt(r'C:\Users\pwfa-facet2\Desktop\slacecodes\raytracing\zemax-pred.csv',np.c_[curr_beam_vec, curr_var_vec], fmt='%.18e')
    
    
    #feed initial corrections
    
    surface_control_xcorr(file, 4, -1*curr_var_vec.item(0))
    surface_control_xcorr(file, 13, -1*curr_var_vec.item(2))
    surface_control_xcorr(file, 22, -1*curr_var_vec.item(4))
    
    surface_control_ycorr(file, 4, -1*curr_var_vec.item(1))
    surface_control_ycorr(file, 13, -1*curr_var_vec.item(3))
    surface_control_ycorr(file, 22, -1*curr_var_vec.item(5))
    
    surface_control_xcorr(file, 31, -1*curr_var_vec.item(6))
    surface_control_xcorr(file, 40, -1*curr_var_vec.item(8))
    surface_control_xcorr(file, 49, -1*curr_var_vec.item(10))
    
    surface_control_ycorr(file, 31, -1*curr_var_vec.item(7))
    surface_control_ycorr(file, 40, -1*curr_var_vec.item(9))
    surface_control_ycorr(file, 49, -1*curr_var_vec.item(11))
 
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
        if np.abs(beam_mod.item(0)) <= .0001 and np.abs(beam_mod.item(1)) <= .0001 and \
          np.abs(beam_mod.item(2)) <= .0001 and np.abs(beam_mod.item(3)) <= .0001 and \
           np.abs(beam_mod.item(4)) <= .0001 and np.abs(beam_mod.item(5)) <= .0001 and \
           np.abs(beam_mod.item(6)) <= .0001 and np.abs(beam_mod.item(7)) <= .0001 and \
          np.abs(beam_mod.item(8)) <= .0001 and np.abs(beam_mod.item(9)) <= .0001 and \
           np.abs(beam_mod.item(10)) <= .0001 and np.abs(beam_mod.item(11)) <= .0001:
           
            status = "done"
            pyz.closeLink()
            np.savetxt('var3mirlarge'+'.csv', list(zip(var1x, var1y,var2x, var2y,var3x, var3y, \
                                                       var4x, var4y,var5x, var5y,var6x, var6y, \
                                                       beam1x, beam1y,beam2x, beam2y,beam3x, beam3y, \
                                                       beam4x, beam4y,beam5x, beam5y,beam6x, beam6y)))
        #get new variations
        else:    
            curr_vars = np.matmul(finv, beam_mod)
            print("new variations to add:")
            print(curr_vars)
            n_v1x = 1*curr_vars.item(0) + var1x[i]
            n_v1y = 1*curr_vars.item(1) + var1y[i]
            n_v2x = 1*curr_vars.item(2) + var2x[i]
            n_v2y = 1*curr_vars.item(3) + var2y[i]
            n_v3x = 1*curr_vars.item(4) + var3x[i]
            n_v3y = 1*curr_vars.item(5) + var3y[i]
            
            n_v4x = 1*curr_vars.item(6) + var4x[i]
            n_v4y = 1*curr_vars.item(7) + var4y[i]
            n_v5x = 1*curr_vars.item(8) + var5x[i]
            n_v5y = 1*curr_vars.item(9) + var5y[i]
            n_v6x = 1*curr_vars.item(10) + var6x[i]
            n_v6y = 1*curr_vars.item(11) + var6y[i]            
            
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
            surface_control_xcorr(file, 13, -n_v2x)
            surface_control_xcorr(file, 22, -n_v3x)
    
            surface_control_ycorr(file, 4, -n_v1y)
            surface_control_ycorr(file, 13, -n_v2y)
            surface_control_ycorr(file, 22, -n_v3y)
            
            surface_control_xcorr(file, 31, -n_v4x)
            surface_control_xcorr(file, 40, -n_v5x)
            surface_control_xcorr(file, 49, -n_v6x)
    
            surface_control_ycorr(file, 31, -n_v4y)
            surface_control_ycorr(file, 40, -n_v5y)
            surface_control_ycorr(file, 49, -n_v6y)
            
            
            i = i+1;
        
    
    return(curr_beam_vec, curr_var_vec)
    
    
var_vec = [1.5, 2.6, 6.3, 1.5, 2.6, 6.3]
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

