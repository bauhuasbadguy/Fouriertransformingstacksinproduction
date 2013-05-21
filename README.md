Fouriertransformingstacksinproduction
=====================================

Fourier transform programs pre-publishing

Basic summary

This series of programs produces a series of heat maps showing the frequency of ocillation of the intensities of 
individual pixels in a stack of .tiff images.

========================================================================================================================
Twitter version

Codes to do Fourier transforms of .tiff image stacks to find the frequency of oscillation in magnetisation from PEEM 
data #twitterphysics
=====================================================================================================================
User guide

The finer details of the UI may vary as the code was developed but here is a general guide for using early iterations 
of the code:-
1. Select the directory in matlab where your .tiff files are stored
2. Create a .txt file called got_to.txt in that directory which contains just the number 1
3. Create a .txt file containing the timestamps for all your images there is a code to help you do this called 
timestampmodel.txt
4. Hit run
5. The code will first ask for the number of images to analyse, just type in the number
6. Next the code will ask for the suffix, assuming that the data was processed using the igor program at diamond the
format will be S_A1_000.tif so you should type in S_A1_. No need for quotation marks just type it straight in
7. There will be a pause whilst it loads the images in, after that it will ask for the timestamps name with the 
extension. This time type in the full file name.
8. The code will now produce the fourier transformed data, you can see the files being created in the directory to
check it's working but this process can take up to 4 days once its done this however it won't need to do it again 
unless you delete the files it produces, like a muppet.
9. Now it should ask whether you want to produce heat maps of a specific set of frequencies or not. A simple y/n input
will do here
10. Just answer the on screen questions, they all just want a numerical answer and once you've told it everything it
wants to know it'll produce your heat maps. This can take a while as well but not as long as the initial calculations
and like the fourer transformation section will save the results as a series of text files that you can use to reclaim
your results if the DRM has a hissy fit.


=====================================================================================================================
Code structure

The code starts by asking the user for the number of images to be transformed, the suffix of those images (assuming 
diamond naming convention) and the name of the .txt file containing the timestamps on all the individual images.
It then transforming the images into a huge 3D matrix and then fourier transforming individual z-slices one row at a 
time. Once it has complited each row it creates a .txt file containing a 2D matrix which has each z-slice in the row's 
transformed data with each x position indicating the pixles position in x an the fourier transformation forming the 
columns, the y position is saved in the file name. The code calculates the frequency represented by each piece of data
using the timestamps for each image. The code also saves the row the code has reached to the .txt file "got_to.txt" so
that if the matlab crashes halfway through, this happens infuriatingly regularly due to the network connection being 
lost and the DRM shutting everything down. The "got_to.txt" file also saves the image size so that the code can
complite the entire row when reading the data back and goes to zero once all values have been collected in order to
tell the code to skip this step in future.

Once the fourier transformation has been complited the program then clears its memory in order to make room on the RAM.
The program now asks the user whether they want to find a specific set of points or if they want to run between two 
frequencies finding a number of images (again defined by the user) covering the defined range so that each image's
range stops just short of the next image's range, or to find a specific set of frequencies using a range defined by
the user. The program then sums the values of the fourier transformation between each point in order to produce a 2D 
matrix representing a heat map of the defined frequency range across the image (see figure 1)

Fig 1.
                                        frequency-range          frequency+range
      Fourier transformed data=>1843529481763924|761923847619237846193456|2784619732846913287
                                                             |
                                                            sum
                                                             |
                                                             V
                                 Value for that particular pixel in this particular heat map
   
   
These 2D matracies are then saved as .txt files in case the code crashes in the middle of producing figures and the 
heat maps are output as figures.

=======================================================================================================================
This repository contains a number of files with different purposes, for this reason here is a list to help you use the
files effectively (Listed by date of upload):-

Readme.md => That's this file fool

Frequencyfinderrunner.m => The vanilla version of the program, reads raw data and the UI is a total mess
got_to.txt => An example of a got_to file, a bookkeeping device for the code

testimestampsb.txt => An example of a set of timestamps, can be used with the testpieces produced by the testpiece
producing file included here

normalizationprogram.m => Normalises a stack of .tiff images so that their values run between 1 and -1

frequencyfinderfornormalizeddata.m => Performes the fourier analysis on data normalized by normalisationprogram.m

teststackdfrequencydevice.m => Produces a set of .tif images which you can use to test the fourier transformation 
programs

