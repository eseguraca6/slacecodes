# -*- coding: utf-8 -*-
"""
Created on Mon Apr  9 15:40:33 2018

@author: pwfa-facet2
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit
#import pyzdde.arraytrace as at
import pyzdde.zdde as pyz

import random as rand

link = pyz.createLink()


file = r"C:\Users\pwfa-facet2\Desktop\slacecodes\centroid_test.zmx"

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




def matrix_var(angle_var, delta_var, file):
    link.zSetSurfaceParameter(4, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(6, 3, 0)
    link.zSetSurfaceParameter(4, 4, 0)
    link.zSetSurfaceParameter(6, 4, 0)
    
    delta = np.deg2rad(delta_var)    
    
    link.zSaveFile(file)    
    
    x_pos = []
    y_pos =[]
    
    link.zSetSurfaceParameter(4, 3, angle_var) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(6, 3, -angle_var)
    link.zSetSurfaceParameter(4, 4, 0)
    link.zSetSurfaceParameter(6, 4, 0)
    link.zSaveFile(file)  
    
    delta = np.deg2rad(delta_var)    
    
    t_ccdx = link.zOperandValue('POPD', 15, 1, 0, 11)
    t_ccdy = link.zOperandValue('POPD', 15, 1, 0, 12)
    #print(t_ccdx, t_ccdy)
    new_angle = angle_var+delta_var
    
    link.zSetSurfaceParameter(4, 3, new_angle) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(6, 3, -new_angle)
    link.zSetSurfaceParameter(4, 4, 0)
    link.zSetSurfaceParameter(6, 4, 0)
    link.zSaveFile(file)  
    
    delta_ccdx = link.zOperandValue('POPD', 15, 1, 0, 11)
    delta_ccdy= link.zOperandValue('POPD', 15, 1, 0, 12)
    print(delta_ccdx, delta_ccdy)
    f_21 = np.divide(delta_ccdy-t_ccdy, delta)
    
    print('F_{21}:')
    print(f_21)
    ######
    
    link.zSetSurfaceParameter(4, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(6, 3, 0)
    link.zSetSurfaceParameter(4, 4, angle_var)
    link.zSetSurfaceParameter(6, 4, -angle_var)
    link.zSaveFile(file)  
    
    alphay_ccdy = link.zOperandValue('POPD', 15, 1, 0, 11)
    alphay_ccdx = link.zOperandValue('POPD', 15, 1, 0, 12)
    
    #nt(alphay_ccdx, alphay_ccdy)
    
    link.zSetSurfaceParameter(4, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(6, 3, 0)
    link.zSetSurfaceParameter(4, 4, new_angle)
    link.zSetSurfaceParameter(6, 4, -new_angle)
    link.zSaveFile(file)  
    
    d_alphay_ccdy = link.zOperandValue('POPD', 15, 1, 0, 11)
    d_alphay_ccdx = link.zOperandValue('POPD', 15, 1, 0, 12)
    
    
    
    
    f_12 = np.divide(d_alphay_ccdx - alphay_ccdx, delta)
    f_22 = np.divide(d_alphay_ccdy - alphay_ccdy, delta)
    
    print('F_{12}:')
    print(f_12)
    print('F_{22}:')
    print(f_22)
    np.savetxt('alph', list(zip(angles_xtilt, beam_x, beam_y)))


matrix_var(1, 0.01,file)
"""

print(t_ccdx,t_ccdy)
tx = link.zGetTrace(waveNum=1, mode=0,surf=24,hx=0,hy=0,px=0,py=0)
print(tx)
"""
"""
link.zSetSurfaceParameter(4, 3, .5)
link.zSetSurfaceParameter(6, 3, .5)
link.zSaveFile(file)
t_ccdx = link.zOperandValue('POPD', 24, 1, 0, 11)
t_ccdy = link.zOperandValue('POPD', 24, 1, 0, 12)

print(t_ccdx, t_ccdy)
    
tx = link.zGetTrace(waveNum=1, mode=0,surf=24,hx=0,hy=0,px=0,py=0)
ttx = link.zGetTraceDirect(waveNum=1, mode=0, startSurf=2, stopSurf=13, x=0,y=0,z=0, l=0,m=0,n=0)
print(tx)
print(ttx)
pyz.closeLink()

error, vig, x,y,x, 
"""
"""
angles_xtilt = np.arange(-1, 1.1, 0.1)
#print(angles_xtilt)
for i in angles_xtilt:
    link.zSetSurfaceParameter(4, 4, i)
    link.zSetSurfaceParameter(6, 4, -i)
    #print(i)
    link.zSaveFile(file)
    t_ccdx = link.zOperandValue('POPD', 15, 1, 0, 11)
    t_ccdy = link.zOperandValue('POPD', 15, 1, 0, 12)
    
    #print(t_ccdx, t_ccdy)
    beam_x.append(t_ccdx)
    beam_y.append(t_ccdy)
#ccd1 = link.zGetTrace(waveNum=1, mode=0, surf=24,hx=0,hy=0,px=0,py=0)
#print(ccd1)
#t_ccdx = link.zOperandValue('POPD', 17, 1, 0, 12)
#print(t_ccdx)
link.zSetPolState(1, 0, 0, 0,0)
link.zSaveFile(file)
print(link.zGetPolState())
"""
"""
a= plt.figure(figsize=(8,8))
a0 = a.add_subplot(121)
a0.scatter(angles_xtilt,beam_x, marker ='^', color = 'orange')
#a0.plot(angles_xtilt, , color = 'red', linestyle = ":")
a1 = a.add_subplot(122)
a1.scatter(angles_xtilt, beam_y,marker='D')
#a1.plot(angles_xtilt, th, color = 'green', linestyle = ":")
a0.set_xlabel('Degrees alphay')
a0.set_ylabel('Beam Position Y')
a1.set_xlabel('Degrees alphay')
a1.set_ylabel('Beam Position X')
link.zSetPolState(0, 1, 0, 0,0)
link.zSaveFile(file)
print(link.zGetPolState())
link.zModifyPOPSettings(cfgfile, ignPol=0)
beam_xp=[]
beam_yp=[]
"""
"""
for i in angles_xtilt:
    link.zSetSurfaceParameter(4, 4, i)
    link.zSetSurfaceParameter(6, 4, -i)
    print(i)
    link.zSaveFile(file)
    t_ccdxp = link.zOperandValue('POPD', 15, 1, 0, 11)
    t_ccdyp = link.zOperandValue('POPD', 15, 1, 0, 12)
    
    #print(t_ccdxp, t_ccdyp)
    beam_xp.append(t_ccdxp)
    beam_yp.append(t_ccdyp)

b= plt.figure(figsize=(8,8))
b0 = b.add_subplot(121)
b0.scatter(angles_xtilt,beam_xp, marker ='^', color = 'orange')
#a0.plot(angles_xtilt, , color = 'red', linestyle = ":")
b1 = b.add_subplot(122)
b1.scatter(angles_xtilt, beam_yp,marker='D')
#a1.plot(angles_xtilt, th, color = 'green', linestyle = ":")
b0.set_xlabel('Degrees alphay')
b0.set_ylabel('Beam Position X')
b1.set_xlabel('Degrees alphay')
b1.set_ylabel('Beam Position Y')
"""
pyz.closeLink()

#np.savetxt('alphayvaralphax1.csv', list(zip(angles_xtilt, beam_x, beam_y)))