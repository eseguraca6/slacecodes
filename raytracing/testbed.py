import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit
#import pyzdde.arraytrace as at
import pyzdde.zdde as pyz

import random as rand


file = r'C:\Users\pwfa-facet2\Desktop\slacecodes\raytracing\andyslens.zmx'


link = pyz.createLink()
 link.zLoadFile(file)
link.zSetWave(1,.800, 1)
setfile = link.zGetFile().lower().replace('.zmx', '.CFG')
S_512 = 5
grid_size = 10
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
    
    
    