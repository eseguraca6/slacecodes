import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit

import pyzdde.zdde as pyz


def gaussian(x, const, mean, sigma):
    mean_factor = x - mean
    e_arg = np.exp(-np.divide(np.square(mean_factor), 2 * np.square(sigma)))
    return (const * e_arg)

file = r"C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs\cbtest.zmx"

link = pyz.createLink(file)

link.zInsertSurface(3)
link.zSetGlass(3, 'MIRROR')

link.close()