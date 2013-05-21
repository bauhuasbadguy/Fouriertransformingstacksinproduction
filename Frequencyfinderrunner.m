%Frequency analysis of a series of images demonstrating intensity
%Stuart Bowe

%%



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

checker1 = 0;

q1 = 0;

initnumberofimages = input('How many images do you want to load ');
disp('What is the prefix? (Eg files names along the lines')
filestyle = input(' S_A1_000.tiff will  have the prefix S_A1_) ','s');

for counter1 = 0:1:initnumberofimages-1
    
    q1 = q1+1;
    
    if counter1 <= 9 && counter1 >=1
        
        imagestack(:,:,q1) = imread([filestyle,'00',num2str(counter1),'.tif']);
        
    elseif counter1 <= 99 && counter1 >= 10
        
        imagestack(:,:,q1) = imread([filestyle,'0',num2str(counter1),'.tif']);
        
    elseif counter1 == 0
        imagestack(:,:,q1) = imread([filestyle,'000','.tif']);
        
    else
        
        imagestack(:,:,q1) = imread([filestyle,num2str(counter1),'.tif']);
        
    end
    
end

%%
%Loading the timestamps

filename = input('Put the txt file name (including extension) for the timestamps in here:-','s');
file=load(filename);
%Load the timestamps

%By this point we should have both a 3D matrix representing a sequence of
%images equally spaced in time and a vector containing these time stamps
%%

%The fourier transformation
n = 2048;
finalimagestacksize = size(imagestack);
sampingfreq = 1./(file(2)-file(1));%number of samples per second

startx=load('got_to.txt');


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
    
    
    
    for n4 = startx(1):1:finalimagestacksize(1)%from the first to last matrix element in y
        %freqstack(n4,:,:) = zeros(1,finalimagestacksize(2),n./2);
        for n5 = 1:1:finalimagestacksize(2)%From the first to last matrix element in x
            
            
            datatobefouriered = imagestack(n4,n5,:);%Extract a z-slice of data which will be fouriered into our frequency data
            %this process is split into parts to help with debugging
            
            
            
            
            
            freqresultonepixel = 2.*(abs(fft(datatobefouriered,n)))./(length(file));%here's where we actually transform the data
            thistransform(:,n5) = freqresultonepixel(1:1:(n/2));
            dlmwrite(['transformed',filestyle,'posx',num2str(n4),'.txt'],thistransform)%save as we go along so that if we hit a crash we don't have to start again from scratch
            dlmwrite('got_to.txt',[n4 length(imagestack)])%A marker so that if the program crashes
            %whilst running some of the data can be retreaved
            %freqstack(n4,n5,:) = freqresultonepixel(1:1:(n/2));%Converts the frequency data extracted into one big matrix.
            %This is where memory becomes an issue if you find yourself
            %running low reduce the number of points that the fourier analysis
            %outputs
            
        end
        
    end
    
else
    
%     for loadcounter1=1:1:startx(2)
%         
%         line=load(['transformed',filestyle,'posx',num2str(loadcounter1),'.txt']);
%         
%         freqstack(loadcounter1,:,:)=line';
%     end
    
end

dlmwrite('got_to.txt',[0 length(imagestack)])

%%

%this cell will contain the ui used to allow the user to view the abundance
%of various frequencies of osscilation

clear imagestack%clearing up some memory space

freqstacksize=[startx(2) startx(2) n];

outputmatrix = zeros(freqstacksize(1),freqstacksize(2));
fnyquist = sampingfreq./2;
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
    
for freqtofind = freques
    
    for n6 = 1:1:freqstacksize(1)
        
        n10 = 0;
        
        thislineresult = load(['transformed',filestyle,'posx',num2str(n6),'.txt']);
        
        for n7 = 1:1:freqstacksize(2)
            
            for n9 = 1:1:length(frequencyxvalues)
                
                if frequencyxvalues(1,n9) >= freqtofind-rangetouse && frequencyxvalues(1,n9) <= freqtofind+rangetouse
                    
                    n10 = n10+1;
                    positionmarkers(n10) = n9;
                    finalimage(n6,n7) = sum(thislineresult(positionmarkers,n7));
                    
                end
            end
            
            
            
        end
        
    end
    dlmwrite([filestyle,'frequency',num2str(freqtofind*10000),'Hz+or-',num2str(rangetouse*10000),'Hz.txt'],finalimage)
    figure
    imagesc(finalimage)
    Title(['Frequency ',num2str(freqtofind.*(10.^-6)),'MHz Range +/-',num2str(rangetouse.*(10.^-6)),'MHz Maximum frequency intensity=',num2str(max(max(finalimage)))])
    colormap Jet
    colorbar
    axis off
    
    
end

%         figure
%         stack1(1:freqstacksize(3)) = freqstack(10,10,:);
%         plot(frequencyxvalues(1,:),stack1)
%         figure
%         stack2(1:freqstacksize(3)) = freqstack(10,40,:);
%         plot(frequencyxvalues(1,:),stack2)
%         figure
%         stack3(1:freqstacksize(3)) = freqstack(40,10,:);
%         plot(frequencyxvalues(1,:),stack3)
%         figure
%         stack4(1:freqstacksize(3)) = freqstack(40,40,:);
%         plot(frequencyxvalues(1,:),stack4)
%




