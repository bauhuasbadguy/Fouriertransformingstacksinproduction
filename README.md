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
This is a user guide for the MK2 user interface when transforming .mat files produced from OOMMF:-

1. Use a program like the batch rename converter to rename the .omf files numberically so that the new names are 0.omf,
  1.omf,2.omf ect. When doing this make sure they are in a folder you can easely identify because all the different data
  sets will look the same after this
2. Use Duncan's batch converter to turn these files into .mat files. You can also use the toolbox OOMMFTools but that'll
  take ages so use the file found in the OOMMFtools repository.
3. First edit the values in the code creatingaconfigfile.m to match the parameters in your code, the parameters are 
   listed below.
    a.In the .mat version filestyle will set the prefix on the output files, don't change this after you've run the code 
    once or errors will ensue
    b.timestamp is the time between images, for the moment it can only do equally spaced images but I intend to fix that
    in the future
    c.startfile is the first file in the sequence which you want to fourier transform. For the moment it is assumed that
    the naming nomenclature described in step one was used with 0.omf.mat being the first image. This variable is used
    for sequences that don't start in a stable state.
    d.lastfile is the total number of files it is equal to the name of the last file +1
    e.n is the size of the fourier transformation, the bigger n is the more detailed the result and the longer the code
    takes to run
    f.startfreq defines the lower bound of the frequencies of the heat maps to be found
    g.endfreq defines the final frequency in the run
    h.nofreqstofind sets the number of images to produce between the starting frequency and the final frequency
    i.mdir sets the magnetisation direction your looking at you can choose 'x','y' or 'z'. If you don't enter a valid 
    selection 'x' will be chosen for now
    j.root is the root of the .mat files to be converted, your getting a look inside my computer with the standard one
    WOOOOOOOOO
    k.The rest of the lines should'nt be edited, they save the configuration file and create the marker file
4. Run fourier transformformatfiles.m everything should go smoothly. If something interupts the fourier transformation
  stage it has been set up so that it reads got_to.txt (one of the files that was created when you ran 
  creatingconfigfile.m) and uses that to know how far it got through the fourier transformation. At the end of the 
  fourier transformation stage got_to will automatically change to 0. If you edit this file manually you'll fuck 
  everything up so don't play arround with it unless you know what your doing. When the code has finished running it'll
  produce a series of MATLAB figures as well as a series of .txt files that can be used to load the results quickly 
  rather than having to run the main program every time.


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
figures and saved as a series of .txt files. A secondry program for loading the outputs in post is in the main branch.


File list
=========
This repository contains a number of files with different purposes, for this reason here is a list to help you use the
files effectively (Listed by date of upload):-

Readme.md => That's this file fool

fouriertransformformatfiles.m => The main file, used to analyse a stack of .mat files

drawingthematfiles => Used to test the loading. Produces an example of the z component of the .mat files, an example 
  quiver diagram showing the x and y components of a .mat file, produces a 3D plot of the x and y components of the 
  maximum in the z component and fourier transforms of those co-ordinates

creatingtheconfigfile => A file for creating the configuration program to be read by the main code , called 
  configuration.mat, as well as a placeholder file called got_to.txt

FAQs
============

Q. I put the wrong settings in the first time I ran the code, how do I do the fourier transform again with the right 
  settings?

A. Wipe all the .txt files in the folder your looking to save your results to and run the configuration program folowed 
  by the main code again.
  
Q. Why are you so awesome?

A. It just comes naturally to some people.

Q. Why do some people not write readmes?

A. Because they're doing the internet wrong.
