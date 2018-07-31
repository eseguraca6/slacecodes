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


file = r'C:\Users\pwfa-facet2\Desktop\slacecodes\raytracing\4fc.zmx'

configuration_angles =  [45, 0,
                         -45,0,
                         -45,0,
                         45,0,]
                         
                         #[45, 0, 0, -45, 0,-45, 0, 45, 0, -45, 45, 0]

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
    
    
    link.zSetSurfaceParameter(2,3, chief_angle1_x)
    link.zSetSurfaceParameter(2,4, chief_angle1_y)
    link.zSetSurfaceParameter(2,5, 0)
    
    link.zSetSurfaceParameter(8,3, chief_angle1_x)
    link.zSetSurfaceParameter(8,4, chief_angle1_y)
    link.zSetSurfaceParameter(8,5 ,0)
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
#SAME FOR SECOND MIRROR
    link.zSetSurfaceParameter(11,3, chief_angle2_x)
    link.zSetSurfaceParameter(11,4, chief_angle2_y)
    link.zSetSurfaceParameter(11,5, 0)
    
    link.zSetSurfaceParameter(17,3, chief_angle2_x)
    link.zSetSurfaceParameter(17,4, chief_angle2_y)
    link.zSetSurfaceParameter(17,5, 0)
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
    
#SAME FOR THRID MIRROR
    link.zSetSurfaceParameter(20,3, chief_angle3_x)
    link.zSetSurfaceParameter(20,4, chief_angle3_y)
    link.zSetSurfaceParameter(20,5, 0)
    
    link.zSetSurfaceParameter(26,3, chief_angle3_x)
    link.zSetSurfaceParameter(26,4, chief_angle3_y)
    link.zSetSurfaceParameter(26,5, 0)
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
    
#SAME FOR FOURTH MIRROR
    link.zSetSurfaceParameter(29,3, chief_angle4_x)
    link.zSetSurfaceParameter(29,4, chief_angle4_y)
    link.zSetSurfaceParameter(29,5, 0)
    
    link.zSetSurfaceParameter(35,3, chief_angle4_x)
    link.zSetSurfaceParameter(35,4, chief_angle4_y)
    link.zSetSurfaceParameter(35,5, 0)
