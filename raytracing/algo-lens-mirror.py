# -*- coding: utf-8 -*-
"""
Created on Mon Jul  9 11:06:43 2018

@author: pwfa-facet2
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit
#import pyzdde.arraytrace as at
import pyzdde.zdde as pyz

import random as rand

def fm_matrix(d, c_x, c_y, rot_angle):
    c_x, c_y, rot_angle = np.deg2rad(c_x), np.deg2rad(c_y), np.deg2rad(rot_angle)
    drift = np.matrix([[d,0], [0,d]])
    scaling = np.matrix([[2*np.cos(c_x), 0], [0,2*np.cos(c_y)]])
    rot = np.matrix([[np.cos(rot_angle), -np.sin(rot_angle)], [np.sin(rot_angle), np.cos(rot_angle)]])
    return(drift*scaling*rot)
    
def fl_matrix(d1,d2, c_x, c_y, rot_angle, f):
    c_x, c_y, rot_angle = np.deg2rad(c_x), np.deg2rad(c_y), np.deg2rad(rot_angle)
    drift1 = np.matrix([[d1,0], [0,d1]])
    drift2 = np.matrix([[d2,0], [0,d2]])
    scaling = np.matrix([[2*np.cos(c_x), 0], [0,2*np.cos(c_y)]])
    rot = np.matrix([[np.cos(rot_angle), -np.sin(rot_angle)], [np.sin(rot_angle), np.cos(rot_angle)]])
    lens = np.matrix([ [-1/f, 0], [0, -1/f] ])
    return(drift1*lens*drift2*scaling*rot)
    
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
def fix_mis(file):
    mirror_bl = fm_matrix(400, 45, 0, 90)
    lens_bl = fl_matrix(200, 200, 45,0, 900, 200)
    
    full_bl = mirror_bl + lens_bl
    var_pred = np.linalg.inv(full_bl);
    
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
    ccd1_offsetx = link.zOperandValue('POPD', 26, 1, 0, 11)
    ccd1_offsety = link.zOperandValue('POPD', 26, 1, 0, 12)
    print("current beam vector")
    ccd1x_arr.append(ccd1_offsetx)
    ccd1y_arr.append(ccd1_offsety)
    beam_vec = np.matrix([ [ccd1_offsetx], [ccd1_offsety] ])
    
    #expected result from raytracing 

    
    variations_vec = (np.matmul(var_pred,beam_vec))
    print(np.rad2deg(variations_vec))
    
    varx, vary =variations_vec.item(0), variations_vec.item(1)
    theory_beamline = lens_no_errors_matrix(200,200,200,45,0,90,varx,vary)
    long_vec = np.matrix([ [0], [0],[0], [0], [1] ])
    expected_beam = np.matmul(theory_beamline, long_vec)
    print("expected beamline (no decenter):")
    print(expected_beam)
    print("diff with ccd:")
    diffx = -beam_vec.item(0) + expected_beam.item(0)
    diffy = -beam_vec.item(1) + expected_beam.item(1)
    print(diffx, diffy)
    
    
    
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
    print('variations input:')
    print(alpha1_x,alpha1_y)
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

def decentering(file, x_off, y_off):
    link = pyz.createLink()
    link.zLoadFile(file)
    link.zSetSurfaceParameter(16,1, x_off)#decenter x,y : 1,2
    link.zSetSurfaceParameter(21,1, -x_off)
    link.zSetSurfaceParameter(16,2, y_off)#decenter x,y : 1,2
    link.zSetSurfaceParameter(21,2, -y_off)
    link.zSaveFile(file)
    pyz.closeLink()

config_simulation(file, 45, 0, 0)
algo_var(file, .5, .7)
decentering(file, 3, 4)
fix_mis(file)
