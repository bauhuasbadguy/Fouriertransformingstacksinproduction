%configuration file
%run this file first
clear all
close all
filestyle='Stuartdata1';
timestamp=50e-12;
startfile=180;
lastfile=500;
n=2048;
startfreq=0;
endfreq=1e9;
nofreqstofind=21;
imagenum=lastfile-startfile+1;
mdir='z';
root='F:/MATLAB/OOMMFtomatlabconverters/duncans edited OOMMF converter/firstsetofdata/mat/';
save('configuration.mat')

if exist('got_to.txt','file') == 2
else
dlmwrite('got_to.txt',1)
end