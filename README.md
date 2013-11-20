Fouriertransformingstacksinproduction
=====================================

Fourier transform programs pre-publishing

Basic summary
=============
This series of programs produces a series of heat maps showing the frequency of ocillation of the intensities of 
individual pixels in a stack of .mat files produced when converting from a .omf file into a .mat file. The conversion
is done using the batch converter made by Duncan Parkes which he baised on the .omf to .mat file converter called 
OOMMFtools writen by Mark Mascaro in 2010. Duncan's batch converter can be found in the OOMMFtools repository.


Twitter version
===============
Codes to do Fourier transforms of .mat files produced from .omf files produced from a theoretical simulation in OOMMF
#twitterphysics


User guide
===========
The finer details of the UI may vary as the code was developed but here is a general guide for using early iterations 
of the code:-
1. Use a program like the bulk rename utility to rename all your files 0,1,2,3 ect.
2. Convert these .omf files into .mat files using the program omf.mat.py in the OOMMFtools repository
3. Create a .txt file called got_to.txt in that directory which contains just the number 1
4. Go to line 80 and change the sampling frequency to 1/'whatever the timestep between files is'
5. Change lune 31 so thet the route matches that of your .mat files
6. Change line 27 to match the size of your image (['image size in x' 'imagesize in y' 'number of images'])
7. Change lines 38 and 39 to match your image size
8. Change line 44 to the number of images your using
9. Change n in line 77 to match your desired fourier transform size
10. Change line 32 so that what is 3 here is 1,2 or 3 dependng on which component you wish to transform
10. Hit run. There will be a pause whilst it loads the images in and produces the fourier transformed data, you can 
see the files being created in the directory too. This should take up to 20 mins depending on the size of your image
11. Now it should ask whether you want to produce heat maps of a specific set of frequencies or not. A simple y/n input
will do here
12. Just answer the on screen questions, they all just want a numerical answer and once you've told it everything it
wants to know it'll produce your heat maps. This can take a while as well but not as long as the initial calculations
and like the fourer transformation section will save the results as a series of text files that you can use to reclaim
your results if the DRM has a hissy fit. In the future lines 2-8 should be automatic


Code structure
==============

The code reads in all the .mat files required for the fouier transform and loads them into a single 3D matrix. The code
then creates an average image and subtracts this average image from all the images in the stack. The next step is the 
fourer transformation in which each z-slice is fourier transformed a row in the image at the time. This produces a row
of .txt files each one representing a single y co-ordinate. After each row is fourier transformed the value of the 
counter in got_to.txt is increased by one. This is done in case the code falls down in the middle of the fourier 
transformation so that if there is a problem the completed text documents are not made a second time. Once this is done 
the code asks the user whether or not they want to investigat a specific set of frequency values or not. If they answer 
no then the code will ask them for the frequency range to use and how many heat maps to make over this range. The code 
will then create this series of heat maps by summing the amplitude values for frequencies between the range values 
,given in the title for each heat map and calculated so that each heat map overlaps with the one before, and then saving 
those values in a 3D matrix containing all the heat maps. The final result is symultaiously output as a series of matlab
figures and saved as a series of .txt files. A secondry program for loading the outputs in post is in the main branch


File list
=========
This repository contains a number of files with different purposes, for this reason here is a list to help you use the
files effectively (Listed by date of upload):-

Readme.md => That's this file fool

fouriertransformformatfiles.m => The main file, used to analyse a stack of .mat files

drawingthematfiles => Used to test the loading. Produces an example of the z component of the .mat files, an example 
quiver diagram showing the x and y components of a .mat file, produces a 3D plot of the x and y components of the 
maximum in the z component and fourier transforms of those co-ordinates

Known issues
============

1.The UI is a mess
