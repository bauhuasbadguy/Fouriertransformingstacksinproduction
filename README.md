Fouriertransformingstacksinproduction
=====================================

Fourier transform programs pre-publishing

This series of programs produces a series of heat maps showing the frequency of ocillation of the intensities of 
individual pixels in a stack of .tiff images.

The code strats by asking the user for the number of images to be transformed, the suffix of those images (assuming 
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
