# -*- coding: utf-8 -*-3
"""
Created on Fri Mar 30 14:53:54 2018

@author: pwfa-facet2
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit
#import pyzdde.arraytrace as at
import pyzdde.zdde as pyz

import random as rand

def ccd_system(start_angle, end_angle, chief_angle_x, chief_angle_y, file, exp_run):
    link = pyz.createLink()
    link.zLoadFile(file)
    
    setfile = link.zGetFile().lower().replace('.zmx', '.CFG')
    S_512 = 5
    grid_size = 20
    GAUSS_WAIST, WAIST_X, WAIST_Y, DECENTER_X, DECENTER_Y = 0, 1, 2, 3, 4
    beam_waist, x_off, y_off = 5, 0, 0
    cfgfile = link.zSetPOPSettings('irr', setfile, startSurf=2, endSurf=2, field=1, wave=1, beamType=GAUSS_WAIST,
                             paramN=( (WAIST_X, WAIST_Y, DECENTER_X, DECENTER_Y), (beam_waist, beam_waist,
                                     x_off, y_off) ), sampx=S_512, sampy=S_512, widex=grid_size, widey=grid_size, tPow=1, auto=0)
    link.zModifyPOPSettings(setfile, endSurf=27)
    link.zModifyPOPSettings(setfile, paramN=( (1, 2, 3, 4), (5, 5, 0, 0) ))
    link.zModifyPOPSettings(setfile, widex=grid_size)
    link.zModifyPOPSettings(setfile, widey=grid_size) 
    link.zSaveFile(file)
    #no offset to chief ray
    link.zSetSurfaceParameter(3, 3, chief_angle_x)
    link.zSetSurfaceParameter(7, 3, chief_angle_x)
    link.zSetSurfaceParameter(3, 4, chief_angle_y)
    link.zSetSurfaceParameter(7, 4, chief_angle_y)
    
    
    link.zSetSurfaceParameter(4, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(6, 3, 0)
    link.zSetSurfaceParameter(4, 4, 0)
    link.zSetSurfaceParameter(6, 4, 0)
    
    link.zSetSurfaceParameter(18, 3, 0)
    link.zSetSurfaceParameter(20, 3, 0)
    link.zSetSurfaceParameter(18, 4, 0)
    link.zSetSurfaceParameter(20, 4, 0)
    
    link.zSaveFile(file)
    non_var_bx = []
    non_var_by = []
    
    for i in range(exp_run+1):
        nooffset_t_ccdx = link.zOperandValue('POPD', 26, 1, 0, 11)
        nooffset_t_ccdy = link.zOperandValue('POPD', 26, 1, 0, 12)
        non_var_bx.append(nooffset_t_ccdx)
        non_var_by.append(nooffset_t_ccdy)
    
    alphax_arr =[]
    alphay_arr= []
    alpha2x_arr = []
    alpha2y_arr = []
    beamx_offset =[]
    beamy_offset = []
    ccd2_beamx_offset =[]
    ccd2_beamy_offset = []
    exp_run_arr = []
    for i in range(exp_run+1):
        alpha_1x = np.random.uniform(start_angle, end_angle)
        alpha_1y = np.random.uniform(start_angle, end_angle)
        #alpha_2x = np.random.uniform(start_angle, end_angle)
        #alpha_2y = np.random.uniform(start_angle, end_angle) 
        alphax_arr.append(alpha_1x)
        alphay_arr.append(alpha_1y)
        #alpha2x_arr.append(alpha_2x)
        #alpha2y_arr.append(alpha_2y)
        exp_run_arr.append(i)
        #make offsets in zemax system 
        link.zSetSurfaceParameter(4, 3, alpha_1x) #3 = x-tilt, 4=y-tilt
        link.zSetSurfaceParameter(6, 3, -alpha_1x)
        link.zSetSurfaceParameter(4, 4, alpha_1y)
        link.zSetSurfaceParameter(6, 4, -alpha_1y)
        
        #link.zSetSurfaceParameter(18, 3, alpha_2x) #3 = x-tilt, 4=y-tilt
        #link.zSetSurfaceParameter(20, 3, -alpha_2x)
        #link.zSetSurfaceParameter(18, 4, alpha_2y)
        #link.zSetSurfaceParameter(20, 4, -alpha_2y)
        
        
        
        link.zSaveFile(file)
        #alpha_2x = np.random.uniform(start_angle, end_angle)
        #alpha_2y = np.random.uniform(start_angle, end_angle)
    
        #add offsets
        
        ccd1_offsetx = link.zOperandValue('POPD', 26, 1, 0, 11)
        ccd1_offsety = link.zOperandValue('POPD', 26, 1, 0, 12)
        ccd2_x = link.zOperandValue('POPD', 28, 1, 0, 11)
        ccd2_y = link.zOperandValue('POPD', 28, 1, 0, 12)
        beamx_offset.append(ccd1_offsetx)
        beamy_offset.append(ccd1_offsety)
        ccd2_beamx_offset.append(ccd2_x)
        ccd2_beamy_offset.append(ccd2_y)

    pyz.closeLink()
    np.savetxt('algotest_crosstalk_onlyerrorm1arrayneg1pos1' + str(chief_angle_x)+ '_chief_angley_'+ 
               str(chief_angle_y) +'_start_angle'+str(start_angle)+'_end_angle_'+str(end_angle)+'_'+str(exp_run)+ '.csv', list(zip(exp_run_arr, alphax_arr, alphay_arr, beamx_offset, beamy_offset, ccd2_beamx_offset, ccd2_beamy_offset)))
    return(exp_run_arr, alphax_arr, alphay_arr, beamx_offset, beamy_offset, ccd2_beamx_offset, ccd2_beamy_offset)




file = r"C:\Users\pwfa-facet2\Desktop\slacecodes\centroid_test.zmx"


data = ccd_system(-5,5, 45, 0, file, 20)
"""
print('ccd1 pos and angles:')
print(data[2], data[3], data[4], data[5])
print('ccd2 pos and angles:')
print(data[6], data[7], data[8], data[9])

