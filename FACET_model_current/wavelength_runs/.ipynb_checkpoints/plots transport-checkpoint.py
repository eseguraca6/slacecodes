# -*- coding: utf-8 -*-
"""
Created on Fri Mar  9 18:36:16 2018

@author: pwfa-facet2
"""

import numpy as np
import matplotlib.pyplot as plt

from scipy.optimize import curve_fit

pos = [0] #start

pos.append(pos[-1]+541) #m1
pos.append(pos[-1]+27) #l1

for i in range(0,3): #drifts 
    pos.append(pos[-1]+517)

pos.append(pos[-1]+517) #m2
pos.append(pos[-1]+100) #l2

for i in range(0,3):
    pos.append(pos[-1]+770.5)

pos.append(pos[-1]+770.5) #m3


for i in range(0,3):
    pos.append(pos[-1]+1530.25)

pos.append(pos[-1]+1530.25) #m4


for i in range(0,3):
    pos.append(pos[-1]+503.25)
    
pos.append(pos[-1]+503.25) #l3
pos.append(pos[-1]+381.7) #m5

for i in range(0,3):
    pos.append(pos[-1]+2934.575)

pos.append(pos[-1]+2934.575) #m6
pos.append(pos[-1]+381.7) #l4

for i in range(0,3):
    pos.append(pos[-1]+472.5)
    
print(len(pos))
pos_2m = []
pos_2m.append(0)
for i in range(1, len(pos)):
    pos_2m.append(pos[i]+2000)
######

saph_1_2000 = np.loadtxt('800_1_2000.csv')
saph_1_541 = np.loadtxt('800_1_541.csv')


saph_5_2000 = np.loadtxt('527_5_2000.csv')
saph_5_541 = np.loadtxt('527_5_541.csv')

hene_1_2000 = np.loadtxt('527_1_2000.csv')
hene_1_541 = np.loadtxt('527_1_541.csv')


hene_5_2000 = np.loadtxt('527_5_2000.csv')
hene_5_541 = np.loadtxt('527_5_541.csv')



saph= plt.figure(figsize=(10,10))
saphos = saph.add_subplot(111)
saphos.scatter(pos_2m, saph_1_2000, marker = 'o', color ='red', label = 'Ti:Saph 2m away ($w_{0} = 1mm$)', s=30)
saphos.plot(pos_2m, saph_1_2000, linestyle = '--', color = 'blue')



saphos.scatter(pos, saph_1_541, marker = 'p', color ='green', label = 'Ti:Saph 1f away ($w_{0} = 1mm$)', s=50)
saphos.plot(pos, saph_1_541, linestyle = ':', color = 'red')

labels = ['$L_{1}$','$L_2$', '$M_3$', '$M_4$', '$L_3$', '$M_5$', '$M_6$','$L_4$' ]
x = pos
y = saph_1_541

xp = [x[1], x[7] ,x[11],  x[15],x[19], x[20], x[24], x[25]]
yp = [y[1], y[7], y[11],  y[15],y[19],y[20],y[24], y[25]]
for l, xpt, ypt in zip(labels, xp,yp):
    plt.text(xpt,ypt,l, fontsize=15)

x = pos_2m
y = saph_1_2000

xp = [x[1], x[7] ,x[11],  x[15],x[19], x[20], x[24], x[25]]
yp = [y[1], y[7], y[11],  y[15],y[19],y[20],y[24], y[25]]
for l, xpt, ypt in zip(labels, xp,yp):
    plt.text(xpt,ypt,l, fontsize=15)

plt.tight_layout()

saphos.set_xlabel('Position Along Transport(mm)')
saphos.set_ylabel('Beam Size (mm)')


saph.legend(loc = 'lower right')
saph.suptitle('Ti:Saph Beam Propagation in FACET-II Laser Transport', fontsize=20)

saph.tight_layout()
saph.subplots_adjust(top = 0.95)


###############################

hene= plt.figure(figsize=(10,10))
henesos = hene.add_subplot(111)
henesos.scatter(pos_2m, hene_5_2000, marker = 'D', color ='magenta', label = 'Ti:Saph 2m away ($w_{0} =5mm$)', s=30)
henesos.plot(pos_2m, hene_5_2000, linestyle = ':', color = 'cyan')



henesos.scatter(pos, hene_5_541, marker = 'H', color ='salmon', label = 'Ti:Saph 1f away ($w_{0} = 5mm$)', s=50)
henesos.plot(pos, hene_5_541, linestyle = '-.', color = 'brown')

labels = ['$L_{1}$','$L_2$', '$M_3$', '$M_4$', '$L_3$', '$M_5$', '$M_6$','$L_4$' ]
x = pos
y = hene_5_541

xp = [x[1], x[7] ,x[11],  x[15],x[19], x[20], x[24], x[25]]
yp = [y[1], y[7], y[11],  y[15],y[19],y[20],y[24], y[25]]
for l, xpt, ypt in zip(labels, xp,yp):
    plt.text(xpt,ypt,l, fontsize=15)

x = pos_2m
y = hene_5_2000

xp = [x[1], x[7] ,x[11],  x[15],x[19], x[20], x[24], x[25]]
yp = [y[1], y[7], y[11],  y[15],y[19],y[20],y[24], y[25]]
for l, xpt, ypt in zip(labels, xp,yp):
    plt.text(xpt,ypt,l, fontsize=15)



henesos.set_xlabel('Position Along Transport(mm)')
henesos.set_ylabel('Beam Size (mm)')


hene.legend(loc  = 'lower right',  ,borderaxespad=0.)
hene.suptitle('He:Ne Beam Propagation in FACET-II Laser Transport', fontsize=20)

hene.tight_layout()
hene.subplots_adjust(top = 0.95)



################################
"""
saph= plt.figure(figsize=(10,10))
saphos = saph.add_subplot(111)
saphos.scatter(pos_2m, saph_5_2000, marker = 'D', color ='magenta', label = 'Ti:Saph 2m away ($w_{0} =5mm$)', s=30)
saphos.plot(pos_2m, saph_5_2000, linestyle = ':', color = 'cyan')



saphos.scatter(pos, saph_5_541, marker = 'H', color ='salmon', label = 'Ti:Saph 1f away ($w_{0} = 5mm$)', s=50)
saphos.plot(pos, saph_5_541, linestyle = '-.', color = 'brown')

labels = ['$L_{1}$','$L_2$', '$M_3$', '$M_4$', '$L_3$', '$M_5$', '$M_6$','$L_4$' ]
x = pos
y = saph_5_541

xp = [x[1], x[7] ,x[11],  x[15],x[19], x[20], x[24], x[25]]
yp = [y[1], y[7], y[11],  y[15],y[19],y[20],y[24], y[25]]
for l, xpt, ypt in zip(labels, xp,yp):
    plt.text(xpt,ypt,l, fontsize=15)

x = pos_2m
y = saph_5_2000

xp = [x[1], x[7] ,x[11],  x[15],x[19], x[20], x[24], x[25]]
yp = [y[1], y[7], y[11],  y[15],y[19],y[20],y[24], y[25]]
for l, xpt, ypt in zip(labels, xp,yp):
    plt.text(xpt,ypt,l, fontsize=15)

plt.tight_layout()

saphos.set_xlabel('Position Along Transport(mm)')
saphos.set_ylabel('Beam Size (mm)')


saph.legend(loc = 'lower right')
saph.suptitle('Ti:Saph Beam Propagation in FACET-II Laser Transport', fontsize=20)

saph.tight_layout()
saph.subplots_adjust(top = 0.95)
"""
