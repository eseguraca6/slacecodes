# -*- coding: utf-8 -*-
"""
Created on Wed Jul 11 14:49:33 2018

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
    link.zModifyPOPSettings(cfgfile, endSurf=26)
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

#fix lens decentering too
    link.zSetSurfaceParameter(16,1, 0)#decenter x,y : 1,2
    link.zSetSurfaceParameter(21,1, 0)
    link.zSetSurfaceParameter(16,2, 0)#decenter x,y : 1,2
    link.zSetSurfaceParameter(21,2, 0)
    
    link.zSetSurfaceParameter(17,1, 0)#decenter x,y : 1,2
    link.zSetSurfaceParameter(20,1, 0)
    link.zSetSurfaceParameter(17,2, 0)#decenter x,y : 1,2
    link.zSetSurfaceParameter(20,2, 0)
    #link.zSetSurfaceParameter(3,5, chief_angle1_z)
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
    link.zSaveFile(file)  
    n_ccd1_offsetx = link.zOperandValue('POPD', 26, 1, 0, 11)
    n_ccd1_offsety = link.zOperandValue('POPD', 26, 1, 0, 12)
    print(n_ccd1_offsetx, n_ccd1_offsety)
    img_str = str(r'C:\Users\pwfa-facet2\Desktop\slacecodes\raytracing\img-norm.csv')
    print(img_str)
    link.zGetTextFile(textFileName=img_str, analysisType='Pop') 
    pyz.closeLink()
    print('config set for testing!')

def algo_var(file, low_angle, high_angle):
    link = pyz.createLink()
    link.zLoadFile(file)
    alpha1_x = np.random.uniform(low_angle, high_angle)
    alpha1_y = np.random.uniform(low_angle, high_angle)
    
    #insert variations
    link.zSetSurfaceParameter(4, 3, alpha1_x) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(4, 4, alpha1_y)
    link.zSetSurfaceParameter(4, 5, 0)

    link.zSetSurfaceParameter(8, 3, -alpha1_x) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(8, 4, -alpha1_y)
    link.zSetSurfaceParameter(8, 5, 0)
    
    link.zSaveFile(file)  
   # print("random input variations:",alpha1_x, alpha1_y, alpha2_x, alpha2_y)
    #print('config set for fixing!')
    img_str = str(r'C:\Users\pwfa-facet2\Desktop\slacecodes\raytracing\varinput-norm.csv')
    print(img_str)
    link.zGetTextFile(textFileName=img_str, analysisType='Pop')
    pyz.closeLink()
    return(alpha1_x, alpha1_y)
    
config_simulation(file,45,0,0)
algo_var(file, 0,0.5)

def lens_mirror_beamline(d1,d2,f, cx, cy, rot_ang):
    cx , cy, rot_ang = np.deg2rad(cx), np.deg2rad(cy), np.deg2rad(rot_ang)
    d_1 = np.matrix([ [d1, 0], [0,d1]  ])
    d_2 = np.matrix([ [d2, 0], [0,d2]  ])
    lens = np.matrix([ [-1/f, 0], [0,-1/f]  ])
    axis = np.matrix([ [2*np.cos(cx), 0], [0, 2*np.cos(cy)]  ])
    rot = np.matrix([ [np.cos(rot_ang), -np.sin(rot_ang)], [np.sin(rot_ang), np.cos(rot_ang)] ])
    result_lens = np.linalg.multi_dot([d_2, lens, d_1, axis, rot])
    #print("lens contribution:",result_lens)
    ## standard beamline 
    mirror_scale = np.matrix([ [d1+d2, 0], [0, d1+d2]  ])
    result_mirror = np.linalg.multi_dot([mirror_scale, axis, rot])
    #print("mirror contribution:",result_mirror)
    result = result_lens + result_mirror
    #print("total beamline:",result)
    return result

def lens_no_errors_matrix(f, d1, d2, chiefx, chiefy, theta_rot, varx1, vary1):
     chiefx, chiefy, theta_rot = np.deg2rad(chiefx), np.deg2rad(chiefy), np.deg2rad(theta_rot)
     varx1, vary1 = np.deg2rad(varx1),np.deg2rad(vary1) 

     drift1 = np.matrix([[1,0,d1,0,0],
                         [0,1,0,d1,0],
                         [0,0,1,0,0],
                         [0,0,0,1,0], 
                         [0,0,0,0,1]])
    
     drift2 = np.matrix([[1,0,d2,0,0],
                         [0,1,0,d2,0],
                         [0,0,1,0,0],
                         [0,0,0,1,0], 
                         [0,0,0,0,1]])
    
     scaling = np.matrix([[1,0,0,0,0],
                         [0,1,0,0,0],
                         [0,0,np.cos(chiefx), 0,0],
                         [0,0,0,np.cos(chiefy),0],
                         [0,0,0,0,1]])
    
     rot1 = np.matrix([[np.cos(theta_rot), -np.sin(theta_rot), 0,0,0],
                       [np.sin(theta_rot), np.cos(theta_rot),0,0,0],
                       [0,0,np.cos(theta_rot), -np.sin(theta_rot),0],
                       [0,0,np.sin(theta_rot), np.cos(theta_rot), 0],
                       [0,0,0,0,1]])
    
     lens = np.matrix([[1,0,0,0,0],
                       [0,1,0,0,0],
                       [-1/f, 0,1,0,0],
                       [0,-1/f,0,1,0],
                       [0,0,0,0,1]])
     t_mirror = np.matrix([[1,0,0,0,0], 
                          [0,1,0,0,0],
                          [0,0,1,0,np.tan(2*varx1)],
                          [0,0,0,1,np.tan(2*vary1)],
                          [0,0,0,0,1]])
     return(drift2*lens*drift1*scaling*rot1*t_mirror)

def algo_fix(file):
    link = pyz.createLink()
    link.zLoadFile(file)
    status = 'not done'

    #model for variation extraction 
    
    fmethod = beamline_matrix(400,45,0,90)#lens_mirror_beamline(200,200,200,45,0,90)
    
    #execture first adjusment 
    it = 1
    print("current iteration:", it)
    #obtain current beam position at 1f point 
    offset_x = link.zOperandValue('POPD', 26, 1, 0, 11)
    offset_y = link.zOperandValue('POPD', 26, 1, 0, 12)
    curr_off_vec = np.matrix([ [offset_x], [offset_y] ])
    print('current beam position:')
    print(np.transpose(curr_off_vec))
        
        #extract intiial variations 
    finv = np.linalg.inv(fmethod)
    curr_var_vec = np.rad2deg(np.matmul(finv, curr_off_vec))
        
    print("current variation vector:")
    print(np.transpose(curr_var_vec))
        
    corr_x = curr_var_vec.item(0)
    corr_y = curr_var_vec.item(1)
    #enact corrections 
    link.zSetSurfaceParameter(5, 3, -corr_x) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(5, 4, -corr_y)
        
    link.zSetSurfaceParameter(7, 3, corr_x)
    link.zSetSurfaceParameter(7, 3, corr_y)
    link.zSaveFile(file)
    while status != 'done':
        i = 1
        #check corrections 
        offset_after_x = link.zOperandValue('POPD', 26, 1, 0, 11)
        offset_after_y = link.zOperandValue('POPD', 26, 1, 0, 12)
        after_vec = np.matrix([ [offset_after_x], [offset_after_y] ])
        print("after correction beam position:")
        print(np.transpose(after_vec))
        
        diff_x = offset_after_x - 0; #not always going to be the origin
        diff_y = offset_after_y -0; #not always going to be the origin
        
        if (diff_x < 0.0001) and (diff_y <0.0001):
            status = 'done'
        else:
            #make further corrections
            after_var_vec = np.rad2deg(np.matmul(finv, after_vec))
        
            print("after variation vector:")
            print(np.transpose(after_var_vec))
        
            a_corr_x = curr_var_vec.item(0)
            a_corr_y = curr_var_vec.item(1)
            #enact corrections
            new_corr_x = corr_x + a_corr_x
            new_corr_y = corr_y + a_corr_y
            link.zSetSurfaceParameter(5, 3, -new_corr_x) #3 = x-tilt, 4=y-tilt
            link.zSetSurfaceParameter(5, 4, -new_corr_y)
        
            link.zSetSurfaceParameter(7, 3, new_corr_x)
            link.zSetSurfaceParameter(7, 3, new_corr_y)
            link.zSaveFile(file)
            print('current it whileloop:',i)
        i=i+1
        
        #check current variations         
        
        
algo_fix(file)        
        
    

