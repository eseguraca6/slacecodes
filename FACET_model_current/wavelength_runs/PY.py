import pyzdde.zdde as pyz
import os
import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit



##########################


def set_POP(zemax_link, data_type, grid_size, beam_waist, start_surface, end_surface):

    setfile = zemax_link.zGetFile().lower().replace('.zmx','.CFG')
    datatype = 1 if data == 'phase' else 0

    GAUSS_WAIST, WAIST_X, WAIST_Y = 0, 1, 2

    S_512 = 5 #sample size = 512 points (1024 x 1024 = 6x6)
    for i in range(start_surface, end_surface+1):
        #cfgfile = zemax_link.zSetPOPSettings(data_type, setfile, start_surface, endSurf=i, field=1, wave=1, beamType=GAUSS_WAIST, paramN=((WAIST_X, WAIST_Y), (beam_waist, beam_waist)), sampx=S_512, sampy=S_512, widex=grid_size, widey=grid_size)
        print(i)

def gaussian(x,const, mean,sigma):
    mean_factor = x - mean
    e_arg = np.exp(-np.divide( np.square(mean_factor), 2*np.square(sigma)))
    return(const*e_arg )


#############################



ln = pyz.createLink()

file = r'C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs\test.zmx'





ln.zLoadFile(file)
ln.ipzGetLDE()
ln.zSetWave(1, .800, 1)
setfile = ln.zGetFile().lower().replace('.zmx','.CFG')
GAUSS_WAIST, WAIST_X, WAIST_Y, beam_waist = 0, 1, 2, 1
S_512 = 5
grid_size = 15
cfgfile =ln.zSetPOPSettings('irr', setfile, 2, endSurf=2, field=1, wave=1, beamType=GAUSS_WAIST, paramN=((WAIST_X, WAIST_Y), (beam_waist, beam_waist)), sampx=S_512, sampy=S_512, widex=grid_size, widey=grid_size, tPow=1)

tmp_irr, tmp = ln.zGetPOP(settingsFile= cfgfile, displayData=True)

#ln.zSaveFile()
irr_data = []
irr_grid_data = []

for i in range(6,13,2):
    #print(i)
    ln.zModifyPOPSettings(cfgfile, endSurf=i)
    irr_curr_surf , irr_curr_griddat = ln.zGetPOP(settingsFile=cfgfile, displayData= True)
    #print(irr_curr_surf)
    irr_data.append((irr_curr_surf))
    irr_grid_data.append((irr_curr_griddat))
    #print(irr_curr_surf[-2])
    #print(irr_curr_griddat[512])

    ln.zGetTextFile(r'C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs\\' +str(i)+ '.csv', 'Pop', cfgfile)#POP(settingsFile=cfgfile, displayData= True).zSaveFile(str(i)+'.csv')
    #ln.zSaveFile(r'C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs'+str(i)+'.csv')




fig = plt.figure(figsize=(10,10))
ax = fig.add_subplot(111)



#dx = np.divide(irr_data[0][-2],512)

x_arr = []

for i in irr_data:
    #print(i[-2])
    dx = ((i[-2]/512))
    #generate the tmp x
    tmp_x = [-i[-2]/2 + dx*j for j in range(512)]
    x_arr.append(tmp_x)


#ax.plot(x_arr[0], irr_grid_data[0][256])

popt, pcov = curve_fit(gaussian, x_arr[1], irr_grid_data[1][256], maxfev=1800)

print(2*popt[2])

#fig.savefig('test.pdf')



"""


print(irr_sur1)
print(ln.zGetWaveTuple())
print(ln.zGetWave(1))

print(ln.zGetWaveTuple())


"""

