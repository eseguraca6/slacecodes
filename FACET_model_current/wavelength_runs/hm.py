import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit

import pyzdde.zdde as pyz

##########################


""""

def set_POP(zemax_link, data_type, grid_size, beam_waist, start_surface, end_surface):

    setfile = zemax_link.zGetFile().lower().replace('.zmx','.CFG')
    datatype = 1 if data_type == 'phase' else 0

    GAUSS_WAIST, WAIST_X, WAIST_Y = 0, 1, 2

    S_512 = 5 #sample size = 512 points (1024 x 1024 = 6x6)
    for i in range(start_surface, end_surface+1):
        #cfgfile = zemax_link.zSetPOPSettings(data_type, setfile, start_surface, endSurf=i, field=1, wave=1, beamType=GAUSS_WAIST, paramN=((WAIST_X, WAIST_Y), (beam_waist, beam_waist)), sampx=S_512, sampy=S_512, widex=grid_size, widey=grid_size)
        print(i)



"""


def gaussian(x, const, mean, sigma):
    mean_factor = x - mean
    e_arg = np.exp(-np.divide(np.square(mean_factor), 2 * np.square(sigma)))
    return (const * e_arg)


#############################


ln = pyz.createLink()

file = r'C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs\transport.zmx'

ln.zLoadFile(file)

ln.ipzGetLDE()

# ln.ipzGetLDE()
ln.zSetWave(1, .800, 1)
print(ln.zGetWave(1))
setfile = ln.zGetFile().lower().replace('.zmx', '.CFG')
GAUSS_WAIST, WAIST_X, WAIST_Y, beam_waist = 0, 1, 2, 1
S_512 = 5
grid_size = 15
cfgfile = ln.zSetPOPSettings('cross', setfile, 2, endSurf=2, field=1, wave=1, beamType=GAUSS_WAIST,
                             paramN=((WAIST_X, WAIST_Y), (beam_waist, beam_waist)), sampx=S_512, sampy=S_512,
                             widex=grid_size, widey=grid_size, tPow=1)

tmp_irr, tmp = ln.zGetPOP(settingsFile=cfgfile, displayData=True)

pos_thickness = []

print(tmp_irr)
irr_data = []
irr_grid_data = []

irr_data_l1_m2 = []
irr_data_l2_m3 = []

irr_data_m3_m4 = []
irr_data_m4_l3 = []

irr_data_m5_m6 = []
irr_data_l4_comp = []

irr_grid_l1_m2 = []
irr_grid_l2_m3 = []

irr_grid_m3_m4 = []
irr_grid_m4_l3 = []

irr_grid_m5_m6 = []
irr_grid_l4_comp = []

for i in range(13, 20, 2):
    ln.zModifyPOPSettings(cfgfile, endSurf=i)
    tmp_curr_irr_surf, tmp_curr_griddat = ln.zGetPOP(settingsFile=cfgfile, displayData=True)
    irr_data_l1_m2.append(tmp_curr_irr_surf)
    irr_grid_l1_m2.append(tmp_curr_griddat)


for i in range(30, 37, 2):
    ln.zModifyPOPSettings(cfgfile, endSurf=i)
    tmp_curr_irr_surf, tmp_curr_griddat = ln.zGetPOP(settingsFile=cfgfile, displayData=True)
    irr_data_l2_m3.append(tmp_curr_irr_surf)
    irr_grid_l2_m3.append(tmp_curr_griddat)

for i in range(41, 49, 2):
    ln.zModifyPOPSettings(cfgfile, endSurf=i)
    tmp_curr_irr_surf, tmp_curr_griddat = ln.zGetPOP(settingsFile=cfgfile, displayData=True)
    irr_data_m3_m4.append(tmp_curr_irr_surf)
    irr_grid_m3_m4.append(tmp_curr_griddat)

for i in range(54, 61, 2):
    ln.zModifyPOPSettings(cfgfile, endSurf=i)
    tmp_curr_irr_surf, tmp_curr_griddat = ln.zGetPOP(settingsFile=cfgfile, displayData=True)
    irr_data_m4_l3.append(tmp_curr_irr_surf)
    irr_grid_m4_l3.append(tmp_curr_griddat)

for i in range(70, 77, 2):
    ln.zModifyPOPSettings(cfgfile, endSurf=i)
    tmp_curr_irr_surf, tmp_curr_griddat = ln.zGetPOP(settingsFile=cfgfile, displayData=True)
    irr_data_m5_m6.append(tmp_curr_irr_surf)
    irr_grid_m5_m6.append(tmp_curr_griddat)