f = plt.figure(figsize=(15,8))
f0 = f.add_subplot(121)
f0.scatter(data[0], data[1], marker = 'd', color = 'green', label = 'No Offset', s=100)
f0.scatter(data[2], data[3], marker = 'd', color = 'blue', label = 'Variations: ('+ '%.3g'%data[4] + ', ' + '%.3g'%data[5] +')', s=100)
f0.scatter(data[6], data[7], marker = 'd', color = 'red', label= 'CCD-2' +  'Variations: ('+ '%.3g'%data[8] + ', ' + '%.3g'%data[9] +')', s=200)



#f0.scatter(data[8], data[9], marker = 'd', color = 'orange', label = 'CCD-2 Centroid Position ('+ '%.3g'%data[10] + ' ' + '%.3g'%data[11] +')', s=100)
f0.legend(loc='best', fontsize=12)
f0.set_xlabel('Beam Position (X) (mm)', fontsize=20)
f0.set_ylabel('Beam Position (Y) (mm)', fontsize=20)
f0.set_title('Beam in Space', fontsize=20)




f1 = f.add_subplot(122)
f1.scatter(data[0], data[1], marker = 'd', color = 'green', label = 'No Offset', s=120)
f1.scatter(data[6], data[7], marker = '^', color = 'blue', label = 'Variations: ('+ '%.3g'%data[8] + ', ' + '%.3g'%data[9] +')', s=120)
#f1.scatter(data[14], data[15], marker = '^', color = 'red', label = 'CCD-2 Centroid Position ('+ '%.3g'%data[16] + ' ' + '%.3g'%data[17] +')',s=120)
f1.set_xlabel('Beam Position (X) (mm)', fontsize=20)
f1.set_ylabel('Beam Position (Y) (mm)', fontsize=20)
f1.legend(loc ='best', fontsize=12)
f1.set_title('CCD-2', fontsize=20)

f1.tick_params(axis = 'both', labelsize=15)
f0.tick_params(axis = 'both', labelsize=15)

f.tight_layout()
f.suptitle('Effects of Angle Variations on Two-Mirror System on Beam Centroid', fontsize=30)
f.subplots_adjust(top=0.8)
f.savefig('updated screens.pdf')
"""