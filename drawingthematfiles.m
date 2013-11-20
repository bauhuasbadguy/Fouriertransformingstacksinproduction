%importing converted.mat files
%this program is designed to extract the x and y positions of the vortex
%core and then plot them as a function of time in a 3D line graph
clear all
close all
%%
%This section was originally intended to work out how to load the data into
%matlab and how that data could be used in imaging
q=load('F:/MATLAB/OOMMFtomatlabconverters/duncans edited OOMMF converter/firstsetofdata/mat/467.omf.mat');
r=size(q.OOMMFData);
imagesc(q.OOMMFData(:,:,1,3))
colormap(jet)
colorbar
figure
quiver(q.OOMMFData(:,:,1,1),q.OOMMFData(:,:,1,2))
axis([0 100 0 100])
%%
%section for converting all the .mat files into bmps
convert=0;
if convert == 1
    for marker=0:499
        xx=load(['F:/MATLAB/OOMMFtomatlabconverters/duncans edited OOMMF converter/firstsetofdata/mat/',num2str(marker),'.omf.mat']);
        label=[num2str(marker),'.tif'];
        data1=xx.OOMMFData(:,:,1,3);
        imwrite(data1,label)
    end
end

%%
%This section is designed to load each file, find the x and y positions of
%the vortex core and then plot it as a function of time in a 3D graph. It
%dows this by first finding the maximum x value and then
x=zeros(100,100,500);
ypositions=zeros(500,1);
maxxvalue=zeros(500,1);

for filecount=1:500
    xpre=load(['F:/MATLAB/OOMMFtomatlabconverters/duncans edited OOMMF converter/firstsetofdata/mat/',num2str(filecount-1),'.omf.mat']);
    x(:,:,filecount)=xpre.OOMMFData(:,:,1,3);
    maxxvalue(filecount)=(max(max(abs(x(:,:,filecount)))));
    for x1=1:1:100
        for y1=1:1:100
            if abs(maxxvalue(filecount)) == abs(x(y1,x1,filecount))
                xpositions(filecount)=x1;
                ypositions(filecount)=y1;
            end
        end
    end
end
figure
% plot3(xpositions,ypositions)
% xlabel('x positions')
% ylabel('y positions')

t=(0:1:499).*0.05;

plot3(xpositions,ypositions,t')
xlabel('x positions')
ylabel('y positions')
zlabel('t (ns)')

N=2048;

ytrans=abs(fft(ypositions(160:500)-50.5,N));
xtrans=abs(fft(xpositions(160:500)-50.5,N));
freqresultonepixel = 2.*(abs(fft(xpositions(160:500),N)))./(length(xpositions(160:500)));

sampingfreq = 1/(50e-12);
frequencyvalues = ((sampingfreq)./(N)).*(0:((N/2)-1));
% 
figure
plot(frequencyvalues,ytrans(1:N/2),'k-')
xlabel('Frequency (Hz)')
ylabel('Amplitude')
title('FFT of y positions')
figure
plot(frequencyvalues,xtrans(1:N/2),'k-')
xlabel('Frequency (Hz)')
ylabel('Amplitude')
title('FFT of x positions')

