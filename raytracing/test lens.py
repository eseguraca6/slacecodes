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

file = r"C:\Users\pwfa-facet2\Desktop\slacecodes\raytracing\m-l-m.zmx"
def config_simulation(file, chief_angle1_x,chief_angle1_y, chief_angle1_z,
                      chief_angle2_x,chief_angle2_y, chief_angle2_z):
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
    
    link.zSetSurfaceParameter(24,3, chief_angle2_x)
    link.zSetSurfaceParameter(24,4, chief_angle2_y)
    link.zSetSurfaceParameter(24,5, chief_angle2_z)

    link.zSetSurfaceParameter(30,3, chief_angle2_x)
    link.zSetSurfaceParameter(30,4, chief_angle2_y)
    link.zSetSurfaceParameter(30,5, chief_angle2_z)

#fix lens decentering too
    link.zSetSurfaceParameter(17,1, 0)#decenter x,y : 1,2
    link.zSetSurfaceParameter(17,2, 0)
    #link.zSetSurfaceParameter(3,5, chief_angle1_z)

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
######mirror 2
    link.zSetSurfaceParameter(25, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(25, 4, 0)
    link.zSetSurfaceParameter(25, 5, 0)

    link.zSetSurfaceParameter(29, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(29, 4, 0)
    link.zSetSurfaceParameter(29, 5, 0)

#####
    link.zSetSurfaceParameter(26, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(26 ,4, 0)
    link.zSetSurfaceParameter(26, 5, 0)

    link.zSetSurfaceParameter(27, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(27, 4, 0)
    link.zSetSurfaceParameter(27, 5, 0)

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
    
    ccd1xarr=[]
    ccd1yarr=[]
    
    ccd2xarr=[]
    ccd2yarr=[]
    #fix lens decentering too
    link.zSetSurfaceParameter(17,1,2)#decenter x,y : 1,2
    link.zSetSurfaceParameter(17,2,-2)
    #link.zSetSurfaceParameter(3,5, chief_angle1_z)

#fix var/pos empty 
    link.zSaveFile(file)
    for i in deg_range:
        link.zSetSurfaceParameter(3, 3, i) #3 = x-tilt, 4=y-tilt
        link.zSetSurfaceParameter(3, 4, i)
        link.zSetSurfaceParameter(3, 5, 0)

        link.zSetSurfaceParameter(7, 3, -i) #3 = x-tilt, 4=y-tilt
        link.zSetSurfaceParameter(7, 4, -i)
        link.zSetSurfaceParameter(7, 5, 0)
    
        link.zSetSurfaceParameter(25, 3, i) #3 = x-tilt, 4=y-tilt
        link.zSetSurfaceParameter(25, 4, i)
        link.zSetSurfaceParameter(25, 5, 0)

        link.zSetSurfaceParameter(29, 3, -i) #3 = x-tilt, 4=y-tilt
        link.zSetSurfaceParameter(29, 4, -i)
        link.zSetSurfaceParameter(29, 5, 0)
        link.zSaveFile(file)
        #get offsets 
        t_ccdx = link.zOperandValue('POPD', 22, 1, 0, 11)
        t_ccdy = link.zOperandValue('POPD', 22, 1, 0, 12)
    
        ccd1_offsetx = link.zOperandValue('POPD', 32, 1, 0, 11)
        ccd1_offsety = link.zOperandValue('POPD', 32, 1, 0, 12)
        
        ccd2_x = link.zOperandValue('POPD', 34, 1, 0, 11)
        ccd2_y = link.zOperandValue('POPD', 34, 1, 0, 12)
        
        beforem1_x.append(t_ccdx)
        beforem1_y.append(t_ccdy)
        ccd1xarr.append(ccd1_offsetx)
        ccd1yarr.append(ccd1_offsety)
        ccd2xarr.append(ccd2_x)
        ccd2yarr.append(ccd2_y)
    pyz.closeLink()
    np.savetxt(str(r"C:\Users\pwfa-facet2\Desktop\slacecodes\raytracing\\") + "m1m2l1decenteringby2mm-"+str(low_var)+"-"+str(high_var)+"-"+str(delta)+'.csv', list(zip(deg_range, beforem1_x, beforem1_y, ccd1xarr, ccd1yarr,ccd2xarr,ccd2yarr)))
    print("done")
    #return(beforem1_x, beforem1_y, ccd1xarr, ccd1yarr,ccd2_x,ccd2_y)
    
config_simulation(file, 45,0,0,0,45,0)
standard_variation(-2,2,0.1)