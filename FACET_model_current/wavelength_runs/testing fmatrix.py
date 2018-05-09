# -*- coding: utf-8 -*-
"""
Created on Wed May  9 08:52:47 2018

@author: pwfa-facet2
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit
#import pyzdde.arraytrace as at
import pyzdde.zdde as pyz

import random as rand

file = r"C:\Users\pwfa-facet2\Desktop\slacecodes\centroid_test.zmx"
link = pyz.createLink()
link.zLoadFile(file)


setfile = link.zGetFile().lower().replace('.zmx', '.CFG')
S_512 = 5
grid_size = 20
GAUSS_WAIST, WAIST_X, WAIST_Y, DECENTER_X, DECENTER_Y = 0, 1, 2, 3, 4
beam_waist, x_off, y_off = 5, 0, 0
cfgfile = link.zSetPOPSettings('irr', setfile, startSurf=2, endSurf=2, field=1, wave=1, beamType=GAUSS_WAIST,
                             paramN=( (WAIST_X, WAIST_Y, DECENTER_X, DECENTER_Y), (beam_waist, beam_waist,
                                     x_off, y_off) ), sampx=S_512, sampy=S_512,
                             widex=grid_size, widey=grid_size, tPow=1, auto=0, ignPol=1)
link.zModifyPOPSettings(cfgfile, endSurf=24)
link.zModifyPOPSettings(cfgfile, paramN=( (1, 2, 3, 4), (5, 5,
                                     0, 0) ))
link.zModifyPOPSettings(cfgfile, widex=grid_size)
link.zModifyPOPSettings(cfgfile, widey=grid_size)
link.zModifyPOPSettings(cfgfile, ignPol=1)
#1 to ignore pol;0 to use
link.zSaveFile(file)

chief_angle1_x = 45
chief_angle1_y = 0
chief_angle1_z= 0

chief_angle2_x =0
chief_angle2_y= 45
chief_angle2_z = 0

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


link.zSetSurfaceParameter(4, 3, 0) #3 = x-tilt, 4=y-tilt
link.zSetSurfaceParameter(4, 4, 0)
link.zSetSurfaceParameter(4, 5, 0)

link.zSetSurfaceParameter(8, 3, 0) #3 = x-tilt, 4=y-tilt
link.zSetSurfaceParameter(8, 4, 0)
link.zSetSurfaceParameter(8, 5, 0)

#####
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

ccd1x_var =[]
ccd1y_var = []

ccd2x_var =[]
ccd2y_var = []

ccd1x_fix =[]
ccd1y_fix = []

ccd2x_fix =[]
ccd2y_fix = []


alpha1x_arr=[]
alpha1y_arr=[]
alpha2x_arr=[]
alpha2y_arr=[]
exp_run_arr =[]

beam_x=[]
beam_y=[]

beamx_offset=[]
beamy_offset=[]
ccd2_beamx_offset=[]
ccd2_beamy_offset=[]

pred_alpha1x_arr = []
pred_alpha1y_arr = []
pred_alpha2x_arr = []
pred_alpha2y_arr = []


def two_mirror_system(alpha1x, alpha1y, alpha2x, alpha2y, rev1, rev2, d_m1_m2, d_m2_s1, d_s1_s2):
    delta_1 = d_m1_m2 + d_m2_s1
    print(delta_1)
    delta_s2 = d_m2_s1 + d_s1_s2
    print(delta_s2)
    delta_s1 = d_m2_s1
    delta_max = d_m1_m2+ d_s1_s2 + delta_s1
    print(delta_max)
    c_alphax1, c_alphay1, c_alphax2, c_alphay2 = np.cos(np.deg2rad(alpha1x)) , np.cos(np.deg2rad(alpha1y)) ,np.cos(np.deg2rad(alpha2x)) , np.cos(np.deg2rad(alpha2y))
    c_rev1, s_rev1, c_rev2, s_rev2 = np.cos(np.deg2rad(rev1)) , np.sin(np.deg2rad(rev1)) ,np.cos(np.deg2rad(rev2)) , np.sin(np.deg2rad(rev2))
    
    system = np.matrix([  
        [ 2*delta_1*c_alphax1*c_rev1, -2*delta_1*c_alphax1*s_rev1, 2*delta_s1*c_alphax2*c_rev2, -2*delta_s1*c_alphax2*s_rev2],
        
        [2*delta_1*c_alphay1*s_rev1, 2*delta_1*c_alphay1*c_rev1, 2*delta_s1*c_alphay2*s_rev2, 2*delta_s1*c_alphay2*c_rev2], 
        
        [2*delta_max*c_alphax1*c_rev1, -2*delta_max*c_alphax1*s_rev1, 2*delta_s2*c_alphax2*c_rev2, -2*delta_s2*c_alphax2*s_rev2],
        
        [2*delta_max*c_alphay1*s_rev1, 2*delta_max*c_alphay1*c_rev1, 2*delta_s2*c_alphay2*s_rev2, 2*delta_s2*c_alphay2*c_rev2]
        ])
    
    return(system)

f_sys = two_mirror_system(chief_angle1_x, chief_angle1_y, chief_angle2_x, chief_angle2_y, 90,-90, 400, 200,500)
exp_run=20
start_angle=-5
end_angle = 5
for i in range(exp_run+1):
        alpha_1x = np.random.uniform(start_angle, end_angle)
        alpha_1y = np.random.uniform(start_angle, end_angle)
        alpha_2x = np.random.uniform(start_angle, end_angle)
        alpha_2y = np.random.uniform(start_angle, end_angle) 
        #print(alpha_1x, alpha_1y, alpha_2x, alpha_2y)
        alpha1x_arr.append(alpha_1x)
        alpha1y_arr.append(alpha_1y)
        alpha2x_arr.append(alpha_2x)
        alpha2y_arr.append(alpha_2y)
        exp_run_arr.append(i)
        #make offsets in zemax system 
        link.zSetSurfaceParameter(4, 3, alpha_1x) #3 = x-tilt, 4=y-tilt
        link.zSetSurfaceParameter(8, 3, -alpha_1x)
        link.zSetSurfaceParameter(4, 4, alpha_1y)
        link.zSetSurfaceParameter(8, 4, -alpha_1y)
        
        link.zSetSurfaceParameter(20, 3, alpha_2x) #3 = x-tilt, 4=y-tilt
        link.zSetSurfaceParameter(24, 3, -alpha_2x)
        link.zSetSurfaceParameter(20, 4, alpha_2y)
        link.zSetSurfaceParameter(24, 4, -alpha_2y)
        
        
        
        link.zSaveFile(file)
        #alpha_2x = np.random.uniform(start_angle, end_angle)
        #alpha_2y = np.random.uniform(start_angle, end_angle)
    
        #add offsets
        t_ccdx = link.zOperandValue('POPD', 15, 1, 0, 11)
        t_ccdy = link.zOperandValue('POPD', 15, 1, 0, 12)
        
        ccd1_offsetx = link.zOperandValue('POPD', 26, 1, 0, 11)
        ccd1_offsety = link.zOperandValue('POPD', 26, 1, 0, 12)
        
        ccd2_x = link.zOperandValue('POPD', 28, 1, 0, 11)
        ccd2_y = link.zOperandValue('POPD', 28, 1, 0, 12)
        
        beam_x.append(t_ccdx)
        beam_y.append(t_ccdy)
        
        beamx_offset.append(ccd1_offsetx)
        beamy_offset.append(ccd1_offsety)
        
        ccd2_beamx_offset.append(ccd2_x)
        ccd2_beamy_offset.append(ccd2_y)
        
        
        curr_vec = ccd1_offsetx, ccd1_offsety, ccd2_x, ccd2_y
        inv_f = np.linalg.inv(f_sys)
        #extract predictions of the variations
        curr_angle_vector = np.rad2deg(np.matmul(inv_f, np.transpose(curr_vec)))
        
        #print(curr_angle_vector)
        
        pred_alpha1x=(curr_angle_vector.item(0))
        pred_alpha1y=(curr_angle_vector.item(1))
        pred_alpha2x=(curr_angle_vector.item(2))
        pred_alpha2y=(curr_angle_vector.item(3))
        
        pred_alpha1x_arr.append(pred_alpha1x)
        pred_alpha1y_arr.append(pred_alpha1y)
        pred_alpha2x_arr.append(pred_alpha2x)
        pred_alpha2y_arr.append(pred_alpha2y)
        
        #test them
        
        link.zSetSurfaceParameter(5, 3, -pred_alpha1x) #3 = x-tilt, 4=y-tilt
        link.zSetSurfaceParameter(7, 3, pred_alpha1x)
        link.zSetSurfaceParameter(5, 4, -pred_alpha1y)
        link.zSetSurfaceParameter(7, 4, pred_alpha1y)
        
        link.zSetSurfaceParameter(21, 3, -pred_alpha2x) #3 = x-tilt, 4=y-tilt
        link.zSetSurfaceParameter(23, 3, pred_alpha2x)
        link.zSetSurfaceParameter(21, 4, -pred_alpha2y)
        link.zSetSurfaceParameter(23, 4, pred_alpha2y)
        
        link.zSaveFile(file)
        
        ccd1_offsetx_fix = link.zOperandValue('POPD', 26, 1, 0, 11)
        ccd1_offsety_fix = link.zOperandValue('POPD', 26, 1, 0, 12)
        
        ccd2_offsetx_fix = link.zOperandValue('POPD', 28, 1, 0, 11)
        ccd2_offsety_fix = link.zOperandValue('POPD', 28, 1, 0, 12)
        
        ccd1x_fix.append(ccd1_offsetx_fix)
        ccd1y_fix.append(ccd1_offsety_fix)
        ccd2x_fix.append(ccd2_offsetx_fix)
        ccd2y_fix.append(ccd2_offsety_fix)
        
        
        

pyz.closeLink()

np.savetxt('vardata-f-t1.csv', list(zip(exp_run_arr, alpha1x_arr, alpha1y_arr, alpha2x_arr, alpha2y_arr, 
                                     beamx_offset, beamy_offset, ccd2_beamx_offset, ccd2_beamy_offset 
                        )))
np.savetxt('fixdata-f-t1.csv', list(zip(exp_run_arr, pred_alpha1x_arr, pred_alpha1y_arr, pred_alpha2x_arr, pred_alpha2y_arr,
                       ccd1x_fix, ccd1y_fix, ccd2x_fix, ccd2y_fix 
                        )))
print("done with code!")
