# -*- coding: utf-8 -*-
"""
Created on Fri Jul 20 12:46:46 2018

@author: pwfa-facet2
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit
#import pyzdde.arraytrace as at
import pyzdde.zdde as pyz

import random as rand


file = r'C:\Users\pwfa-facet2\Desktop\slacecodes\facet2controlsystem.zmx'

configuration_angles = [45, 0, 0, -45, 0,-45, 0, 45, 0, -45, 45, 0]

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
#1 to ignore pol;0 to use
    link.zSaveFile(file)
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
    
    link.zSetSurfaceParameter(3,3, chief_angle1_x)
    link.zSetSurfaceParameter(3,4, chief_angle1_y)
    link.zSetSurfaceParameter(3,5, 0)
    
    link.zSetSurfaceParameter(9,3, chief_angle1_x)
    link.zSetSurfaceParameter(9,4, chief_angle1_y)
    link.zSetSurfaceParameter(9,5 ,0)
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
    link.zSetSurfaceParameter(23,3, chief_angle2_x)
    link.zSetSurfaceParameter(23,4, chief_angle2_y)
    link.zSetSurfaceParameter(23,5, 0)
    
    link.zSetSurfaceParameter(29,3, chief_angle2_x)
    link.zSetSurfaceParameter(29,4, chief_angle2_y)
    link.zSetSurfaceParameter(29,5, 0)
#var
    link.zSetSurfaceParameter(24, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(24, 4, 0)
    link.zSetSurfaceParameter(24, 5, 0)

    link.zSetSurfaceParameter(28, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(28, 4, 0)
    link.zSetSurfaceParameter(28, 5, 0)
#fix
    link.zSetSurfaceParameter(25, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(25, 4, 0)
    link.zSetSurfaceParameter(25, 5, 0)

    link.zSetSurfaceParameter(27, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(27, 4, 0)
    link.zSetSurfaceParameter(27, 5, 0)
    
#SAME FOR THRID MIRROR
    link.zSetSurfaceParameter(43,3, chief_angle3_x)
    link.zSetSurfaceParameter(43,4, chief_angle3_y)
    link.zSetSurfaceParameter(43,5, 0)
    
    link.zSetSurfaceParameter(49,3, chief_angle3_x)
    link.zSetSurfaceParameter(49,4, chief_angle3_y)
    link.zSetSurfaceParameter(49,5, 0)
#var
    link.zSetSurfaceParameter(44, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(44, 4, 0)
    link.zSetSurfaceParameter(44, 5, 0)

    link.zSetSurfaceParameter(48, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(48, 4, 0)
    link.zSetSurfaceParameter(48, 5, 0)
#fix
    link.zSetSurfaceParameter(45, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(45, 4, 0)
    link.zSetSurfaceParameter(45, 5, 0)

    link.zSetSurfaceParameter(47, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(47, 4, 0)
    link.zSetSurfaceParameter(47, 5, 0)
    
#SAME FOR FOURTH MIRROR
    link.zSetSurfaceParameter(59,3, chief_angle4_x)
    link.zSetSurfaceParameter(59,4, chief_angle4_y)
    link.zSetSurfaceParameter(59,5, 0)
    
    link.zSetSurfaceParameter(65,3, chief_angle4_x)
    link.zSetSurfaceParameter(65,4, chief_angle4_y)
    link.zSetSurfaceParameter(65,5, 0)
#var
    link.zSetSurfaceParameter(60, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(60, 4, 0)
    link.zSetSurfaceParameter(60, 5, 0)

    link.zSetSurfaceParameter(64, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(64, 4, 0)
    link.zSetSurfaceParameter(64, 5, 0)
#fix
    link.zSetSurfaceParameter(61, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(61, 4, 0)
    link.zSetSurfaceParameter(61, 5, 0)

    link.zSetSurfaceParameter(63, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(63, 4, 0)
    link.zSetSurfaceParameter(63, 5, 0)
    
#SAME FOR FIFTH MIRROR
    link.zSetSurfaceParameter(79,3, chief_angle5_x)
    link.zSetSurfaceParameter(79,4, chief_angle5_y)
    link.zSetSurfaceParameter(79,5, 0)
    
    link.zSetSurfaceParameter(85,3, chief_angle5_x)
    link.zSetSurfaceParameter(85,4, chief_angle5_y)
    link.zSetSurfaceParameter(85,5, 0)
#var
    link.zSetSurfaceParameter(80, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(80, 4, 0)
    link.zSetSurfaceParameter(80, 5, 0)

    link.zSetSurfaceParameter(84, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(84, 4, 0)
    link.zSetSurfaceParameter(84, 5, 0)
#fix
    link.zSetSurfaceParameter(81, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(81, 4, 0)
    link.zSetSurfaceParameter(81, 5, 0)

    link.zSetSurfaceParameter(83, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(83, 4, 0)
    link.zSetSurfaceParameter(83, 5, 0)
    
#SAME FOR SIXTH MIRROR
    link.zSetSurfaceParameter(95,3, chief_angle6_x)
    link.zSetSurfaceParameter(95,4, chief_angle6_y)
    link.zSetSurfaceParameter(95,5, 0)
    
    link.zSetSurfaceParameter(101,3, chief_angle6_x)
    link.zSetSurfaceParameter(101,4, chief_angle6_y)
    link.zSetSurfaceParameter(101,5, 0)
#var
    link.zSetSurfaceParameter(96, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(96, 4, 0)
    link.zSetSurfaceParameter(96, 5, 0)

    link.zSetSurfaceParameter(100, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(100, 4, 0)
    link.zSetSurfaceParameter(100, 5, 0)
#fix
    link.zSetSurfaceParameter(97, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(97, 4, 0)
    link.zSetSurfaceParameter(97, 5, 0)

    link.zSetSurfaceParameter(99, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(99, 4, 0)
    link.zSetSurfaceParameter(99, 5, 0)
    link.zSaveFile(file)  
    pyz.closeLink()
    print('config set for testing!')

var_vec = [0.0527, 0.0624, 0.0718, 0.1029, 0.124]
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
    
def algo_facet2_var(file, var_arr):
    link = pyz.createLink()
    link.zLoadFile(file)
    l_var =0
    h_var = var_arr[0]
    var1x = np.random.uniform(l_var, h_var)
    var1y = np.random.uniform(l_var, h_var)
    h_var = var_arr[1]
    var2x = np.random.uniform(l_var, h_var)
    var2y = np.random.uniform(l_var, h_var)
    h_var = var_arr[2]
    var3x = np.random.uniform(l_var, h_var)
    var3y = np.random.uniform(l_var, h_var)
    h_var = var_arr[3]
    var4x = np.random.uniform(l_var, h_var)
    var4y = np.random.uniform(l_var, h_var)
    h_var = var_arr[4]
    var5x = np.random.uniform(l_var, h_var)
    var5y = np.random.uniform(l_var, h_var)

    var6x = np.random.uniform(l_var, h_var)
    var6y = np.random.uniform(l_var, h_var)
    print('variations inputs:')
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
    print(vec)
    #var M1
    surface_control_xvar(file, 4, var1x)
    surface_control_yvar(file, 4, var1y)
    
    surface_control_xvar(file, 24, var2x)
    surface_control_yvar(file, 24, var2y)
    
    surface_control_xvar(file, 44, var3x)
    surface_control_yvar(file, 44, var3y)
    
    surface_control_xvar(file, 60, var4x)
    surface_control_yvar(file, 60, var4y)
    
    surface_control_xvar(file, 80, var5x)
    surface_control_yvar(file, 80, var5y)
    
    surface_control_xvar(file, 96, var6x)
    surface_control_yvar(file, 96, var6y)
    print('variations finished')
    pyz.closeLink()
    np.savetxt(r'C:\Users\pwfa-facet2\Desktop\slacecodes\raytracing\f2beamvarmod.csv', vec)
    
    
def f_block(cx, cy, rot, d_t):
    cx, cy, rot = np.deg2rad(cx),np.deg2rad(cy),np.deg2rad(rot)
    drift = np.matrix([ [d_t, 0], [0, d_t] ])
    axis = np.matrix([ [2*np.cos(cx), 0], [0, 2*np.cos(cy)] ])
    rot_m = np.matrix([ [np.cos(rot), -np.sin(rot)], [np.sin(rot), np.cos(rot)] ])
    r = np.linalg.multi_dot([ drift, axis, rot_m])
    return(r)


optics_deg = [45, 0, 90,
              0, -45, -90,
              0, -45, -90, 
              0, 45, 90, 
              0,-45, -90,
              45,0,-90]

def f_beamline(config_optics):
    m1_mat = f_block(optics_deg[0], optics_deg[1], optics_deg[2], 2068)
    m2_mat = f_block(optics_deg[3], optics_deg[4], optics_deg[5], 3082)
    m3_mat = f_block(optics_deg[6], optics_deg[7], optics_deg[8], 6121)
    m4_mat = f_block(optics_deg[9], optics_deg[10], optics_deg[11], 2394)
    m5_mat = f_block(optics_deg[12], optics_deg[13], optics_deg[14], 11738.3)
    m6_mat = f_block(optics_deg[15], optics_deg[16], optics_deg[17], 3745.7)
    
    m1xtm2 = f_block(optics_deg[0], optics_deg[1], optics_deg[2], 2068+3082)
    m1xtm3 =  f_block(optics_deg[0], optics_deg[1], optics_deg[2], 2068+3082+6121)
    m1xtm4 =  f_block(optics_deg[0], optics_deg[1], optics_deg[2], 2068+3082+6121+2394)
    m1xtm5 =  f_block(optics_deg[0], optics_deg[1], optics_deg[2], 2068+3082+6121+2394+11738.3)
    m1xtm6 =  f_block(optics_deg[0], optics_deg[1], optics_deg[2], 2068+3082+6121+2394+11738.3+3745.7)
    
    m2xtm3 =  f_block(optics_deg[3], optics_deg[4], optics_deg[5], 3082+6121)
    m2xtm4 =  f_block(optics_deg[3], optics_deg[4], optics_deg[5], 3082+6121+2394)
    m2xtm5 =  f_block(optics_deg[3], optics_deg[4], optics_deg[5], 3082+6121+2394+11738.3)
    m2xtm6 =  f_block(optics_deg[3], optics_deg[4], optics_deg[5], 3082+6121+2394+11738.3+3745.7)

    m3xtm4 =  f_block(optics_deg[6], optics_deg[7], optics_deg[8], 6121+2394)
    m3xtm5 =  f_block(optics_deg[6], optics_deg[7], optics_deg[8], 6121+2394+11738.3)
    m3xtm6 =  f_block(optics_deg[6], optics_deg[7], optics_deg[8], 6121+2394+11738.3+3745.7)
    
    m4xtm5 = f_block(optics_deg[9], optics_deg[10], optics_deg[11], 2394+11738.3)
    m4xtm6 = f_block(optics_deg[9], optics_deg[10], optics_deg[11], 2394+11738.3+3745.7)
    
    m5xtm6 = f_block(optics_deg[12], optics_deg[13], optics_deg[14], 11738.3+3745.7)
    
    z = np.zeros([2,2])
    
    full_matrix = np.bmat( [ [m1_mat, z, z,z,z,z],
                             [m1xtm2, m2_mat, z,z,z,z], 
                             [m1xtm3, m2xtm3, m3_mat, z,z,z],
                             [m1xtm4, m2xtm4, m3xtm4, m4_mat, z,z],
                             [m1xtm5, m2xtm5, m3xtm5, m4xtm5, m5_mat,z], 
                             [m1xtm6, m2xtm6, m3xtm6, m4xtm6, m5xtm6, m6_mat]])

    return(full_matrix)    
    
def ccd_screens(file):
    link = pyz.createLink()
    link.zLoadFile(file)
    ccd1x = link.zOperandValue('POPD', 22, 1, 0, 11)
    ccd1y = link.zOperandValue('POPD', 22, 1, 0, 12)
    
    ccd2x = link.zOperandValue('POPD', 42, 1, 0, 11)
    ccd2y = link.zOperandValue('POPD', 42, 1, 0, 12)

    ccd3x = link.zOperandValue('POPD', 58, 1, 0, 11)
    ccd3y = link.zOperandValue('POPD', 58, 1, 0, 12)
    
    ccd4x = link.zOperandValue('POPD', 78, 1, 0, 11)
    ccd4y = link.zOperandValue('POPD', 78, 1, 0, 12)
    
    ccd5x = link.zOperandValue('POPD', 94, 1, 0, 11)
    ccd5y = link.zOperandValue('POPD', 94, 1, 0, 12)

    ccd6x = link.zOperandValue('POPD', 116, 1, 0, 11)
    ccd6y = link.zOperandValue('POPD', 116, 1, 0, 12)
    
    
    beam_pos_vec = np.matrix([ [ccd1x], [ccd1y],
                              [ccd2x], [ccd2y],
                              [ccd3x], [ccd3y],
                              [ccd4x], [ccd4y],
                              [ccd5x], [ccd5y],
                              [ccd6x], [ccd6y]])
    pyz.closeLink()
    return(beam_pos_vec)
    
f_beamline(optics_deg)
def algo_fix(file):
    link= pyz.createLink()
    link.zLoadFile(file)
      
    imax = 3
    corr_mem = []
    it = 0
    
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
    
    v_1x =[]
    v_1y =[]
    v_2x =[]
    v_2y =[]
    v_3x =[]
    v_3y =[]
    v_4x =[]
    v_4y =[]
    v_5x =[]
    v_5y =[]
    v_6x =[]
    v_6y =[]
    
    print('current it:',it)
    #extract data across the ccds:
    beam_pos_vec= ccd_screens(file)
    print('current beam pos:')
    print(beam_pos_vec)
    
    #ppend elements
    beam_1x.append(beam_pos_vec.item(0))
    beam_1y.append(beam_pos_vec.item(1))
    
    beam_2x.append(beam_pos_vec.item(2))
    beam_2y.append(beam_pos_vec.item(3))
    
    beam_3x.append(beam_pos_vec.item(4))
    beam_3y.append(beam_pos_vec.item(5))
    
    beam_4x.append(beam_pos_vec.item(6))
    beam_4y.append(beam_pos_vec.item(7))
    
    beam_5x.append(beam_pos_vec.item(8))
    beam_5y.append(beam_pos_vec.item(9))
    
    beam_6x.append(beam_pos_vec.item(10))
    beam_6y.append(beam_pos_vec.item(11))
    
    finv = np.linalg.inv(f_beamline(optics_deg))
    
    
    misalign_vec = np.rad2deg(np.matmul(finv, beam_pos_vec))
        #ppend elements
    v_1x.append(misalign_vec.item(0))
    v_1y.append(misalign_vec.item(1))
    
    v_2x.append(misalign_vec.item(2))
    v_2y.append(misalign_vec.item(3))
    
    v_3x.append(misalign_vec.item(4))
    v_3y.append(misalign_vec.item(5))
    
    v_4x.append(misalign_vec.item(6))
    v_4y.append(misalign_vec.item(7))
    
    v_5x.append(misalign_vec.item(8))
    v_5y.append(misalign_vec.item(9))
    
    v_6x.append(misalign_vec.item(10))
    v_6y.append(misalign_vec.item(11))
    
    print('current variations:')
    print(misalign_vec)
    
    memory_var = []
    memory_var.append(misalign_vec)
    
    #execute corrections 
    surface_control_xcorr(file, 5, v_1x[0])
    surface_control_ycorr(file, 5, v_1y[0])
    
    surface_control_xcorr(file, 25, v_2x[0])
    surface_control_ycorr(file, 25, v_2y[0])
    
    surface_control_xcorr(file, 45, v_3x[0])
    surface_control_ycorr(file, 45, v_3y[0])
    
    surface_control_xcorr(file, 63, v_4x[0])
    surface_control_ycorr(file, 63, v_4y[0])
    
    surface_control_xcorr(file, 81, v_5x[0])
    surface_control_ycorr(file, 81, v_5y[0])
    
    surface_control_xcorr(file, 97, v_6x[0])
    surface_control_ycorr(file, 97, v_6y[0])
    #update it count
    status = 'not done'
    
    np.savetxt(r'C:\Users\pwfa-facet2\Desktop\slacecodes\raytracing\f2firstvarmod.csv', misalign_vec)
    
    while status == 'not done':
        print("currentg it:", it)
        #get beam positions to check for
        #misalignment 
        curr_beam_pos = ccd_screens(file)
        print('current beam position on feedback:')
        print(curr_beam_pos)
        nccd1x = curr_beam_pos.item(0)
        nccd1y = curr_beam_pos.item(1)
    
        nccd2x = curr_beam_pos.item(2)
        nccd2y = curr_beam_pos.item(3)
        
        nccd3x =  curr_beam_pos.item(4)
        nccd3y =  curr_beam_pos.item(5)
        
        nccd4x =  curr_beam_pos.item(6)
        nccd4y =  curr_beam_pos.item(7)
    
        nccd5x = curr_beam_pos.item(8)
        nccd5y =  curr_beam_pos.item(9)

        nccd6x =  curr_beam_pos.item(10)
        nccd6y =  curr_beam_pos.item(11)
        
        #ppend elements
        beam_1x.append(nccd1x)
        beam_1y.append(nccd1y)
    
        beam_2x.append(nccd2x)
        beam_2y.append(nccd2x)
    
        beam_3x.append(nccd3x)
        beam_3y.append(nccd3x)
        
        beam_4x.append(nccd4x)
        beam_4y.append(nccd4x)
    
        beam_5x.append(nccd5x)
        beam_5y.append(nccd5x)
    
        beam_6x.append(nccd6x)
        beam_6y.append(nccd6x)
        
        
        #check misalignment
        if nccd1x < 0.01 and \
           nccd1y < 0.01 and \
           nccd2x < 0.01 and \
           nccd2y < 0.01 and \
           nccd3x < 0.01 and \
           nccd3y < 0.01 and \
           nccd4x < 0.01 and \
           nccd4y < 0.01 and \
           nccd5x < 0.01 and \
           nccd5y < 0.01 and \
           nccd6x < 0.01 and \
           nccd6y < 0.01:
            status = 'done'
            print(status)
            pyz.closeLink()
        elif it>= imax:
            print('max it')
            break;
        else:
            #calculate neew variations
            #to do corrections
            curr_misalign_vec = np.rad2deg(np.matmul(finv, curr_beam_pos))
            print('variations to adjust original variation:')
            print(curr_misalign_vec)
            adjustments = curr_misalign_vec + memory_var[it]
            memory_var.append(adjustments)
            print('corrections with adjustments:')
            print(adjustments)
            
            v_1x.append(adjustments.item(0))
            v_1y.append(adjustments.item(1))
    
            v_2x.append(adjustments.item(2))
            v_2y.append(adjustments.item(3))
            
            v_3x.append(adjustments.item(4))
            v_3y.append(adjustments.item(5))
            
            v_4x.append(adjustments.item(6))
            v_4y.append(adjustments.item(7))
            
            v_5x.append(adjustments.item(8))
            v_5y.append(adjustments.item(9))
            
            v_6x.append(adjustments.item(10))
            v_6y.append(adjustments.item(11))
            
            #feed them 
            surface_control_xcorr(file, 5, adjustments.item(0))
            surface_control_ycorr(file, 5, adjustments.item(1))
    
            surface_control_xcorr(file, 25, adjustments.item(2))
            surface_control_ycorr(file, 25, adjustments.item(3))
    
            surface_control_xcorr(file, 45, adjustments.item(4))
            surface_control_ycorr(file, 45, adjustments.item(5))
    
            surface_control_xcorr(file, 63, adjustments.item(6))
            surface_control_ycorr(file, 63, adjustments.item(7))
            
            surface_control_xcorr(file, 81, adjustments.item(8))
            surface_control_ycorr(file, 81, adjustments.item(9))
    
            surface_control_xcorr(file, 97,adjustments.item(10))
            surface_control_ycorr(file, 97, adjustments.item(11))
            it = it+1
            print('=========')
            print('=========')
            print('=========')
    np.savetxt(r'C:\Users\pwfa-facet2\Desktop\slacecodes\raytracing\f2beamtrackmod.csv', \
               list(zip(beam_1x, beam_1y, beam_2x, beam_2y, \
                        beam_3x, beam_3y, beam_4x, beam_4y, \
                        beam_5x, beam_5y, beam_6x, beam_6y)))
    np.savetxt(r'C:\Users\pwfa-facet2\Desktop\slacecodes\raytracing\f2vartrackmod.csv', \
               list(zip(v_1x, v_1y, v_2x, v_2y, \
                        v_3x, v_3y, v_4x, v_4y, \
                        v_5x, v_5y, v_6x, v_6y)))
    
            
            

                    
    
        
    
config_simulation(file, configuration_angles)
algo_facet2_var(file,var_vec)
algo_fix(file)
