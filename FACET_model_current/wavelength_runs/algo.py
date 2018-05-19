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

#config_simulation(file, 45,0,0,0,45,0)

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
   # print("random input variations:",alpha1_x, alpha1_y, alpha2_x, alpha2_y)
    #print('config set for fixing!')
    pyz.closeLink()
    return(alpha1_x, alpha1_y, alpha2_x, alpha2_y)

#algo_var(file, 9,10)
f_sys = two_mirror_system(45,0,0,45,90,-90,400,200,500)
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
    ccd2x_arr=[]
    ccd2y_arr=[]
    curr_r=0
    print("current trial num (this is the initial must fix:",curr_r)
    ccd1_offsetx = link.zOperandValue('POPD', 30, 1, 0, 11)
    ccd1_offsety = link.zOperandValue('POPD', 30, 1, 0, 12)
        
    ccd2_x = link.zOperandValue('POPD', 32, 1, 0, 11)
    ccd2_y = link.zOperandValue('POPD', 32, 1, 0, 12)
    
    ccd1x_arr.append(ccd1_offsetx)
    ccd1y_arr.append(ccd1_offsety)
    ccd2x_arr.append(ccd2_x)
    ccd2y_arr.append(ccd2_y)
    
    #make offsets vector
    curr_vec = np.matrix([[ccd1_offsetx], [ccd1_offsety], [ccd2_x], [ccd2_y]])
    print("input offsets:", np.transpose(curr_vec))
    offset_correction_arr.append(curr_vec)
        #get variations: 
    inv_f = np.linalg.inv(f_sys)
        #extract predictions of the variations
        
    curr_angle_vector = np.rad2deg(np.matmul(inv_f, (curr_vec)))
    
    pred_alpha1x_arr =[]
    pred_alpha1y_arr =[]
    pred_alpha2x_arr =[]
    pred_alpha2y_arr =[]
    
    angle_fix_approx_arr.append(curr_angle_vector)
    
    pred_alpha1x=(curr_angle_vector.item(0))
    pred_alpha1y=(curr_angle_vector.item(1))
    pred_alpha2x=(curr_angle_vector.item(2))
    pred_alpha2y=(curr_angle_vector.item(3))
    
    pred_alpha1x_arr.append(pred_alpha1x)
    pred_alpha1y_arr.append(pred_alpha1y)
    pred_alpha2x_arr.append(pred_alpha2x)
    pred_alpha2y_arr.append(pred_alpha2y)
    
    print("predicted variations:", np.transpose(curr_angle_vector))
    
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
    offset_correction_arr.append(n_curr_vec)
    i=0
    print("first initial fix:", np.transpose(n_curr_vec))
    ccd1x_arr.append(n_ccd1_offsetx)
    ccd1y_arr.append(n_ccd1_offsety)
    ccd2x_arr.append(n_ccd2_x)
    ccd2y_arr.append(n_ccd2_y)
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
        b_pred_alpha2x=(best_fix.item(2))
        b_pred_alpha2y=(best_fix.item(3))
        angle_fix_approx_arr.append(best_fix)
        i=i+1
        #print(angle_fix_approx_arr)
        print("new correction (adding predictions):", np.transpose(best_fix))
        #make adjustments for better fit
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
        
        #add new fit angles
        pred_alpha1x_arr.append(b_pred_alpha1x)
        pred_alpha1y_arr.append(b_pred_alpha1y)
        pred_alpha2x_arr.append(b_pred_alpha2x)
        pred_alpha2y_arr.append(b_pred_alpha2y)
        
        #see fixes
        n_ccd1_offsetx = link.zOperandValue('POPD', 30, 1, 0, 11)
        n_ccd1_offsety = link.zOperandValue('POPD', 30, 1, 0, 12)  
        n_ccd2_x = link.zOperandValue('POPD', 32, 1, 0, 11)
        n_ccd2_y = link.zOperandValue('POPD', 32, 1, 0, 12)
        n_curr_vec = np.matrix([[n_ccd1_offsetx], [n_ccd1_offsety], [n_ccd2_x], [n_ccd2_y]])
        print("new offsets:", np.transpose(n_curr_vec))
        offset_correction_arr.append(n_curr_vec)
        print("++++++++")
        #add new offsets 
        ccd1x_arr.append(n_ccd1_offsetx)
        ccd1y_arr.append(n_ccd1_offsety)
        ccd2x_arr.append(n_ccd2_x)
        ccd2y_arr.append(n_ccd2_y)
        
        error = 0.00001
        if np.abs(n_ccd1_offsetx) <= error and np.abs(n_ccd1_offsety) <= error and np.abs(n_ccd2_x) <= error and np.abs(n_ccd2_y) <= error:
            status = "done"
            pyz.closeLink()
            #np.savetxt('var'+'.csv', list(zip(angles_xtilt, beam_x, beam_y,ccd1x_arr,ccd1y_arr,ccd2x_arr,ccd2y_arr)))
            return(pred_alpha1x_arr, pred_alpha1y_arr, pred_alpha2x_arr, pred_alpha2y_arr, ccd1x_arr,ccd1y_arr,ccd2x_arr,ccd2y_arr)
        else:
            status="not done"
        #return(angle_fix_approx_arr, offset_correction_arr)