#var
    link.zSetSurfaceParameter(30, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(30, 4, 0)
    link.zSetSurfaceParameter(30, 5, 0)

    link.zSetSurfaceParameter(34, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(34, 4, 0)
    link.zSetSurfaceParameter(34, 5, 0)
#fix
    link.zSetSurfaceParameter(31, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(31, 4, 0)
    link.zSetSurfaceParameter(31, 5, 0)

    link.zSetSurfaceParameter(33, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(33, 4, 0)
    link.zSetSurfaceParameter(33, 5, 0)
    link.zSaveFile(file)  
    pyz.closeLink()
    print('config set for testing!')

var_vec = [0.0527, 0.0624, 0.0718, 0.1029]
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
    print(vec)
    #var M1
    surface_control_xvar(file, 3, var1x)
    surface_control_yvar(file, 3, var1y)
    
    surface_control_xvar(file, 12, var2x)
    surface_control_yvar(file, 12, var2y)
    
    surface_control_xvar(file, 21, var3x)
    surface_control_yvar(file, 21, var3y)
    
    #surface_control_xvar(file, 30, var4x)
    #surface_control_yvar(file, 30, var4y)
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
              -45, 0, -90,
              -45, 0, -90]

def f_beamline(config_optics):
    m1_mat = f_block(optics_deg[0], optics_deg[1], optics_deg[2], 2068)
    m2_mat = f_block(optics_deg[3], optics_deg[4], optics_deg[5], 3082)
    m3_mat = f_block(optics_deg[6], optics_deg[7], optics_deg[8], 6121)
    #m4_mat = f_block(optics_deg[9], optics_deg[10], optics_deg[11], 2394)
    #m5_mat = f_block(optics_deg[12], optics_deg[13], optics_deg[14], 11738.3)
    #m6_mat = f_block(optics_deg[15], optics_deg[16], optics_deg[17], 3000)
    
    m1xtm2 = f_block(optics_deg[0], optics_deg[1], optics_deg[2], 2095+3082)
    m1xtm3 =  f_block(optics_deg[0], optics_deg[1], optics_deg[2], 2095+3082+6121)
    #m1xtm4 =  f_block(optics_deg[0], optics_deg[1], optics_deg[2], 2095+3082+6121+2394)
    #m1xtm5 =  f_block(optics_deg[0], optics_deg[1], optics_deg[2], 2095+3082+6121+2394+11738.3)
    #m1xtm6 =  f_block(optics_deg[0], optics_deg[1], optics_deg[2], 2095+3082+6121+2394+11738.3+3000)
    
    m2xtm3 =  f_block(optics_deg[3], optics_deg[4], optics_deg[5], 3082+6121)
    #m2xtm4 =  f_block(optics_deg[3], optics_deg[4], optics_deg[5], 3082+6121+2394)
    #m2xtm5 =  f_block(optics_deg[3], optics_deg[4], optics_deg[5], 3082+6121+2394+11738.3)
    #m2xtm6 =  f_block(optics_deg[3], optics_deg[4], optics_deg[5], 3082+6121+2394+11738.3+3000)

    #m3xtm4 =  f_block(optics_deg[6], optics_deg[7], optics_deg[8], 6121+2394)
    #m3xtm5 =  f_block(optics_deg[6], optics_deg[7], optics_deg[8], 6121+2394+11738.3)
    #m3xtm6 =  f_block(optics_deg[6], optics_deg[7], optics_deg[8], 6121+2394+11738.3+3000)
    
    #m4xtm5 = f_block(optics_deg[9], optics_deg[10], optics_deg[11], 2394+11738.3)
    #m4xtm6 = f_block(optics_deg[9], optics_deg[10], optics_deg[11], 2394+11738.3+3000)
    
    #m5xtm6 = f_block(optics_deg[12], optics_deg[13], optics_deg[14], 11738.3+3000)
    
    z = np.zeros([2,2])
    
    full_matrix = np.bmat( [ [m1_mat, z, z],
                             [m1xtm2, m2_mat, z], 
                             [m1xtm3, m2xtm3, m3_mat]])
                             #[m1xtm4, m2xtm4, m3xtm4, m4_mat]])

    return(full_matrix)    
    
def ccd_screens(file):
    link = pyz.createLink()
    link.zLoadFile(file)
    ccd1x = link.zOperandValue('POPD', 10, 1, 0, 11)
    ccd1y = link.zOperandValue('POPD', 10, 1, 0, 12)
    
    ccd2x = link.zOperandValue('POPD', 19, 1, 0, 11)
    ccd2y = link.zOperandValue('POPD', 19, 1, 0, 12)

    ccd3x = link.zOperandValue('POPD', 28, 1, 0, 11)
    ccd3y = link.zOperandValue('POPD', 28, 1, 0, 12)
    
    #ccd4x = link.zOperandValue('POPD', 37, 1, 0, 11)
    #ccd4y = link.zOperandValue('POPD', 37, 1, 0, 12)

    
    
    beam_pos_vec = np.matrix([ [ccd1x], [ccd1y],
                              [ccd2x], [ccd2y],
                              [ccd3x], [ccd3y]])

    pyz.closeLink()
    return(beam_pos_vec)
    
f_beamline(optics_deg)
def algo_fix(file):
    link= pyz.createLink()
    link.zLoadFile(file)
      
    imax = 10
    corr_mem = []
    it = 0
    
    beam_1x =[]
    beam_1y =[]
    beam_2x =[]
    beam_2y =[]
    beam_3x =[]
    beam_3y =[]
    #beam_4x =[]
    #beam_4y =[]

    
    v_1x =[]
    v_1y =[]
    v_2x =[]
    v_2y =[]
    v_3x =[]
    v_3y =[]
    #v_4x =[]
    #v_4y =[]


    #check for misalignments 
    beam_mem =[] 
    status = 'not done'
    finv = np.linalg.inv(f_beamline(optics_deg))
    curr_beam_pos = ccd_screens(file)
    beam_mem.append(curr_beam_pos)
    print("start misaligned vector:")
    print(curr_beam_pos)
    
    beam_1x.append(curr_beam_pos.item(0))
    beam_1y.append(curr_beam_pos.item(1))
    
    beam_2x.append(curr_beam_pos.item(2))
    beam_2y.append(curr_beam_pos.item(3))
    
    beam_3x.append(curr_beam_pos.item(4))
    beam_3y.append(curr_beam_pos.item(5))
    
    #beam_4x.append(curr_beam_pos.item(6))
    #beam_4y.append(curr_beam_pos.item(7))
    
    delta_dev = []
    #check for the first variations 
    misalign_vec = np.rad2deg(np.matmul(finv, curr_beam_pos))
    print('current variations')
    print(misalign_vec)
    c_1x = misalign_vec.item(0)
    c_1y = misalign_vec.item(1)
    c_2x = misalign_vec.item(2)
    c_2y = misalign_vec.item(3)
    c_3x = misalign_vec.item(4)
    c_3y = misalign_vec.item(5)
    #c_4x = misalign_vec.item(6)
    #c_4y = misalign_vec.item(7)

            
    v_1x.append(c_1x)
    v_1y.append(c_1y)
    v_2x.append(c_2x)
    v_2y.append(c_2y)
    v_3x.append(c_3x)
    v_3y.append(c_3y)
    #v_4x.append(c_4x)
    #v_4y.append(c_4y)
            

    #feed those variations
    surface_control_xcorr(file, 4, -c_1x)
    surface_control_ycorr(file, 4, -c_1y)
    
    surface_control_xcorr(file, 13, -c_2x)
    surface_control_ycorr(file, 13, -c_2y)
    
    surface_control_xcorr(file, 22, -c_3x)
    surface_control_ycorr(file, 22, -c_3y)
                
    #surface_control_xcorr(file, 31, -c_4x)
    #surface_control_ycorr(file, 31, -c_4y)
    

            
    
    #input integral element
    corr_mem.append(misalign_vec)
    
    curr_beam_pos = ccd_screens(file)
    print("after changes misaligned vector:")
    print(curr_beam_pos)
    
    
    exit
    while status == 'not done':
        curr_beam_pos=ccd_screens(file)
        print("current it (inside loop):", it)
        #get beam positions to check for
        #misalignment 
        curr_beam_pos = ccd_screens(file)
        print('current beam position on feedback:')
        print(curr_beam_pos)
        beam_mem.append(curr_beam_pos)
        beam_1x.append(curr_beam_pos.item(0))
        beam_1y.append(curr_beam_pos.item(1))
    
        beam_2x.append(curr_beam_pos.item(2))
        beam_2y.append(curr_beam_pos.item(3))
    
        beam_3x.append(curr_beam_pos.item(4))
        beam_3y.append(curr_beam_pos.item(5))
    
        #beam_4x.append(curr_beam_pos.item(6))
        #beam_4y.append(curr_beam_pos.item(7))
    
        nccd1x = curr_beam_pos.item(0)
        nccd1y = curr_beam_pos.item(1)
    
        nccd2x = curr_beam_pos.item(2)
        nccd2y = curr_beam_pos.item(3)
        
        nccd3x =  curr_beam_pos.item(4)
        nccd3y =  curr_beam_pos.item(5)
        
        #nccd4x =  curr_beam_pos.item(6)
        #nccd4y =  curr_beam_pos.item(7)

        
        diff1x = nccd1x
        diff1y = nccd1y
        diff2x = nccd2x
        diff2y = nccd2y
        diff3x = nccd3x
        diff3y = nccd3y
        """
        diff4x = nccd4x
        diff4y = nccd4y
        """
        
        #check misalignment
        if diff1x < 0.01 and \
           diff1y < 0.01 and \
           diff2x < 0.01 and \
           diff2y < 0.01 and \
           diff3x < 0.01 and \
           diff3y < 0.01: 
            status = 'done'
            print(status)
            pyz.closeLink()
        elif it > imax:
            print('max it')
            pyz.closeLink()
            break;
        else:
            #extract variations 
            misalign_vec = np.rad2deg(np.matmul(finv, curr_beam_pos))
            print('current variations')
            print(misalign_vec)
            #append elements
            #print(corr_mem)

            c_vec = (0.45)*misalign_vec + ((.54)*corr_mem[it])
            corr_mem.append(c_vec)
            #print(corr_mem)

            #derivative_comp = c_vec - delta_dev[it-1]
            #c_vec = c_vec + (1/200)*derivative_comp
            print('corrections into system:')
            print(c_vec)
            delta_dev.append(c_vec)
            corr_mem.append(c_vec)
            c_1x = c_vec.item(0)
            c_1y = c_vec.item(1)
            c_2x = c_vec.item(2)
            c_2y = c_vec.item(3)
            c_3x = c_vec.item(4)
            c_3y = c_vec.item(5)
            #c_4x = c_vec.item(6)
            #c_4y = c_vec.item(7)

            
            v_1x.append(c_1x)
            v_1y.append(c_1y)
            v_2x.append(c_2x)
            v_2y.append(c_2y)
            v_3x.append(c_3x)
            v_3y.append(c_3y)
            #v_4x.append(c_4x)
            #v_4y.append(c_4y)

            
            #execute correction
            surface_control_xcorr(file, 4, -c_1x)
            surface_control_ycorr(file, 4, -c_1y)
    
            surface_control_xcorr(file, 13, -c_2x)
            surface_control_ycorr(file, 13, -c_2y)
    
            surface_control_xcorr(file, 22, -c_3x)
            surface_control_ycorr(file, 22, -c_3y)
                
            #surface_control_xcorr(file, 31, -c_4x)
            #surface_control_ycorr(file, 31, -c_4y)

            
            it=it+1
        
    np.savetxt(r'C:\Users\pwfa-facet2\Desktop\slacecodes\raytracing\f2beamtrackmod.csv', \
               list(zip(beam_1x, beam_1y, beam_2x, beam_2y, \
                        beam_3x, beam_3y \
                       )))
    np.savetxt(r'C:\Users\pwfa-facet2\Desktop\slacecodes\raytracing\f2vartrackmod.csv', \
               list(zip(v_1x, v_1y, v_2x, v_2y, \
                        v_3x, v_3y \
                        )))
    
            
            

                    
    
        
    
config_simulation(file, configuration_angles)
algo_facet2_var(file,var_vec)
algo_fix(file)