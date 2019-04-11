#fft heatmap constructor


import numpy as np
import os
import PIL
import time
import scipy.io
import matplotlib
import matplotlib.pyplot as plt
import glob
import math

def load_ffted_data(target_dir, filename):

    #read in a file
    with open(target_dir + filename, 'r') as f

        readstring = f.read()

    #split the string by newlines
    readstring = readstring.split('\n')

    #remove empty lines from the dataset
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

os.chdir(target_dir)

filenames = glob.glob('*.txt')

filename = filenames[0]

result = load_ffted_data(target_dir, filename)


freqs = []

for i in range(n/2):
        freqs.append(((1/timestep)/n) * i)


#Set the frequencies you want to centre on
desired_freqs = [80e6, 160e6, 320e6]

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
        print(y)

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

print("Plotting")
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