for i in range(86, 93, 2):
    ln.zModifyPOPSettings(cfgfile, endSurf=i)
    tmp_curr_irr_surf, tmp_curr_griddat = ln.zGetPOP(settingsFile=cfgfile, displayData=True)
    irr_data_l4_comp.append(tmp_curr_irr_surf)
    irr_grid_l4_comp.append(tmp_curr_griddat)

##the same thing for all of but each data set

x_pos_l1_m2 = []

for i in irr_data_l1_m2:
    dx = i[-2] / 512
    tmp_x = [-i[-2] / 2 + dx * j for j in range(512)]
    x_pos_l1_m2.append(tmp_x)

waist_l1_m2 = []
for i in range(len(irr_grid_l1_m2)):
    popt, pcov = curve_fit(gaussian, x_pos_l1_m2[i], irr_grid_l1_m2[i][256], maxfev=1800)
    waist_l1_m2.append(2 * np.abs(popt[2]))

print(waist_l1_m2)
###############
x_pos_l2_m3 = []

for i in irr_data_l2_m3:
    dx = i[-2] / 512
    tmp_x = [-i[-2] / 2 + dx * j for j in range(512)]
    x_pos_l2_m3.append(tmp_x)

waist_l2_m3 = []
for i in range(len(irr_grid_l2_m3)):
    popt, pcov = curve_fit(gaussian, x_pos_l2_m3[i], irr_grid_l2_m3[i][256], maxfev=1800)
    waist_l2_m3.append(2 * np.abs(popt[2]))

print(waist_l2_m3)
######
""""
irr_data = []
irr_grid_data = []

irr_data_l1_m2 = []
irr_data_l2_m3 = []

irr_data_m3_m4 = []
irr_data_m4_l3 = []

irr_data_m5_m6 = []
irr_data_l4_comp = []

irr_grid_l1_m2 = []
irr_grid_l2_m3 = []

irr_grid_m3_m4 = []
irr_grid_m4_l3 = []

irr_grid_m5_m6 = []
irr_grid_l4_comp = []
"""
####################
x_pos_m3_m4 = []

for i in irr_data_m3_m4:
    dx = i[-2] / 512
    tmp_x = [-i[-2] / 2 + dx * j for j in range(512)]
    x_pos_m3_m4.append(tmp_x)

waist_m3_m4 = []

for i in range(len(irr_grid_m3_m4)):
    popt, pcov = curve_fit(gaussian, x_pos_m3_m4[i], irr_grid_m3_m4[i][256], maxfev=1800)
    waist_m3_m4.append(2 * np.abs(popt[2]))

print(waist_m3_m4)

##########
x_pos_m4_l3 = []

for i in irr_data_m4_l3:
    dx = i[-2] / 512
    tmp_x = [-i[-2] / 2 + dx * j for j in range(512)]
    x_pos_m4_l3.append(tmp_x)

waist_m4_l3 = []
for i in range(len(irr_grid_m4_l3)):
    popt, pcov = curve_fit(gaussian, x_pos_m4_l3[i], irr_grid_m4_l3[i][256], maxfev=1800)
    waist_m4_l3.append(2 * np.abs(popt[2]))

print(waist_m4_l3)

#####

x_pos_m5_m6 = []

for i in irr_data_m5_m6:
    dx = i[-2] / 512
    tmp_x = [-i[-2] / 2 + dx * j for j in range(512)]
    x_pos_m5_m6.append(tmp_x)

waist_m5_m6 = []
for i in range(len(irr_grid_m5_m6)):
    popt, pcov = curve_fit(gaussian, x_pos_m5_m6[i], irr_grid_m5_m6[i][256], maxfev=1800)
    waist_m5_m6.append(2 * np.abs(popt[2]))

print(waist_m5_m6)

#########

x_pos_l4_comp = []

for i in irr_data_l4_comp:
    dx = i[-2] / 512
    tmp_x = [-i[-2] / 2 + dx * j for j in range(512)]
    x_pos_l4_comp.append(tmp_x)

waist_l4_comp = []
for i in range(len(irr_grid_l4_comp)):
    popt, pcov = curve_fit(gaussian, x_pos_l4_comp[i], irr_grid_l4_comp[i][256], maxfev=1800)
    waist_l4_comp.append(2 * np.abs(popt[2]))

