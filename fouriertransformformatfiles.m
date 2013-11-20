%Frequency analysis of a series of images demonstrating intensity
%Stuart Bowe

%This code asks the user to input the filename, number of images and
%timestamps for a stack of images representing pictures taken of the same
%object with equal timesteps T. It then converts the images into matracies
%and then squashes the matracies into one huge 3D matrix which represents
%the full stack. It then takes z-slices of this 3D matrix and performs a
%fast fourier transformation on it in order to produce an analysis of the
%frequencies present. It then asks the user for a series of frequencies and
%produces heat maps demonstrating the intensities of frequencies it has
%found


%%
close all
clear all

%%

%Image loading section

q1 = 0;
tic
filestyle='Stuartdata1';
initnumberofimages = 500;
sizefinder = [100 100 321];
imagestack=zeros(sizefinder(1),sizefinder(2),sizefinder(3));
for filecount = 180:1:initnumberofimages
    q1 = q1+1;
        preimage=load(['F:/MATLAB/OOMMFtomatlabconverters/duncans edited OOMMF converter/firstsetofdata/mat/',num2str(filecount-1),'.omf.mat']);
        imagestack(:,:,q1) = preimage.OOMMFData(:,:,1,3);
end

%%
%subtracting the average from each point
%find the mean of each z-slice
for x1=1:100
    for y1=1:100
meanmatrix(x1,y1)=mean(imagestack(x1,y1,:));
    end
end
%subtract that mean from each image in the stack
for z1=1:321
    imagestack(:,:,z1)=imagestack(:,:,z1)-meanmatrix;
end  

%%
%Loading the timestamps
% 
%filename = input('Enter the name of the timestamps file ','s');
%file1=load(filename);
%file=file1(2:length(file1));
%Load the timestamps

%By this point we should have both a 3D matrix representing a sequence of
%images equally spaced in time and a vector containing these time stamps
%%
%Subtracting stage
% zeroimage=imread([filestyle,'000','.tif']);
% for s1=1:1:initnumberofimages
%     imagestack(:,:,s1)=imagestack(:,:,s1)-zeroimage;%This line
%     %subtracts the first image in the series from all subsequent images
% end

%%
%multiplying up
% for s2=1:1:initnumberofimages
%     imagestack(:,:,s2)=imagestack(:,:,s2).*100000000;%This line multiplies up
%     %to try and improve the fourier transform
% end


%%

%The fourier transformation
n = 2048;
finalimagestacksize = size(imagestack);%Find the x,y and z dimentions so
%that we can run across all of x and y later. z is not used
sampingfreq = 1/50e-12;%number of samples per second

startx=load('got_to.txt');
[imsx imsy imsz]=size(imagestack);

if startx(1) ~= 0
    
    if startx(1) ~= 1
        
        %         for loadcounter1=1:1:startx-1
        %
        %             line=load(['transformed',filestyle,'posx',num2str(loadcounter1),'.txt']);
        %
        %             freqstack(loadcounter1,:,:)=line';
        %
        %         end
    end
    
    thistransform=zeros(n/2,finalimagestacksize(2));
    
    for n4 = startx(1):1:finalimagestacksize(1)%from the first to last matrix element in y
        %freqstack(n4,:,:) = zeros(1,finalimagestacksize(2),n./2);
        parfor n5 = 1:1:finalimagestacksize(2)%From the first to last matrix element in x
            
            
            datatobefouriered = imagestack(n4,n5,1:finalimagestacksize(3));%Extract a z-slice of data which will be fouriered into our frequency data
            %this process is split into parts to help with debugging. In
            %this version of the code it runs from the second image to the
            %last as the first image should be all zeros
            
            
            freqresultonepixel = 2.*(abs(fft(datatobefouriered,n)))./(finalimagestacksize(3));%here's where we actually transform the data
            thistransform(:,n5) = freqresultonepixel(1:(n/2));
            
            %freqstack(n4,n5,:) = freqresultonepixel(1:1:(n/2));%Converts the frequency data extracted into one big matrix.
            %This is where memory becomes an issue if you find yourself
            %running low reduce the number of points that the fourier analysis
            %outputs
            
        end
        dlmwrite(['transformed',filestyle,'posx',num2str(n4),'.txt'],thistransform)%save as we go along so that if we hit a crash we don't have to start again from scratch
        dlmwrite('got_to.txt',[n4 imsx])%A marker so that if the program crashes
        %whilst running some of the data can be retreaved
    end
    