#algo_var(file, 9,10)
#a= algo_fix(file)
#print(a[0])
#print("=====")
#print(a[1])

def feedback_method(file, low_angle, high_angle, run_num):
    #get the system running 
    approx_arr =[] #this has the initial adjustment and subsequent adjustments. It will tend to the input value
    correction_arr = [] #contains the corrections to find the best adjustment; first item is the intial variation pred.
    input_variations =[]
    beamoffset_arr =[]
    f_sys = two_mirror_system(45,0,0,45,90,-90,400,200,500)
    config_simulation(file, 45,0,0,0,45,0)
    #execute the variations
    for i in range(0,run_num+1):
        curr_var = algo_var(file, low_angle, high_angle)
        print("input random:", curr_var)
        #fix this.
        curr_fix = algo_fix(file)
        np.savetxt(str(low_angle)+"-"+str(high_angle)+'var-'+ str(i)+'.csv', list(zip(curr_fix[0], curr_fix[1], curr_fix[2],
                   curr_fix[3], curr_fix[4], curr_fix[5], curr_fix[6], curr_fix[7])))
        np.savetxt(str(low_angle)+"-"+str(high_angle)+'-inputvar'+str(i)+'.csv',curr_var)
        

    
"""
 for i in range(0, run_num):
        #get random variations:
        r_alpha1x =np.random.uniform(low_angle, high_angle)
        r_alpha1y =np.random.uniform(low_angle, high_angle)
        r_alpha2x=np.random.uniform(low_angle, high_angle)
        r_alpha2y = np.random.uniform(low_angle, high_angle)
        input_variations.append(np.matrix([[r_alpha1x], [r_alpha1y], [r_alpha2x], [r_alpha2y]]))
        print(np.transpose(input_variations))
        #use the variations
        link = pyz.createLink()
        link.zLoadFile(file)
        #insert variations
        link.zSetSurfaceParameter(4, 3, r_alpha1x) #3 = x-tilt, 4=y-tilt
        link.zSetSurfaceParameter(4, 4, r_alpha1y)
        link.zSetSurfaceParameter(4, 5, 0)

        link.zSetSurfaceParameter(8, 3, -r_alpha1x) #3 = x-tilt, 4=y-tilt
        link.zSetSurfaceParameter(8, 4, -r_alpha1y)
        link.zSetSurfaceParameter(8, 5, 0)
    
        link.zSetSurfaceParameter(20, 3, r_alpha2x) #3 = x-tilt, 4=y-tilt
        link.zSetSurfaceParameter(20, 4, r_alpha2y)
        link.zSetSurfaceParameter(20, 5, 0)

        link.zSetSurfaceParameter(24, 3, -r_alpha2x) #3 = x-tilt, 4=y-tilt
        link.zSetSurfaceParameter(24, 4, -r_alpha2y)
        link.zSetSurfaceParameter(24, 5, 0)
        link.zSaveFile(file)  
        #get the offset of how bad we are misaligned
        ccd1x_offset = link.zOperandValue('POPD', 30, 1, 0, 11)
        ccd1y_offset = link.zOperandValue('POPD', 30, 1, 0, 12)
        ccd2x_offset = link.zOperandValue('POPD', 30, 1, 0, 11)
        ccd2y_offset = link.zOperandValue('POPD', 30, 1, 0, 12)
        
        inv_f = np.linalg.inv(f_sys)
        
        beamoffset_vector = np.matrix([ [ccd1x_offset], [ccd1y_offset], [ccd2x_offset], [ccd2y_offset]])
        beamoffset_arr.append(beamoffset_vector)
        beamoffset_variations_vector =  np.rad2deg(np.matmul(inv_f, (beamoffset_vector)))
        approx_arr.append(beamoffset_variations_vector)
        correction_arr.append(beamoffset_variations_vector)
        #execute first change
        
        pred_alpha1x=(beamoffset_variations_vector.item(0))
        pred_alpha1y=(beamoffset_variations_vector.item(1))
        pred_alpha2x=(beamoffset_variations_vector.item(2))
        pred_alpha2y=(beamoffset_variations_vector.item(3))
        
        print(pred_alpha1x, pred_alpha1y, pred_alpha2x, pred_alpha2y)
        pyz.closeLink()
        
        
"""



































