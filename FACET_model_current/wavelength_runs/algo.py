# -*- coding: utf-8 -*-
"""
Created on Thu May 10 10:33:25 2018

@author: pwfa-facet2
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit
#import pyzdde.arraytrace as at
import pyzdde.zdde as pyz

import random as rand
def two_mirror_system(alpha1x, alpha1y, alpha2x, alpha2y, rev1, rev2, d_m1_m2, d_m2_s1, d_s1_s2):
    delta_1 = d_m1_m2 + d_m2_s1
   # print(delta_1)
    delta_s2 = d_m2_s1 + d_s1_s2
    #print(delta_s2)
    delta_s1 = d_m2_s1
    delta_max = d_m1_m2+ d_s1_s2 + delta_s1
    #print(delta_max)
    c_alphax1, c_alphay1, c_alphax2, c_alphay2 = np.cos(np.deg2rad(alpha1x)) , np.cos(np.deg2rad(alpha1y)) ,np.cos(np.deg2rad(alpha2x)) , np.cos(np.deg2rad(alpha2y))
    c_rev1, s_rev1, c_rev2, s_rev2 = np.cos(np.deg2rad(rev1)) , np.sin(np.deg2rad(rev1)) ,np.cos(np.deg2rad(rev2)) , np.sin(np.deg2rad(rev2))
    
    system = np.matrix([  
        [ 2*delta_1*c_alphax1*c_rev1, -2*delta_1*c_alphax1*s_rev1, 2*delta_s1*c_alphax2*c_rev2, -2*delta_s1*c_alphax2*s_rev2],
        
        [2*delta_1*c_alphay1*s_rev1, 2*delta_1*c_alphay1*c_rev1, 2*delta_s1*c_alphay2*s_rev2, 2*delta_s1*c_alphay2*c_rev2], 
        
        [2*delta_max*c_alphax1*c_rev1, -2*delta_max*c_alphax1*s_rev1, 2*delta_s2*c_alphax2*c_rev2, -2*delta_s2*c_alphax2*s_rev2],
        
        [2*delta_max*c_alphay1*s_rev1, 2*delta_max*c_alphay1*c_rev1, 2*delta_s2*c_alphay2*s_rev2, 2*delta_s2*c_alphay2*c_rev2]
        ])
    
    return(system)

file = r"C:\Users\pwfa-facet2\Desktop\slacecodes\centroid_test.zmx"
def config_simulation(file, chief_angle1_x,chief_angle1_y, chief_angle1_z,
                      chief_angle2_x,chief_angle2_y, chief_angle2_z):
    link = pyz.createLink()
    link.zLoadFile(file)

    setfile = link.zGetFile().lower().replace('.zmx', '.CFG')
    S_512 = 5
    grid_size = 20
    GAUSS_WAIST, WAIST_X, WAIST_Y, DECENTER_X, DECENTER_Y = 0, 1, 2, 3, 4
    beam_waist, x_off, y_off = 5, 0, 0
    cfgfile = link.zSetPOPSettings('irr', setfile, startSurf=2, endSurf=2, field=1,
                                   wave=1, beamType=GAUSS_WAIST, paramN=( (WAIST_X, WAIST_Y, DECENTER_X, DECENTER_Y), (beam_waist, beam_waist, x_off, y_off) ),
                                   sampx=S_512, sampy=S_512, widex=grid_size, widey=grid_size, tPow=1, auto=0, ignPol=1)
    link.zModifyPOPSettings(cfgfile, endSurf=24)
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
    
    link.zSetSurfaceParameter(19,3, chief_angle2_x)
    link.zSetSurfaceParameter(19,4, chief_angle2_y)
    link.zSetSurfaceParameter(19,5, chief_angle2_z)

    link.zSetSurfaceParameter(25,3, chief_angle2_x)
    link.zSetSurfaceParameter(25,4, chief_angle2_y)
    link.zSetSurfaceParameter(25,5, chief_angle2_z)

#fix var/pos empty 
    link.zSaveFile(file)

#var
    link.zSetSurfaceParameter(4, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(4, 4, 0)
    link.zSetSurfaceParameter(4, 5, 0)

    link.zSetSurfaceParameter(8, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(8, 4, 0)
    link.zSetSurfaceParameter(8, 5, 0)

#####
#fix
    link.zSetSurfaceParameter(5, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(5, 4, 0)
    link.zSetSurfaceParameter(5, 5, 0)

    link.zSetSurfaceParameter(7, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(7, 4, 0)
    link.zSetSurfaceParameter(7, 5, 0)



#####

    link.zSetSurfaceParameter(20, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(20, 4, 0)
    link.zSetSurfaceParameter(20, 5, 0)

    link.zSetSurfaceParameter(24, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(24, 4, 0)
    link.zSetSurfaceParameter(24, 5, 0)

#####
    link.zSetSurfaceParameter(21, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(21 ,4, 0)
    link.zSetSurfaceParameter(21, 5, 0)

    link.zSetSurfaceParameter(23, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(23, 4, 0)
    link.zSetSurfaceParameter(23, 5, 0)

    link.zSaveFile(file)    
    pyz.closeLink()
    print('config set for testing!')

config_simulation(file, 45,0,0,0,45,0)

def algo_var(file, low_angle, high_angle):
    link = pyz.createLink()
    link.zLoadFile(file)
    alpha1_x = np.random.uniform(low_angle, high_angle)
    alpha1_y = np.random.uniform(low_angle, high_angle)
    alpha2_x = np.random.uniform(low_angle, high_angle)
    alpha2_y = np.random.uniform(low_angle, high_angle)
    
    #insert variations
    link.zSetSurfaceParameter(4, 3, alpha1_x) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(4, 4, alpha1_y)
    link.zSetSurfaceParameter(4, 5, 0)

    link.zSetSurfaceParameter(8, 3, -alpha1_x) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(8, 4, -alpha1_y)
    link.zSetSurfaceParameter(8, 5, 0)
    
    link.zSetSurfaceParameter(20, 3, alpha2_x) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(20, 4, alpha2_y)
    link.zSetSurfaceParameter(20, 5, 0)

    link.zSetSurfaceParameter(24, 3, -alpha2_x) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(24, 4, -alpha2_y)
    link.zSetSurfaceParameter(24, 5, 0)
    link.zSaveFile(file)  
    print("random input variations:",alpha1_x, alpha1_y, alpha2_x, alpha2_y)
    print('config set for fixing!')
    pyz.closeLink()

algo_var(file, -5,5)
f_sys = two_mirror_system(45,0,0,45,90,-90,400,200,500)
print("==========")
def algo_test(file):
    link = pyz.createLink()
    link.zLoadFile(file)
    #extract offsets:
    ccd1_offsetx = link.zOperandValue('POPD', 30, 1, 0, 11)
    ccd1_offsety = link.zOperandValue('POPD', 30, 1, 0, 12)
        
    ccd2_x = link.zOperandValue('POPD', 32, 1, 0, 11)
    ccd2_y = link.zOperandValue('POPD', 32, 1, 0, 12)
    #make offsets vector
    curr_vec = np.matrix([[ccd1_offsetx], [ccd1_offsety], [ccd2_x], [ccd2_y]])
    print("input offsets:", np.transpose(curr_vec))
    #get variations: 
    inv_f = np.linalg.inv(f_sys)
        #extract predictions of the variations
        
    curr_angle_vector = np.rad2deg(np.matmul(inv_f, (curr_vec)))

    pred_alpha1x=(curr_angle_vector.item(0))
    pred_alpha1y=(curr_angle_vector.item(1))
    pred_alpha2x=(curr_angle_vector.item(2))
    pred_alpha2y=(curr_angle_vector.item(3))
    
    print(" predicted variations:", np.transpose(curr_angle_vector))
    
    #input this adjustments to system to see rectification
    link.zSetSurfaceParameter(5, 3, -pred_alpha1x) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(5, 4, -pred_alpha1y)
    link.zSetSurfaceParameter(5, 5, 0)

    link.zSetSurfaceParameter(7, 3, pred_alpha1x) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(7, 4, pred_alpha1y)
    link.zSetSurfaceParameter(7, 5, 0)
    
    link.zSetSurfaceParameter(21, 3, -pred_alpha2x) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(21 ,4, -pred_alpha2y)
    link.zSetSurfaceParameter(21, 5, 0)

    link.zSetSurfaceParameter(23, 3, pred_alpha2x) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(23, 4, pred_alpha2y)
    link.zSetSurfaceParameter(23, 5, 0)
    link.zSaveFile(file)
    n_ccd1_offsetx = link.zOperandValue('POPD', 30, 1, 0, 11)
    n_ccd1_offsety = link.zOperandValue('POPD', 30, 1, 0, 12)
        
    n_ccd2_x = link.zOperandValue('POPD', 32, 1, 0, 11)
    n_ccd2_y = link.zOperandValue('POPD', 32, 1, 0, 12)
    #make offsets vector
    n_curr_vec = np.matrix([[n_ccd1_offsetx], [n_ccd1_offsety], [n_ccd2_x], [n_ccd2_y]])
    print("new offsets:", np.transpose(n_curr_vec))
    
    n_curr_angle_vector = np.rad2deg(np.matmul(inv_f, (n_curr_vec)))
    print(" new predicted variations:", np.transpose(n_curr_angle_vector))
    print("adding two fixes in angles:")
    best_fix= n_curr_angle_vector + curr_angle_vector
    b_pred_alpha1x=(best_fix.item(0))
    b_pred_alpha1y=(best_fix.item(1))
    b_pred_alpha2x=(best_fix.item(2))
    b_pred_alpha2y=(best_fix.item(3))
    print(np.transpose(n_curr_angle_vector + curr_angle_vector))
    
    link.zSetSurfaceParameter(5, 3, -b_pred_alpha1x) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(5, 4, -b_pred_alpha1y)
    link.zSetSurfaceParameter(5, 5, 0)

    link.zSetSurfaceParameter(7, 3, b_pred_alpha1x) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(7, 4, b_pred_alpha1y)
    link.zSetSurfaceParameter(7, 5, 0)
    
    link.zSetSurfaceParameter(21, 3, -b_pred_alpha2x) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(21 ,4, -b_pred_alpha2y)
    link.zSetSurfaceParameter(21, 5, 0)

    link.zSetSurfaceParameter(23, 3, b_pred_alpha2x) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(23, 4, b_pred_alpha2y)
    link.zSetSurfaceParameter(23, 5, 0)
    link.zSaveFile(file)
    n_ccd1_offsetx = link.zOperandValue('POPD', 30, 1, 0, 11)
    n_ccd1_offsety = link.zOperandValue('POPD', 30, 1, 0, 12)
        
    n_ccd2_x = link.zOperandValue('POPD', 32, 1, 0, 11)
    n_ccd2_y = link.zOperandValue('POPD', 32, 1, 0, 12)
    #make offsets vector
    n_curr_vec = np.matrix([[n_ccd1_offsetx], [n_ccd1_offsety], [n_ccd2_x], [n_ccd2_y]])
    print("new offsets:", np.transpose(n_curr_vec))
    
    pyz.closeLink()

algo_test(file)
    
