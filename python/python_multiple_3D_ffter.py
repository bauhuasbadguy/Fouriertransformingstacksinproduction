#Python 3D fft

#Program designed to do the 3D fitting procedure for a set of files

import glob
import numpy as np
import os
from PIL import Image
import matplotlib.pyplot as plt
import time

#A simple fft function
def fftdata(m, timestep, n):

    fftm = np.fft.fft(m, n)
    fftm = np.abs(fftm)

    
    freqs = []
    fftm1 = []
    for i in range(n/2):
        freqs.append(((1/timestep)/n) *i)
        fftm1.append(fftm[i])


    return [freqs, fftm1]


#save the results of a fft
def save_fft_2D_matrix(matrix, savename):

    savestring = ''

    for i, line in enumerate(matrix):

        for l, character in enumerate(line[:-1]):
            
            savestring = savestring + repr(character) + ', '

        savestring = savestring + '\n'

        

    f = open(savename, 'w')

    f.write(savestring)
    f.close()
    



timestep = 0.1e-9
n = 512

fft_time = 0
load_time = 0
save_time = 0


ksrange = [0, 10]
#range(00, 50, 10)
amprange = [10, 250]
#range(10, 20, 10)
#ks = 0
amp = 80

for ks in ksrange:

    #set where to get the bmps for the fft
    #target = 'H:/HPCcalculations/500nmsquare_delayed_pulse/' + repr(ks) + 'KJ/amplitude' + repr(amp) + '/bmp/xbmps/'
    target = "./bmp_from_paper/" + repr(ks) + "KJ/shrunk/"
    
    #set where to save the results of the fft
    output = "./bmp_from_paper/" + repr(ks) + "KJ/shrunk/python_3D_fft_on_x/"
    #output = 'H:/HPCcalculations/500nmsquare_delayed_pulse/' + repr(ks) + 'KJ/amplitude' + repr(amp) + '/bmp/python_3D_fft_on_x/'


    #move the root directory to the target directory
    os.chdir(target)

    #check that the output folder, if it doesn't, make it
    if os.path.exists(output) == False:
        os.mkdir(output)
    
    #load a list of the filenames in the target folder
    filenamelist = glob.glob('*.bmp')


    #remove the static frames from the filelist
    filenamelist = filenamelist
    print(filenamelist)
    #load the data in
    mainstack = []
    #cycle through the images and add them to the main stack
    for i, filename in enumerate(filenamelist):
        out = Image.open(target + filenamelist[i])


        red = np.ndarray.tolist(out[:,:,0])
        green = np.ndarray.tolist(out[:,:,1])
        blue = np.ndarray.tolist(out[:,:,2])
        result = np.subtract(red, blue)

        mainstack.append(result)


    #subtract the base image from each subsequent image in the stack to
    #remove base images
    base = mainstack[0]

    for i, image in enumerate(mainstack):

        mainstack[i] = np.subtract(image, base)


    print('Starting the fft')

    for y in range(0, len(mainstack[0])):

        column_matrix = []

        for x in range(0, len(mainstack[0][0])):

            #extract the data we want to fft
            data_to_be_ffted = []
            for i in range(len(mainstack)):
                data_to_be_ffted.append(mainstack[i][y][x])

            start_time = time.time()

            #do the fft
            [freqs, this_transform] = fftdata(data_to_be_ffted, timestep, n)

            end_time = time.time() - start_time

            fft_time += end_time

            #put the data into the 2D matrix we want to save
            column_matrix.append(this_transform)


        if len(repr(y)) < 4:

            padding = '0' * (4-len(repr(y)))

        savename = output + 'fft_data_col_' + padding + repr(y) + 'result.txt'
        save_fft_2D_matrix(column_matrix, savename)


    print('Done')
    #print fft_time

    #plt.figure()
    #plt.imshow(result)
    #plt.colorbar()
