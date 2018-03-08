import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit

import pyzdde.zdde as pyz


def gaussian(x, const, mean, sigma):
    mean_factor = x - mean
    e_arg = np.exp(-np.divide(np.square(mean_factor), 2 * np.square(sigma)))
    return (const * e_arg)




def POP_Generator(ln, beam_size, window_size):
    setfile = ln.zGetFile().lower().replace('.zmx', '.CFG')
    GAUSS_WAIST, WAIST_X, WAIST_Y, beam_waist = 0, 1, 2, 1
    S_512 = 5
    grid_size = window_size
    cfgfile = ln.zSetPOPSettings('cross', setfile, 2, endSurf=2, field=1, wave=1, beamType=GAUSS_WAIST,
                             paramN=((WAIST_X, WAIST_Y), (beam_waist, beam_waist)), sampx=S_512, sampy=S_512,
                             widex=grid_size, widey=grid_size, tPow=1)
    tmp_irr, tmp = ln.zGetPOP(settingsFile=cfgfile, displayData=True)






file = r"C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs\aptest.zmx"

link = pyz.createLink()


link.zLoadFile(file)
link.ipzGetLDE()
#link.zInsertDummySurface(3)
#link.zInsertSurface(2)
#link.zInsertSurface(3)
#link.zSetGlass(3, 'MIRROR')
#link.zInsertDummySurface(5)



link.ipzGetLDE()

#link.zInsertCoordinateBreak(3,1, 1, 45, 0,0 )
#link.zInsertCoordinateBreak(5,1, 1, -45, 0,0 )

#link.ipzGetLDE()
#link.zSaveFile(file)

##### do POP
##1 mm, then 5mm

link.zSetWave(1, .800, 1)
print(link.zGetWave(1))
setfile = link.zGetFile().lower().replace('.zmx', '.CFG')
GAUSS_WAIST, WAIST_X, WAIST_Y, beam_waist = 0, 1, 2, 1
S_512 = 5
grid_size = 20
cfgfile = link.zSetPOPSettings('cross', setfile, 4, endSurf=4, field=1, wave=1, beamType=GAUSS_WAIST,
                             paramN=((WAIST_X, WAIST_Y), (beam_waist, beam_waist)), sampx=S_512, sampy=S_512,
                             widex=grid_size, widey=grid_size, tPow=1)

tmp_irr, tmp = link.zGetPOP(settingsFile=cfgfile, displayData=True)

waist_values =[]



### start propagating

#mirrors first

nondrifts_data = []

#no offset
link.zSetSurfaceParameter(surfNum=5, param=1, value=0)

link.zSetSurfaceParameter(surfNum=7,  param=1, value=0)


###################
"""
for i in nondrifts_data_loc:
    link.zModifyPOPSettings(cfgfile, i)
    irr_data, grid_data = link.zGetPOP(cfgfile, displayData=True)
    nondrifts_data_irr.append(irr_data)
    nondrifts_data_grid.append(grid_data)

x_pos_nondrifts = []

for i in nondrifts_data_irr:
    dx = i[-2] / 512
    tmp_x = [-i[-2] / 2 + dx * j for j in range(512)]
    x_pos_nondrifts.append(tmp_x)

nondrifts_data_waist = []
for i in range(len(nondrifts_data_grid)):
    popt, pcov = curve_fit(gaussian, x_pos_nondrifts[i],nondrifts_data_grid[i][256], maxfev=1800)
    nondrifts_data_waist.append(2 * np.abs(popt[2]))

print(nondrifts_data_waist)

"""

###################

def gaussian_extractor(pos_list):
    tmp_data = []
    tmp_grid =[]
    for i in pos_list:
        link.zModifyPOPSettings(cfgfile, endSurf=i)
        irr_data, grid_data = link.zGetPOP(cfgfile, displayData=True)
        tmp_data.append(irr_data)
        tmp_grid.append(grid_data)

    tmp_x = []
    for i in tmp_data:
        dx = i[-2] / 512
        tmpx = [-i[-2] / 2 + dx * j for j in range(512)]
        tmp_x.append(tmpx)

    tmp_waist =[]
    for i in range(len(tmp_grid)):
        popt, pcov = curve_fit(gaussian, tmp_x[i], tmp_grid[i][256], maxfev=1800)
        tmp_waist.append(2 * np.abs(popt[2]))
    return(tmp_waist)

####################
m1_m2_drift_loc = [10,12]
m2_end_drift_loc = [20,22]
nondrifts_data_loc = [4, 8,18]

waist_drifts_m1_m2 = gaussian_extractor(m1_m2_drift_loc)
#print(waist_drifts_m1_m2)
waist_drifts_m2_end = gaussian_extractor(m2_end_drift_loc)
#print(waist_drifts_m2_end)
waist_drifts_mirrors_start = gaussian_extractor(nondrifts_data_loc)
#print(waist_drifts_mirrors_start)
waists = []

waists.append(waist_drifts_mirrors_start[0])
waists.append(waist_drifts_mirrors_start[1])

pos=[0, 1000,2000,3000,4000,5000,6000]
for i in waist_drifts_m1_m2:
    waists.append(i)

waists.append(waist_drifts_mirrors_start[2])

for i in waist_drifts_m2_end:
    waists.append(i)

#print(waists)

plt.scatter(pos, waists, label = 'No Offset')
plt.plot(pos, waists, linestyle = ':')
plt.savefig('mirrortest.pdf')

##########################

#give offset to first mirror


link.zSetSurfaceParameter(surfNum=5, param=3, value=47)
link.zSetSurfaceParameter(surfNum=5, param=3, value=47)

#link.zSetSurfaceParameter(surfNum=7,  param=2, value=-2)
#link.zSetSurfaceParameter(surfNum=7,  param=2, value=-2)

link.ipzGetLDE()

link.zSaveFile(file)




#################

#propagate beam again with 2mm offset (only on first mirror
m1_m2_drift_loc = [10,12]
m2_end_drift_loc = [20,22]
nondrifts_data_loc = [4, 8,18]

waist_drifts_m1_m2_offset = gaussian_extractor(m1_m2_drift_loc)
#print(waist_drifts_m1_m2)
waist_drifts_m2_end_offset = gaussian_extractor(m2_end_drift_loc)
#print(waist_drifts_m2_end)
waist_drifts_mirrors_start_offset = gaussian_extractor(nondrifts_data_loc)
#print(waist_drifts_mirrors_start)

waists_offset = []

waists_offset.append(waist_drifts_mirrors_start_offset[0])
waists_offset.append(waist_drifts_mirrors_start_offset[1])


for i in waist_drifts_m1_m2_offset:
    waists_offset.append(i)

waists_offset.append(waist_drifts_mirrors_start_offset[2])

for i in waist_drifts_m2_end_offset:
    waists_offset.append(i)


plt.scatter(pos, waists_offset, label = '2mm Offset $M_1$')
plt.plot(pos, waists_offset, linestyle = '-.')
plt.legend(loc = 'lower right')
plt.savefig('mirrortestoffset.pdf')


