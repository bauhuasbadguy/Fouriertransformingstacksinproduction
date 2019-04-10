#fft heatmap constructor


import sys
sys.path.append('C:/Python27/Lib/site-packages')
sys.path.append('C:\Python27\Lib\site-packages\heatmap')
#sys.path.remove('V:\\Brian.140\\Python.2.7.3\\lib\\site-packages')
import numpy as np
import os
import PIL
import time
import scipy.io
import matplotlib
import matplotlib.pyplot as plt
import glob
import glob
import math

def load_ffted_data(target_dir, filename):

    f = open(target_dir + filename, 'r')


    readstring = f.read()


    readstring = readstring.split('\n')

    readstring.remove('')


    result = []

    for i in range(len(readstring)):


        rawstring = readstring[i].split(', ')

        rawstring.remove('')

        processed_string = []
        
        for l in range(len(rawstring)):

            processed_string.append(float(rawstring[l]))

        result.append(processed_string)


    return result

###################################
### End of function definitions ###
###################################




timestep = 100e-12
#0.025e-9

#0.01
#0.025e-9
size = 500
#500
n = 512


#dev pre-fft reading function

target_dir = 'F:/Python_programs/processing_XMCD_data/December_2014_video_1_analysis/stack_fft_result/'
#'G:/HPCcalculations/500nmsquare_realistic_damping/0KJ/amplitude10/bmp/python_3D_fft_on_x/'
#'E:/HPCcalculations/2000nmextension/0KJ/amplitude10/bmp/python_3D_fft_on_x/'
#'H:/HPCcalculations/1500nmsquare/0KJ/amplitude10/bmp/python_3D_fft_on_x/'
#'G:/HPCcalculations/500nmsquare/40KJ/amplitude10/bmp/python_3D_fft_on_x/'
#'G:/HPCcalculations/500nmsquarenouniax/0KJ/amplitude10/bmp/python_3D_fft_on_x/'
#target_dir = 'G:/HPCcalculations/500nmsquarenouniax/0KJ/amplitude10/bmp/python_3D_fft_on_x/'
#target_dir = "F:/Python_programs/fft_programs/stackfftprograms/test_piece_python_fft/"
#'G:/HPCcalculations/500nmsquare/0KJ/amplitude10/bmp/python_3D_fft_on_x/'
#"F:/Python_programs/fft_programs/stackfftprograms/test_piece_python_fft/"
#'G:/HPCcalculations/500nmsquare/0KJ/amplitude10/bmp/python_3D_fft_on_x/'

os.chdir(target_dir)

filenames = glob.glob('*.txt')

filename = filenames[0]

result = load_ffted_data(target_dir, filename)


freqs = []

for i in range(n/2):
        freqs.append(((1/timestep)/n) * i)


#Set the frequencies you want to centre on
desired_freqs = [80e6, 160e6, 320e6]
#[3e8, 5e9, 6.5e9, 12.3e9]
#no uniaxial anisotropy
#[8.493e9, 1.03453e10, 1.07765e10, 1.12458e10, 1.19433e10, 1.21842e10]
#amp 10 500nm square
#desired_freqs = [2, 5, 11, 23]

#500nm square amp 10 frequencies
#[3e8, 5e9, 6.5e9, 1.122e10, 1.22e10]
#testpiece frequencies
#[2, 5, 11, 23]
#[3e8, 5.05e9, 6.53e9, 1.1224e10, 1.19867e10, 1.2236e10]
#[3e8, 8.42e9, 9.36703e9, 1.06145e10, 1.1236e10, 1.22578e10, 1.42148e10]
#[8.241e9]
#[1.8e9, 3.05e9, 8.27e9]
#[2.67e9, 4.13e9, 9.313e9]
#[2e8, 2.67e9, 4.13e9]

#desired_freqs = [2e8, 1.36e9, 2.49e9, 7.79e9]
#[7.5e9, 1.27e10]

window = 1e7

index_windows = []
heatmaps = []

for i in range(len(desired_freqs)):
    index_windows.append([])
    heatmaps.append([])


for freq_index, f in enumerate(freqs):

    for window_index, desired_freq in enumerate(desired_freqs):

        if (f <= (desired_freq + window)) and (f >= (desired_freq - window)):

            index_windows[window_index].append(freq_index)


for y, filename in enumerate(filenames):


    if y%100 == 0:
        print y

    result = load_ffted_data(target_dir, filename)

    for heatmap_no, heatmap in enumerate(heatmaps):

        heatmaps[heatmap_no].append([])
        

    for x, fftline in enumerate(result):

        for freq_no, wanted_freq in enumerate(desired_freqs):

            pixel_components = []
            for index in index_windows[freq_no]:
                pixel_components.append(result[x][index])
                


            this_pixel = sum(pixel_components)


            heatmaps[freq_no][y].append(this_pixel)




print "Plotting"
heatmap_images = []

for i, heatmap in enumerate(heatmaps):


    heatmap_images.append(np.array(heatmap))





font = {"family" : "normal",
        "size" : 24}

matplotlib.rc("font", **font)



for i in range(len(heatmaps)):
    plt.figure()
    plt.imshow(heatmap_images[i])
    #plt.title(repr(desired_freqs[i] * 1e-8) + "GHz")
    plt.axis("off")
    cb1 = plt.colorbar()
    cb1.set_label(r'Am$^{2}$')
plt.show()