print(waist_l4_comp)
###############
# the lenses and mirrors
optical_pos = [2, 7, 11, 24, 28, 40, 52, 63, 68, 80, 84]
# start, M1, L1, M2, L2, M3, M4, L3, M5, M6, L4
optical_irr_data_left = []
optical_irr_grid_left = []

for i in optical_pos:
    ln.zModifyPOPSettings(cfgfile, endSurf=i)
    tmp_curr_irr_surf, tmp_curr_griddat = ln.zGetPOP(settingsFile=cfgfile, displayData=True)
    optical_irr_data_left.append(tmp_curr_irr_surf)
    optical_irr_grid_left.append(tmp_curr_griddat)

#####

x_pos_left = []

for i in optical_irr_data_left:
    dx = i[-2] / 512
    tmp_x = [-i[-2] / 2 + dx * j for j in range(512)]
    x_pos_left.append(tmp_x)

waist_left = []
for i in range(len(optical_irr_grid_left)):
    popt, pcov = curve_fit(gaussian, x_pos_left[i], optical_irr_grid_left[i][256], maxfev=1800)
    waist_left.append(2 * np.abs(popt[2]))

print(waist_left)

#########

##############


all_waist = []
all_waist.append(waist_left[0])
all_waist.append(waist_left[1])
all_waist.append(waist_left[2])

for i in waist_l1_m2:
    all_waist.append(i)

all_waist.append(waist_left[3])
all_waist.append(waist_left[4])

for i in waist_l2_m3:
    all_waist.append(i)

all_waist.append(waist_left[5])

for i in waist_m3_m4:
    all_waist.append(i)
all_waist.append(waist_left[6])

for i in waist_m4_l3:
    all_waist.append(i)

all_waist.append(waist_left[7])
all_waist.append(waist_left[8])
for i in waist_m5_m6:
    all_waist.append(i)
all_waist.append(waist_left[9])
all_waist.append(waist_left[10])


for i in waist_l4_comp:
    all_waist.append(i)

#####################

pos = [0]

# pos.append(pos[-1]+541)
# pos.append((pos[-1]+568))

drift_l1_m2 = [517] * 4
for i in drift_l1_m2:
    pos.append(pos[-1] + i)

# pos.append(2636)
# pos.append(pos[-1]+100)

drift_l2_m3 = [770.5] * 4
for i in drift_l1_m2:
    pos.append(pos[-1] + i + 100)

pos.append(5818)

drift_insidegallery = [1530.25] * 4
for i in drift_insidegallery:
    pos.append(pos[-1] + i)

pos.append(11939)

drift_m3_l4 = [503.075] * 4
for i in drift_m3_l4:
    pos.append(pos[-1] + i)

pos.append(13951.3)
pos.append(pos[-1] + 381.7)

drift_iptable = [2934.575] * 4
for i in drift_iptable:
    pos.append(pos[-1] + i)

pos.append(26071.3)
pos.append(pos[-1] + 381.7)

drift_l4_comp = [472.5] * 4
for i in drift_l4_comp:
    pos.append(pos[-1] + i)

fig = plt.figure(figsize=(30, 10))
ax = fig.add_subplot(111)

ax.plot(all_waist, linestyle=':', label='TiSaph 1f Away')
ax.set_ylabel(ylabel='Beam Size(mm)')
ax.set_xlabel(xlabel='Beam Position in Transport (mm)')

fig.suptitle('Laser Transport FACET-II')
fig.legend(loc='lower right')
fig.tight_layout()
# fig.savefig(r"C:Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs\tisaph15nm.png")


# dx = np.divide(irr_data[0][-2],512)

# x_arr = []


print(len(all_waist))
print(len(pos))

data = np.array([pos, all_waist])
data = data.T
fpath = r"C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs\tisaph_1mm.csv"

np.savetxt(fpath, all_waist)

"""




df = pd.DataFrame({'pos(mm)':pos, 'beam waist(mm)' : all_waist })

df.to_csv('tisaphat20mm.csv', sep='\t')
"""

"""

for i in irr_data:
    #print(i[-2])
    dx = ((i[-2]/512))
    #generate the tmp x
    tmp_x = [-i[-2]/2 + dx*j for j in range(512)]
    x_arr.append(tmp_x)


#ax.plot(x_arr[0], irr_grid_data[0][256])
waist = []

for i in range(len(irr_grid_data)):
    popt, pcov = curve_fit(gaussian, x_arr[i], irr_grid_data[i][256], maxfev=1800)
    waist.append(2*np.abs(popt[2]))

"""