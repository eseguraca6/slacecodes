import pyzdde.zdde as pyz

ln = pyz.createLink()

file = r'C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs\test.zmx'





ln.zLoadFile(file)
#ln.ipzGetLDE()
ln.zSetWave(1, .800, 1)
setfile = ln.zGetFile().lower().replace('.zmx','.CFG')
GAUSS_WAIST, WAIST_X, WAIST_Y, beam_waist = 0, 1, 2, 1
S_512 = 5
grid_size = 15
cfgfile =ln.zSetPOPSettings('cross', setfile, 2, endSurf=2, field=1, wave=1, beamType=GAUSS_WAIST, paramN=((WAIST_X, WAIST_Y), (beam_waist, beam_waist)), sampx=S_512, sampy=S_512, widex=grid_size, widey=grid_size, tPow=1)

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
    #ln.zGetPOPCrossSec()
    ln.zGetTextFile(r'C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs\\' +str(i)+ '.csv', 'Pop', 'Pop')#POP(settingsFile=cfgfile, displayData= True).zSaveFile(str(i)+'.csv')
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
waist = []

for i in range(len(irr_grid_data)):
    popt, pcov = curve_fit(gaussian, x_arr[i], irr_grid_data[i][256], maxfev=1800)
    waist.append(2*np.abs(popt[2]))


print(waist)

pos = [284, 568, 836, 1120]

ax.plot(pos, waist)
fig.savefig('test.pdf')


for i in range(15, 21):
    ln.zInsertSurface(i)


ln.zInsertCoordinateBreak(15, 0,0, 45,0,0,order=0, thick=2)
ln.zSetSurfaceData(16, 4)
ln.zInsertCoordinateBreak(17, 0,0, -45,0,0,order=0, thick=2)

#ln.ipzGetLDE()




ln.zSaveFile(file)