"""

 i=0
    while status != "done":
        if n_ccd1_offsetx <= 0.0001 and n_ccd1_offsety <= 0.0001 and n_ccd2_x <= 0.0001 and n_ccd2_y <= 0.0001:
            status = "done"
            pyz.closeLink()
        else:
            #get new variations
            n_var_angle_vector = np.rad2deg(np.matmul(inv_f, (n_curr_vec)))
            print(" new predicted variations:", np.transpose(n_var_angle_vector))
            #get the new approximation 
            best_fix = curr_angle_vector + n_var_angle_vector
            b_pred_alpha1x=(best_fix.item(0))
            b_pred_alpha1y=(best_fix.item(1))
            b_pred_alpha2x=(best_fix.item(2))
            b_pred_alpha2y=(best_fix.item(3))
            i=i+1
            print("new correction (adding predictions):", np.transpose(best_fix))
            #make adjustments for better fit
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
            #see fixes
            n_ccd1_offsetx = link.zOperandValue('POPD', 30, 1, 0, 11)
            n_ccd1_offsety = link.zOperandValue('POPD', 30, 1, 0, 12)  
            n_ccd2_x = link.zOperandValue('POPD', 32, 1, 0, 11)
            n_ccd2_y = link.zOperandValue('POPD', 32, 1, 0, 12)
            n_curr_vec = np.matrix([[n_ccd1_offsetx], [n_ccd1_offsety], [n_ccd2_x], [n_ccd2_y]])
            print("new offsets:", np.transpose(n_curr_vec))
            curr_r=curr_r+1
            status="not done"
   
 while status != "done":
            if f_ccd1_offsetx <= 0.0001 and f_ccd1_offsety <= 0.0001 and f_ccd2_x <= 0.0001 and f_ccd2_y <= 0.0001:
                status = "done"
                pyz.closeLink()
            else:
                n_curr_angle_vector = np.rad2deg(np.matmul(inv_f, (n_curr_vec)))
                print(" new predicted variations:", np.transpose(n_curr_angle_vector))
                best_fix= angle_fix_approx_arr[i] + curr_angle_vector
                b_pred_alpha1x=(best_fix.item(0))
                b_pred_alpha1y=(best_fix.item(1))
                b_pred_alpha2x=(best_fix.item(2))
                b_pred_alpha2y=(best_fix.item(3))
                print("new correction (adding predictions):", np.transpose(best_fix))
                i=i+1
                angle_fix_approx_arr.append(best_fix)
                #make adjustments for better fit
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
        
                f_ccd1_offsetx = link.zOperandValue('POPD', 30, 1, 0, 11)
                f_ccd1_offsety = link.zOperandValue('POPD', 30, 1, 0, 12)  
                f_ccd2_x = link.zOperandValue('POPD', 32, 1, 0, 11)
                f_ccd2_y = link.zOperandValue('POPD', 32, 1, 0, 12)
                print("fit offsets (results of better prediction):", f_ccd1_offsetx,f_ccd1_offsety,f_ccd2_x,f_ccd2_y)

def algo_test(file):
    link = pyz.createLink()
    link.zLoadFile(file)
    #extract offsets:
    curr_r = 0
    status = "not done"
    angle_fix_approx_arr=[]
    while status !='done':
        print("print it num:",curr_r)
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
        
        angle_fix_approx_arr.append(curr_angle_vector)
        
        pred_alpha1x=(curr_angle_vector.item(0))
        pred_alpha1y=(curr_angle_vector.item(1))
        pred_alpha2x=(curr_angle_vector.item(2))
        pred_alpha2y=(curr_angle_vector.item(3))
    
        print(" pred. variations:", np.transpose(curr_angle_vector))
    
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
        print("offsets due to adjustments:", np.transpose(n_curr_vec))
        if n_ccd1_offsetx <= 0.0001 and n_ccd1_offsety <= 0.0001 and n_ccd2_x <= 0.0001 and n_ccd2_y <= 0.0001:
            n_curr_angle_vector = np.rad2deg(np.matmul(inv_f, (n_curr_vec)))
            print(" new predicted variations:", np.transpose(n_curr_angle_vector))
            best_fix= n_curr_angle_vector + curr_angle_vector
            b_pred_alpha1x=(best_fix.item(0))
            b_pred_alpha1y=(best_fix.item(1))
            b_pred_alpha2x=(best_fix.item(2))
            b_pred_alpha2y=(best_fix.item(3))
            print("adding two fixes in angles:", np.transpose(n_curr_angle_vector + curr_angle_vector))
    
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
            status="done"
            pyz.closeLink()
        
algo_test(file)
    

"""