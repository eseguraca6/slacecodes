# -*- coding: utf-8 -*-
"""
Created on Mon May 21 15:12:02 2018

@author: pwfa-facet2
"""

# -*- coding: utf-8 -*-
"""
Created on Fri May 18 15:13:09 2018

@author: pwfa-facet2
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit
#import pyzdde.arraytrace as at
import pyzdde.zdde as pyz

import random as rand

def beamline_matrix(d, c_x, c_y, rot_angle):
    c_x, c_y, rot_angle = np.deg2rad(c_x), np.deg2rad(c_y), np.deg2rad(rot_angle)
    drift = np.matrix([[d,0], [0,d]])
    scaling = np.matrix([[2*np.cos(c_x), 0], [0,2*np.cos(c_y)]])
    rot = np.matrix([[np.cos(rot_angle), -np.sin(rot_angle)], [np.sin(rot_angle), np.cos(rot_angle)]])
    return(drift*scaling*rot)


file = r"C:\Users\pwfa-facet2\Desktop\slacecodes\raytracing\ml.zmx"
def config_simulation(file, chief_angle1_x,chief_angle1_y, chief_angle1_z):
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
    link.zModifyPOPSettings(cfgfile, endSurf=24)
    link.zModifyPOPSettings(cfgfile, paramN=( (1, 2, 3, 4), (5, 5,
                                     0, 0) ))
    link.zModifyPOPSettings(cfgfile, widex=grid_size)
    link.zModifyPOPSettings(cfgfile, widey=grid_size)
    link.zModifyPOPSettings(cfgfile, ignPol=1)
#1 to ignore pol;0 to use
    link.zSaveFile(file)
    link.zSetSurfaceParameter(2,3, chief_angle1_x)
    link.zSetSurfaceParameter(2,4, chief_angle1_y)
    link.zSetSurfaceParameter(2,5, chief_angle1_z)
    
    link.zSetSurfaceParameter(8,3, chief_angle1_x)
    link.zSetSurfaceParameter(8,4, chief_angle1_y)
    link.zSetSurfaceParameter(8,5 , chief_angle1_z)

#fix lens decentering too
    link.zSetSurfaceParameter(14,1, 0)#decenter x,y : 1,2
    link.zSetSurfaceParameter(19,1, 0)
    link.zSetSurfaceParameter(14,2, 0)#decenter x,y : 1,2
    link.zSetSurfaceParameter(19,2, 0)
    #link.zSetSurfaceParameter(3,5, chief_angle1_z)
#fix lens decentering too
    link.zSetSurfaceParameter(15,1, 0)#decenter x,y : 1,2
    link.zSetSurfaceParameter(18,1, 0)
    link.zSetSurfaceParameter(15,2, 0)#decenter x,y : 1,2
    link.zSetSurfaceParameter(18,2, 0)
#fix var/pos empty 
    link.zSaveFile(file)

#var
    link.zSetSurfaceParameter(3, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(3, 4, 0)
    link.zSetSurfaceParameter(3, 5, 0)

    link.zSetSurfaceParameter(7, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(7, 4, 0)
    link.zSetSurfaceParameter(7, 5, 0)

#####
#fix
    link.zSetSurfaceParameter(4, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(4, 4, 0)
    link.zSetSurfaceParameter(4, 5, 0)

    link.zSetSurfaceParameter(6, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(6, 4, 0)
    link.zSetSurfaceParameter(6, 5, 0)
    link.zSaveFile(file)    
    pyz.closeLink()
    print('config set for testing!')

def standard_variation(low_var, high_var, delta):
    deg_range = np.arange(low_var, high_var+delta,delta)
    
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
    #add variations
    beforem1_x=[]
    beforem1_y=[]
        #link.zSetSurfaceParameter(3,5, chief_angle1_z)

#fix var/pos empty 
    link.zSaveFile(file)
    for i in deg_range:
        link.zSetSurfaceParameter(3, 3, i) #3 = x-tilt, 4=y-tilt
        link.zSetSurfaceParameter(3, 4, i)
        link.zSetSurfaceParameter(3, 5, 0)

        link.zSetSurfaceParameter(7, 3, i) #3 = x-tilt, 4=y-tilt
        link.zSetSurfaceParameter(7, 4, -i)
        link.zSetSurfaceParameter(7, 5, 0)
        link.zSaveFile(file)
        #get offsets 
        t_ccdx = link.zOperandValue('POPD', 22, 1, 0, 11)
        t_ccdy = link.zOperandValue('POPD', 22, 1, 0, 12)
        beforem1_x.append(t_ccdx)
        beforem1_y.append(t_ccdy)
    pyz.closeLink()
    np.savetxt(str(r"C:\Users\pwfa-facet2\Desktop\slacecodes\raytracing\\") + "m1m2l1-nodecenteringlensy-"+str(low_var)+"-"+str(high_var)+"-"+str(delta)+'.csv', list(zip(deg_range, beforem1_x, beforem1_y)))
    print("done")
    #return(beforem1_x, beforem1_y, ccd1xarr, ccd1yarr,ccd2_x,ccd2_y

def algo_var(file, low_angle, high_angle):
    link = pyz.createLink()
    link.zLoadFile(file)
    alpha1_x = np.random.uniform(low_angle, high_angle)
    alpha1_y = np.random.uniform(low_angle, high_angle)
    
    #insert variations
    link.zSetSurfaceParameter(3, 3, alpha1_x) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(3, 4, alpha1_y)
    link.zSetSurfaceParameter(3, 5, 0)

    link.zSetSurfaceParameter(7, 3, -alpha1_x) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(7, 4, -alpha1_y)
    link.zSetSurfaceParameter(7, 5, 0)
    
    link.zSaveFile(file)  
   # print("random input variations:",alpha1_x, alpha1_y, alpha2_x, alpha2_y)
    #print('config set for fixing!')
    pyz.closeLink()
    return(alpha1_x, alpha1_y)

#algo_var(file, 9,10)
f_sys = beamline_matrix(400, 45,0,90)
print("==========")

def algo_fix(file):
    link = pyz.createLink()
    link.zLoadFile(file)
    #extract offsets:
    status = "not done"
    angle_fix_approx_arr=[]
    offset_correction_arr=[]
    ccd1x_arr =[]
    ccd1y_arr =[]

    curr_r=0
    print("current trial num (this is the initial must fix):",curr_r)
    ccd1_offsetx = link.zOperandValue('POPD', 22, 1, 0, 11)
    ccd1_offsety = link.zOperandValue('POPD', 22, 1, 0, 12)
    
    ccd1x_arr.append(ccd1_offsetx)
    ccd1y_arr.append(ccd1_offsety)

    
    #make offsets vector
    curr_vec = np.matrix([[ccd1_offsetx], [ccd1_offsety]])
    print("input offsets:", np.transpose(curr_vec))
    offset_correction_arr.append(curr_vec)
        #get variations: 
    inv_f = np.linalg.inv(f_sys)
        #extract predictions of the variations
        
    curr_angle_vector = np.rad2deg(np.matmul(inv_f, (curr_vec)))
    
    pred_alpha1x_arr =[]
    pred_alpha1y_arr =[]
    
    angle_fix_approx_arr.append(curr_angle_vector)
    
    pred_alpha1x=(curr_angle_vector.item(0))
    pred_alpha1y=(curr_angle_vector.item(1))
    
    pred_alpha1x_arr.append(pred_alpha1x)
    pred_alpha1y_arr.append(pred_alpha1y)
    
    print("predicted variations:", np.transpose(curr_angle_vector))
    
        #input this adjustments to system to see rectification
    link.zSetSurfaceParameter(4, 3, -pred_alpha1x) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(4, 4, -pred_alpha1y)
    link.zSetSurfaceParameter(4, 5, 0)

    link.zSetSurfaceParameter(6, 3, pred_alpha1x) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(6, 4, pred_alpha1y)
    link.zSetSurfaceParameter(6, 5, 0)
    link.zSaveFile(file)
    
    n_ccd1_offsetx = link.zOperandValue('POPD', 22, 1, 0, 11)
    n_ccd1_offsety = link.zOperandValue('POPD', 22, 1, 0, 12)
    
    #make offsets vector
    n_curr_vec = np.matrix([[n_ccd1_offsetx], [n_ccd1_offsety]])
    offset_correction_arr.append(n_curr_vec)
    i=0
    print("first initial fix:", np.transpose(n_curr_vec))
    ccd1x_arr.append(n_ccd1_offsetx)
    ccd1y_arr.append(n_ccd1_offsety)
    #print(np.transpose(angle_fix_approx_arr))

    while status != "done":
        #get new variations 
        curr_r = curr_r+1
        print("current trial run:",curr_r)
        print("before adjustments vector:", np.transpose(n_curr_vec))
        n_var_angle_vector = np.rad2deg(np.matmul(inv_f, (n_curr_vec)))
        #get the new approximation 
        best_fix = angle_fix_approx_arr[i] + n_var_angle_vector
        #print(np.transpose(angle_fix_approx_arr))
        b_pred_alpha1x=(best_fix.item(0))
        b_pred_alpha1y=(best_fix.item(1))
        angle_fix_approx_arr.append(best_fix)
        i=i+1
        #print(angle_fix_approx_arr)
        print("new correction (adding predictions):", np.transpose(best_fix))
        #make adjustments for better fit
        link.zSetSurfaceParameter(4, 3, -b_pred_alpha1x) #3 = x-tilt, 4=y-tilt
        link.zSetSurfaceParameter(4, 4, -b_pred_alpha1y)
        link.zSetSurfaceParameter(4, 5, 0)
                
        link.zSetSurfaceParameter(6, 3, b_pred_alpha1x) #3 = x-tilt, 4=y-tilt
        link.zSetSurfaceParameter(6, 4, b_pred_alpha1y)
        link.zSetSurfaceParameter(6, 5, 0)
        link.zSaveFile(file)
        
        #add new fit angles
        pred_alpha1x_arr.append(b_pred_alpha1x)
        pred_alpha1y_arr.append(b_pred_alpha1y)        
        #see fixes
        n_ccd1_offsetx = link.zOperandValue('POPD', 22, 1, 0, 11)
        n_ccd1_offsety = link.zOperandValue('POPD', 22, 1, 0, 12)  
        n_curr_vec = np.matrix([[n_ccd1_offsetx], [n_ccd1_offsety]])
        print("new offsets:", np.transpose(n_curr_vec))
        offset_correction_arr.append(n_curr_vec)
        print("++++++++")
        #add new offsets 
        ccd1x_arr.append(n_ccd1_offsetx)
        ccd1y_arr.append(n_ccd1_offsety)      
        error = 0.00001 # 10 nm error 
        img_str = str(r'C:\Users\pwfa-facet2\Desktop\slacecodes\raytracing')+'\\'+'img-it'+str(i)+'.csv'
        print(img_str)
        link.zGetTextFile(textFileName=img_str, analysisType='Pop')
        if np.abs(n_ccd1_offsetx) <= error and np.abs(n_ccd1_offsety):
            status = "done"
            pyz.closeLink()
            #np.savetxt('var'+'.csv', list(zip(angles_xtilt, beam_x, beam_y,ccd1x_arr,ccd1y_arr,ccd2x_arr,ccd2y_arr)))
            return(pred_alpha1x_arr, pred_alpha1y_arr, ccd1x_arr,ccd1y_arr)
        else:
            status="not done"
        #return(angle_fix_approx_arr, offset_correction_arr)
#algo_var(file, 9,10)
#a= initial_algo_fix(file)
#print(a[0])
#print("=====")
#print(a[1])

def decentering(file, x_off, y_off):
    link = pyz.createLink()
    link.zLoadFile(file)
    link.zSetSurfaceParameter(14,1, x_off)#decenter x,y : 1,2
    link.zSetSurfaceParameter(19,1, -x_off)
    link.zSetSurfaceParameter(14,2, y_off)#decenter x,y : 1,2
    link.zSetSurfaceParameter(19,2, -y_off)
    link.zSaveFile(file)
    pyz.closeLink()


def feedback_method_l(file, low_angle, high_angle, run_num, x_off, y_off):
    #get the system running 
    approx_arr =[] #this has the initial adjustment and subsequent adjustments. It will tend to the input value
    correction_arr = [] #contains the corrections to find the best adjustment; first item is the intial variation pred.
    input_variations =[]
    beamoffset_arr =[]
    f_sys =beamline_matrix(400, 45,0,90)
    config_simulation(file, 45,0,0)
    #fix lens decentering too    ## add the lens decentering
    decentering(file, x_off, y_off)
    #execute the variations
    for i in range(0,run_num):
        #variations
        algo_var(file, low_angle, high_angle)
        #fix this.
        curr_fix = algo_fix(file)
        np.savetxt('variation-files-trial-'+ str(i)+'.csv', list(zip(curr_fix[0], curr_fix[1], curr_fix[2], curr_fix[3])))

config_simulation(file, 45,0,0)
feedback_method_l(file, -1, 1, 1, 4, 1)
