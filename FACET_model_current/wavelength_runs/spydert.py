import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit

import pyzdde.zdde as pyz


def gaussian(x, const, mean, sigma):
    mean_factor = x - mean
    e_arg = np.exp(-np.divide(np.square(mean_factor), 2 * np.square(sigma)))
    return (const * e_arg)

file = r"C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs\aptest.zmx"

link = pyz.createLink()
link.zLoadFile(file)
link.ipzGetLDE()


#link.zSetSurfaceParameter(15, 1, 3)
#link.zSetSurfaceParameter(17, 1, 3)
#link.zSetSurfaceParameter(15, 6, 1)
#link.zSetSurfaceParameter(17, 6, 1)



#link.zInsertCoordinateBreak()


def waist_extractor(pos_list):
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

def beam_configurations(wavelength, bwaist, x_offset, y_offset, gsize):
    wv = wavelength/1000
    link.zSetWave(1, wv, 1)
    setfile = link.zGetFile().lower().replace('.zmx', '.CFG')
    GAUSS_WAIST, WAIST_X, WAIST_Y, beam_waist = 0, 1, 2, bwaist
    DECENTER_X, DECENTER_Y = x_offset,y_offset
    S_512 = 5
    grid_size = gsize
    cfgfile = link.zSetPOPSettings('irr', setfile, 4, endSurf=4, field=1, wave=1, beamType=GAUSS_WAIST,
                             paramN=((WAIST_X, WAIST_Y), (beam_waist, beam_waist), (DECENTER_X, DECENTER_Y)), sampx=S_512, sampy=S_512,
                             widex=grid_size, widey=grid_size, tPow=1)



waist_values =[]
link.zSetSurfaceParameter(5, 1, 0)
link.zSetSurfaceParameter(7, 1, 0)
#beam_configurations(800, 1, 0, 0, 20)
link.zSetWave(1, .800, 1)
print(link.zGetWave(1))
setfile = link.zGetFile().lower().replace('.zmx', '.CFG')
GAUSS_WAIST, WAIST_X, WAIST_Y, beam_waist = 0, 1, 2, 1
DECENTER_X, DECENTER_Y = 0, 0
S_512 = 5
grid_size = 6
cfgfile = link.zSetPOPSettings('irr', setfile, 4, endSurf=4, field=1, wave=1, beamType=GAUSS_WAIST,
                             paramN=((WAIST_X, WAIST_Y), (beam_waist, beam_waist), (DECENTER_X, DECENTER_Y)), sampx=S_512, sampy=S_512,
                             widex=grid_size, widey=grid_size, tPow=1)

tmp_irr, tmp = link.zGetPOP(settingsFile=cfgfile, displayData=True)

#link.zSetSurfaceData(5, code=link.SDAT_THICK, value = 2)

#link.zSetSurfaceData(7, code=link.SDAT_THICK, value = -2)

link.ipzGetLDE()

optical_checkpoints = [4,8,10,
                       12,18,22,
                       24,26,28]
waist = waist_extractor(optical_checkpoints)
pos = [0, 1000, 2000, 3000, 4000, 6000, 7000, 8000, 9000]
plt.figure(figsize=(10,10))
plt.scatter(pos, waist, label='(x_off = 0mm)')
plt.plot(pos, waist, linestyle = ':')
link.ipzGetLDE()



###########################################

link.zSetSurfaceParameter(5, 1, 30)
link.zSetSurfaceParameter(7, 1, 30)

setfile = link.zGetFile().lower().replace('.zmx', '.CFG')
GAUSS_WAIST, WAIST_X, WAIST_Y, beam_waist = 0, 1, 2, 1
DECENTER_X, DECENTER_Y = 0, 0
S_512 = 5
grid_size = 6
link.zModifyPOPSettings(cfgfile, paramN= ((WAIST_X, WAIST_Y), (beam_waist, beam_waist), (DECENTER_X, DECENTER_Y ) ))


waist_2020 = waist_extractor(optical_checkpoints)

plt.scatter(pos, waist_2020, marker = 's', s= 100, label='(x_off = 30mm)')
#plt.plot(pos, waist_2020, linestyle = '--')
plt.xlabel('Beam Position (mm)')
plt.ylabel('Beam Size(mm)')
plt.title('Beam in Two-Mirror System With X-offset (0mm,20mm,30mm)')

plt.tight_layout()

###########################

link.zSetSurfaceParameter(5, 1, 60)
link.zSetSurfaceParameter(7, 1, 60)

setfile = link.zGetFile().lower().replace('.zmx', '.CFG')
GAUSS_WAIST, WAIST_X, WAIST_Y, beam_waist = 0, 1, 2, 1
DECENTER_X, DECENTER_Y = 0, 0
S_512 = 5
grid_size = 6
link.zModifyPOPSettings(cfgfile, paramN= ((WAIST_X, WAIST_Y), (beam_waist, beam_waist), (DECENTER_X, DECENTER_Y ) ))


waist_angleoff_nosourceoff = waist_extractor(optical_checkpoints)

plt.scatter(pos, waist_angleoff_nosourceoff, marker = '^',  label='(x_off = 60mm)')
#plt.plot(pos, waist_angleoff_nosourceoff, linestyle = '-.')

###################################


link.zSetSurfaceParameter(5, 1, -30)
link.zSetSurfaceParameter(7, 1, -30)

setfile = link.zGetFile().lower().replace('.zmx', '.CFG')
GAUSS_WAIST, WAIST_X, WAIST_Y, beam_waist = 0, 1, 2, 1
DECENTER_X, DECENTER_Y = 0, 0
S_512 = 5
grid_size = 6
link.zModifyPOPSettings(cfgfile, paramN= ((WAIST_X, WAIST_Y), (beam_waist, beam_waist), (DECENTER_X, DECENTER_Y ) ))


waist_negoffset30 = waist_extractor(optical_checkpoints)

plt.scatter(pos, waist_negoffset30, marker = '<',  label='(x_off = -30mm)')
plt.plot(pos, waist_negoffset30, linestyle = '-.')


#############################

link.zSetSurfaceParameter(5, 1, -60)
link.zSetSurfaceParameter(7, 1, -60)

setfile = link.zGetFile().lower().replace('.zmx', '.CFG')
GAUSS_WAIST, WAIST_X, WAIST_Y, beam_waist = 0, 1, 2, 1
DECENTER_X, DECENTER_Y = 0, 0
S_512 = 5
grid_size = 6
link.zModifyPOPSettings(cfgfile, paramN= ((WAIST_X, WAIST_Y), (beam_waist, beam_waist), (DECENTER_X, DECENTER_Y ) ))


waist_negoffset60 = waist_extractor(optical_checkpoints)

plt.scatter(pos, waist_negoffset60, marker = 'P',  label='(x_off = -60mm)')
plt.plot(pos, waist_negoffset60, linestyle = '-.')





plt.legend(loc = 'lower right')
plt.tight_layout()
plt.savefig('demo_offsets.pdf')

link.zSaveFile(file)


link.close()

#for i in range(len(waist)):
#    print(waist[i], waist_2020[i], waist_angleoff_nosourceoff[i])
