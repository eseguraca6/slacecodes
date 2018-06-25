# -*- coding: utf-8 -*-
"""
Created on Tue Jun 12 14:47:43 2018

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

def algo_var(file, low_angle, high_angle, x_dmax,y_dmax):
    link = pyz.createLink()
    link.zLoadFile(file)
    alpha1_x = np.random.uniform(low_angle, high_angle)
    alpha1_y = np.random.uniform(low_angle, high_angle)
    x_decenter, y_decenter = np.random.uniform(-x_dmax, x_dmax), np.random.uniform(-y_dmax, y_dmax)
    print("random input var:", alpha1_x,alpha1_y)
    print("random decenter var:", x_decenter, y_decenter)
    #insert variations
    link.zSetSurfaceParameter(4, 3, alpha1_x) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(4, 4, alpha1_y)
    link.zSetSurfaceParameter(4, 5, 0)

    link.zSetSurfaceParameter(8, 3, -alpha1_x) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(8, 4, -alpha1_y)
    link.zSetSurfaceParameter(8, 5, 0)
    link.zSetSurfaceParameter(16,1, x_decenter)#decenter x,y : 1,2
    link.zSetSurfaceParameter(21,1, -x_decenter)
    link.zSetSurfaceParameter(16,2, y_decenter)#decenter x,y : 1,2
    link.zSetSurfaceParameter(21,2, -y_decenter)
    link.zSaveFile(file)  
   # print("random input variations:",alpha1_x, alpha1_y, alpha2_x, alpha2_y)
    #print('config set for fixing!')
    img_str = str(r'C:\Users\pwfa-facet2\Desktop\slacecodes\raytracing\varinput-norm.csv')
    print(img_str)
    link.zGetTextFile(textFileName=img_str, analysisType='Pop')
    pyz.closeLink()
    return(alpha1_x, alpha1_y)

#algo_var(file, 9,10)
def one_mirror(cx, cy, d):
    theta = np.deg2rad(90)
    cx, cy, np.deg2rad(cx), np.deg2rad(cy)
    scale = np.matrix([[np.cos(cx), 0], [0, np.cos(cy)]])
    drift = np.matrix([[d,0], [0,d]])
    rot = np.matrix([[np.cos(theta), -np.sin(theta)], [np.sin(theta), np.cos(theta)]])
    return(drift*scale*rot)
    
#investigate at surf 10 for ccd for first mirror 

def no_lens_errors_matrix(d0, d1, d2, chiefx, chiefy, theta_rot, varx1, vary1):
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
     
     t_mirror = np.matrix([[1,0,0,0,0], 
                          [0,1,0,0,0],
                          [0,0,1,0,np.tan(2*varx1)],
                          [0,0,0,1,np.tan(2*vary1)],
                          [0,0,0,0,1]])
     drift0 = np.matrix([[1,0,d0,0,0],
                         [0,1,0,d0,0],
                         [0,0,1,0,0],
                         [0,0,0,1,0], 
                         [0,0,0,0,1]])
     tot_m = drift2*drift1*scaling*rot1*t_mirror
     return(tot_m)
def lens_no_errors_matrix(f, d0, d1, d2, chiefx, chiefy, theta_rot, varx1, vary1):
     chiefx, chiefy, theta_rot = np.deg2rad(chiefx), np.deg2rad(chiefy), np.deg2rad(theta_rot)
     varx1, vary1 = np.deg2rad(varx1),np.deg2rad(vary1) 
     drift0 = np.matrix([[1,0,d0,0,0],
                         [0,1,0,d0,0],
                         [0,0,1,0,0],
                         [0,0,0,1,0], 
                         [0,0,0,0,1]])
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

     tot_m = drift2*lens*drift1*scaling*rot1*t_mirror
     return(tot_m)
    
def lens_dec_matrix(f, d0, d1, d2, chiefx, chiefy, theta_rot, varx1, vary1, dx,dy):
     chiefx, chiefy, theta_rot = np.deg2rad(chiefx), np.deg2rad(chiefy), np.deg2rad(theta_rot)
     varx1, vary1 = np.deg2rad(varx1),np.deg2rad(vary1) 
     drift0 = np.matrix([[1,0,d0,0,0],
                         [0,1,0,d0,0],
                         [0,0,1,0,0],
                         [0,0,0,1,0], 
                         [0,0,0,0,1]])
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
    
     lens = np.matrix([[1,0,0,0,dx],
                       [0,1,0,0,dy],
                       [-1/f, 0,1,0,0],
                       [0,-1/f,0,1,0],
                       [0,0,0,0,1]])
     t_mirror = np.matrix([[1,0,0,0,0], 
                          [0,1,0,0,0],
                          [0,0,1,0,np.tan(2*varx1)],
                          [0,0,0,1,np.tan(2*vary1)],
                          [0,0,0,0,1]])

     tot_m = drift2*lens*drift1*scaling*rot1*t_mirror
     return(tot_m)
    
def align_m1(file):

    link = pyz.createLink()
    link.zLoadFile(file)

    #extract variations:
    ccd1_offsetx = link.zOperandValue('POPD', 26, 1, 0, 11)
    ccd1_offsety = link.zOperandValue('POPD', 26, 1, 0, 12)
    beam_vec = np.matrix([[ccd1_offsetx], [ccd1_offsety]])
    print("initial beam vector:")
    print(beam_vec)
    
    #var_vec
    inv_beamline = np.linalg.inv(one_mirror(45,0,400))
    vec = np.matrix([[0], [0], [0], [0], [1]])
    var_vec = np.matmul(inv_beamline, 0.5*beam_vec) 
    print("print initial variation vector:")
    print(np.rad2deg(var_vec))
    ##feed them into system 
    
    t_varx, t_vary = np.rad2deg(var_vec.item(0)),np.rad2deg(var_vec.item(1))
    
    no_decenter_sys = lens_dec_matrix(201.654, 200,200,200,45,0,90,t_varx,t_vary,0,0)*vec
    print(no_decenter_sys)
    ##feed variations
    link.zSetSurfaceParameter(5, 3, -float(t_varx)) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(5, 4, -float(t_vary))
    link.zSetSurfaceParameter(5, 5, 0)

    link.zSetSurfaceParameter(7, 3, float(t_varx)) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(7, 4, float(t_vary))
    link.zSetSurfaceParameter(7, 5, 0)
    link.zSaveFile(file)  
    print("second stage:")
    #extract variations:
    ccd1_offsetx = link.zOperandValue('POPD', 26, 1, 0, 11)
    ccd1_offsety = link.zOperandValue('POPD', 26, 1, 0, 12)
    beam_vec = np.matrix([[ccd1_offsetx], [ccd1_offsety]])
    print("initial beam vector:")
    print(beam_vec)
    
    #var_vec
    inv_beamline = np.linalg.inv(one_mirror(45,0,400))
    vec = np.matrix([[0], [0], [0], [0], [1]])
    var_vec = np.matmul(inv_beamline, 0.5*beam_vec) 
    print("print initial variation vector:")
    print(np.rad2deg(var_vec))
    ##feed them into system 
    
    t_varx, t_vary = np.rad2deg(var_vec.item(0)),np.rad2deg(var_vec.item(1))
    
    no_decenter_sys = lens_dec_matrix(201.654, 200,200,200,45,0,90,t_varx,t_vary,0,0)*vec
    print(no_decenter_sys)
    
    """
    link.zSetSurfaceParameter(5, 3, -float(t_varx)) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(5, 4, -float(t_vary))
    link.zSetSurfaceParameter(5, 5, 0)

    link.zSetSurfaceParameter(7, 3, float(t_varx)) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(7, 4, float(t_vary))
    link.zSetSurfaceParameter(7, 5, 0)
    link.zSaveFile(file)  
    
    vec = np.matrix([[0], [0], [0], [0], [1]])
    vec_nodec = lens_no_errors_matrix(201.654, 200, 200,200,45,0,90,-t_varx, -t_vary)
    no_lens_dec_vec = np.matmul(vec_nodec,vec)
    diff_x = no_lens_dec_vec[0] - beam_vec[0]
    diff_y = no_lens_dec_vec[1] - beam_vec[1]
    print("ray tracing expected xy positions (with lens but not decentered):")
    print(no_lens_dec_vec[0], no_lens_dec_vec[1])
    print("decentering first estimation:")
    print(diff_x, diff_y)
    
    link.zSetSurfaceParameter(17, 1, -float(diff_x)) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(20, 1, float(diff_x))
    link.zSetSurfaceParameter(17, 2, -float(diff_y)) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(20, 2, float(diff_y))
    link.zSaveFile(file)
    
    ccd1_offsetx = link.zOperandValue('POPD', 26, 1, 0, 11)
    ccd1_offsety = link.zOperandValue('POPD', 26, 1, 0, 12)
    beam_vec = np.matrix([[ccd1_offsetx], [ccd1_offsety]])
    print("adjusting with decentering and variations (first fix) beam vector:")
    print(beam_vec)

    status = "not done"
    
  
    #extract current variations 
    var_vec = np.matmul(inv_beamline, .5*beam_vec) 
    print("print initial variation vector:")
    print(np.rad2deg(var_vec))
    
    #feed projected dx dy into system with decentering 
    tvx, tvy = np.rad2deg(var_vec[0]),np.rad2deg(var_vec[1])
    lens_d_m = lens_dec_matrix(200,200,200,200,45,0,90,tvx,tvy,diff_x,diff_y)
    lens_d_vec = lens_d_m*vec
    print("projected lens d vec")
    print(lens_d_vec)
    corr_x = lens_d_vec[0] + diff_x
    corr_y = lens_d_vec[1] + diff_y

    ccd1_offsetx = link.zOperandValue('POPD', 26, 1, 0, 11)
    ccd1_offsety = link.zOperandValue('POPD', 26, 1, 0, 12)
    beam_vec = np.matrix([[ccd1_offsetx], [ccd1_offsety]])
    print("adjusting with decentering and variations (first fix) beam vector:")
    print(beam_vec)
    """
    pyz.closeLink()



print("==========")

algo_var(file, -.5, .7,4,3)
align_m1(file)