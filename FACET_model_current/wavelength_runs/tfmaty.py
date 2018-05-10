# -*- coding: utf-8 -*-
"""
Created on Wed May  9 13:04:31 2018

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

file = r"C:\Users\pwfa-facet2\Desktop\slacecodes\centroid_test.zmx"
link = pyz.createLink()
link.zLoadFile(file)

######
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

norm_x1 = link.zOperandValue('POPD', 30, 1, 0, 11)
norm_y1= link.zOperandValue('POPD', 30, 1, 0, 12)
norm_x2 = link.zOperandValue('POPD', 32, 1, 0, 11)
norm_y2= link.zOperandValue('POPD', 32, 1, 0, 12)
print("norm x,y:", norm_x1, norm_y1, norm_x2, norm_y2)
##########

fmat = two_mirror_system(45,0,0,45,90,-90, 400,200,500)

var_alpha1x = np.random.uniform(-1,1)
var_alpha1y  =np.random.uniform(-1,1)
var_alpha2x  =np.random.uniform(-1,1)
var_alpha2y  =np.random.uniform(-1,1)

print(var_alpha1x, var_alpha1y, var_alpha2x, var_alpha2y)

#inserting var into zemax 

link.zSetSurfaceParameter(4, 3, var_alpha1x) #3 = x-tilt, 4=y-tilt
link.zSetSurfaceParameter(4, 4, var_alpha1y)
link.zSetSurfaceParameter(4, 5, 0)

link.zSetSurfaceParameter(8, 3, -var_alpha1x) #3 = x-tilt, 4=y-tilt
link.zSetSurfaceParameter(8, 4, -var_alpha1y)
link.zSetSurfaceParameter(8, 5, 0)


link.zSetSurfaceParameter(20, 3, var_alpha2x) #3 = x-tilt, 4=y-tilt
link.zSetSurfaceParameter(20, 4, var_alpha2y)
link.zSetSurfaceParameter(20, 5, 0)

link.zSetSurfaceParameter(24, 3, -var_alpha2x) #3 = x-tilt, 4=y-tilt
link.zSetSurfaceParameter(24, 4, -var_alpha2y)
link.zSetSurfaceParameter(24, 5, 0)

link.zSaveFile(file)


halt_cond = 'not done'
f_sys= two_mirror_system(45,0,0,45,90,-90,400,200,500)
while halt_cond != 'done':
    i = 1
    print(i)
    ccd1_offsetx = link.zOperandValue('POPD', 30, 1, 0, 11)
    ccd1_offsety = link.zOperandValue('POPD', 30, 1, 0, 12)
        
    ccd2_x = link.zOperandValue('POPD', 32, 1, 0, 11)
    ccd2_y = link.zOperandValue('POPD', 32, 1, 0, 12)
    curr_vec = np.matrix([[ccd1_offsetx], [ccd1_offsety], [ccd2_x], [ccd2_y]])
    print("offsets:")
    print(curr_vec)
    inv_f = np.linalg.inv(f_sys)
        #extract predictions of the variations
        
    curr_angle_vector = np.rad2deg(np.matmul(inv_f, (curr_vec)))

    pred_alpha1x=(curr_angle_vector.item(0))
    pred_alpha1y=(curr_angle_vector.item(1))
    pred_alpha2x=(curr_angle_vector.item(2))
    pred_alpha2y=(curr_angle_vector.item(3))
    
    link.zSetSurfaceParameter(5, 3, -pred_alpha1x) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(7, 3, pred_alpha1x)
    link.zSetSurfaceParameter(5, 4, -pred_alpha1y)
    link.zSetSurfaceParameter(7, 4, pred_alpha1y)
        
    link.zSetSurfaceParameter(21, 3, -pred_alpha2x) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(23, 3, pred_alpha2x)
        
    link.zSetSurfaceParameter(21, 4, -pred_alpha2y)
    link.zSetSurfaceParameter(23, 4, pred_alpha2y)
    link.zSaveFile(file)
    
    ccd1_offsetx_fix = link.zOperandValue('POPD', 30, 1, 0, 11)
    ccd1_offsety_fix = link.zOperandValue('POPD', 30, 1, 0, 12)
        
    ccd2_offsetx_fix = link.zOperandValue('POPD', 32, 1, 0, 11)
    ccd2_offsety_fix = link.zOperandValue('POPD', 32, 1, 0, 12)
    print("pred var:")
    print(pred_alpha1x, pred_alpha1y, pred_alpha2x, pred_alpha2y)
    
    diffx1 = ccd1_offsetx- norm_x1
    diffy1 =  ccd1_offsety - norm_y1
    diffx2 = ccd2_x- norm_x2
    diffy2 =  ccd2_y - norm_y2
    
    if diffx1 <= 0.001 and diffy1 <= 0.001 and diffx2 <= 0.001 and diffy2 <= 0.001:
        halt_cond = 'done'
    i =i+1
    
    
    

"""














var_x1 = link.zOperandValue('POPD', 30, 1, 0, 11)
var_y1= link.zOperandValue('POPD', 30, 1, 0, 12)
var_x2 = link.zOperandValue('POPD', 32, 1, 0, 11)
var_y2= link.zOperandValue('POPD', 32, 1, 0, 12)
print("var x,y:", var_x1, var_y1, var_x2, var_y2)
diff_norm_var_x1 = var_x1- norm_x1
diff_norm_var_x2 = var_x2- norm_x2
diff_norm_var_y1 = var_y1- norm_y1
diff_norm_var_y2 = var_y2- norm_y2
print("diff between var and norm:", diff_norm_var_x1, diff_norm_var_y1, diff_norm_var_x2, diff_norm_var_y2 )
#getting var to do adjustments to rectify misalignment

curr_offset_vec = np.matrix([[var_x1], [var_y1], [var_x2], [var_y2]])
inv_fmatrix = np.linalg.inv(fmat)
curr_variations= np.rad2deg(np.matmul(inv_fmatrix, curr_offset_vec))
print("curr variations:", curr_variations)

pred_alpha1x = curr_variations.item(0)
pred_alpha1y = curr_variations.item(1)
pred_alpha2x = curr_variations.item(2)
pred_alpha2y = curr_variations.item(3)

#introducing corrections:
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

fix_x1 = link.zOperandValue('POPD', 30, 1, 0, 11)
fix_y1= link.zOperandValue('POPD', 30, 1, 0, 12)
fix_x2 = link.zOperandValue('POPD', 32, 1, 0, 11)
fix_y2= link.zOperandValue('POPD', 32, 1, 0, 12)
print("fixed x,y:", fix_x1, fix_y1, fix_x2, fix_y2)

diff_norm_fix_x1 = fix_x1 - norm_x1
diff_norm_fix_x2 = fix_x2 - norm_x2
diff_norm_fix_y1 = fix_y1 - norm_y1
diff_norm_fix_y2 = fix_y2 - norm_y2

diff_var_fix_x1 = var_x1 - fix_x1 
diff_var_fix_y1 = var_y1 - fix_y1 
diff_var_fix_x2 = var_x2 - fix_x2 
diff_var_fix_y2 = var_y2 - fix_y2 

print("diff between fix and nrm x,y:", diff_norm_fix_x1, diff_norm_fix_y1, diff_norm_fix_x2, diff_norm_fix_y2)

print("improvement from original offset:", diff_var_fix_x1, diff_var_fix_y1, diff_var_fix_x2, diff_var_fix_y2)

pyz.closeLink()


"""