else
    
    %     for loadcounter1=1:1:startx(2)
    %
    %         line=load(['transformed',filestyle,'posx',num2str(loadcounter1),'.txt']);
    %
    %         freqstack(loadcounter1,:,:)=line';
    %     end
    
end
dlmwrite('got_to.txt',[0 imsx])
ffttime=toc/60;
%%

%this cell will contain the ui used to allow the user to view the abundance
%of various frequencies of osscilation
startx=load('got_to.txt');
clear imagestack%clearing up some memory space

freqstacksize=[startx(2) startx(2) n];
freqstacklength=startx(2);
outputmatrix = zeros(freqstacksize(1),freqstacksize(2));
fnyquist = sampingfreq./2;%find the nyquist frequency
frequencyxvalues(1,:) = ((sampingfreq)./(n)).*(0:((n/2)-1));

maxfreq = max(frequencyxvalues(1,:));
minfreq = min(frequencyxvalues(1,:));


disp(['The nyquist frequency is ',num2str(fnyquist),'Hz'])
runerpoints=input('do you want to find a specific set of points (y/n)? ','s');

if 1 == strcmp(runerpoints,'y') || 1 == strcmp(runerpoints,'Y')
    nofreqstofind = input('How many different frequency values do you want to find? ');
    rangetouse = input('What error do you expect on each frequency? ');
    
    for nf = 1:1:nofreqstofind
        
        freques(nf) = input(['What is frequency number ',num2str(nf),':-']);
        
    end
    
else
    
    startfreq=input('From what frequency? ');
    disp(['The nyquist frequency is ',num2str(fnyquist),'Hz'])
    endfreq=input('To what frequency? ');
    nofreqstofind=input('In how many steps? ');
    
    freques=linspace(startfreq,endfreq,nofreqstofind);
    rangetouse=(freques(2)-freques(1))./2;
    
    
end

finalimage=zeros(freqstacklength,freqstacksize(2),length(freques));
%%
for n11=1:length(freques)
    freqtofind=freques(n11);
    positionmarkers=zeros(1);
    for n9 = 1:1:length(frequencyxvalues)
        %This for loop is used to set where the position markers are for this
        %set of frequency values it does this by running through all the 
        %frequency values and then 
        n10=0;
        if frequencyxvalues(1,n9) >= freqtofind-rangetouse && ...
                frequencyxvalues(1,n9) <= freqtofind+rangetouse
            n10 = n10+1;
            positionmarkers(n10) = n9;
            %positionmarkers tells the code where to load the
            %values from later on
        end
    end
    
    for n6 = 1:1:freqstacklength
        %this for loop loads the results of the transformation and then
        %sums the relavent data points and saves them into the heat map
        %matracies (finalimage)
        
        thislineresult = load(['transformed',filestyle,'posx',num2str(n6),'.txt']);
        %line above loads the row that the loop below analysis
        parfor n7 = 1:1:freqstacksize(2)
            
            finalimage(n6,n7,n11) = sum(thislineresult(positionmarkers,n7))./length(positionmarkers);
            
        end
        
    end
    n11
    
end

creatingheatmapstime=(ffttime-toc)/60;
colourbarmaxvalue=max(max(max(finalimage)));
for n12=1:length(freques)
    freqtofind=freques(n12);
    
     dlmwrite([filestyle,'frequency',num2str(freqtofind.*(10.^-6)),'MHz+or-',num2str(rangetouse.*(10.^-6)),'MHz.txt'],finalimage(:,:,n12))
     figure
     imagesc(finalimage(:,:,n12))
     title(['Frequency ',num2str(freqtofind.*(10.^-6)),'MHz Range +/-',num2str(rangetouse.*(10.^-6)),'MHz Maximum frequency intensity=',num2str(max(max(finalimage(:,:,n12))))])
     colormap Jet
     colourbarmaxvalue=max(max(max(finalimage)));
     caxis([0 colourbarmaxvalue])
     %use the caxis line to clearly identify spacial frequencies
     colorbar
     axis square
     axis off
    
    %saving and printing the resultant heat maps
end

savingheatmapstime=(creatingheatmapstime-toc)/60;

tottime=toc;