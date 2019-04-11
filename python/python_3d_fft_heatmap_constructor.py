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

def load_ffted_data(filename):

    #read in a file
    with open(filename, 'r') as f:

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

#set the timestep for the video
timestep = 0.1

#set the size of the object
size = 100

#set the precision of the fft
n = 512

#where to find the output files
target_dir = './output/'

#load in the filenames
filenames = glob.glob(target_dir + '*.txt')

#sort of filenames alphabetically
filenames.sort()

print(filenames)

filename = filenames[0]

result = load_ffted_data(filename)


freqs = []

for i in range(int(n/2)):
        freqs.append(((1/timestep)/n) * i)


#Set the frequencies you want to centre on
desired_freqs = [(2* math.pi)/5, (2* math.pi)/7, (2* math.pi)/13, (2* math.pi)/17]

window = math.pi/20

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

    result = load_ffted_data(filename)

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
    plt.title(repr(desired_freqs[i]) + "Hz")
    plt.axis("off")
    cb1 = plt.colorbar()
plt.show()
