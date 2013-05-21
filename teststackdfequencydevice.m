%A program to make a stack of .tiff files represesenting 4 square objects
%in which the intensity of the image is oscilating in time with a seperate
%set of frequencies for each object
%Stuart Bowe

clear all;
close all;

t = linspace(0,1,51);


A1=5;
A2=5;
A3=5;
A4=5;
A5=5;
A6=5;
A7=5;
A8=5;

f1=5;
f2=6;
f3=7;
f4=8;
f5=9;
f6=10;
f7=11;
f8=12;

T=t(2)-t(1);
Fs=1./T;
Fnyquist=Fs./2;

x1 = (A1.*cos(2.*pi.*f1.*t))+(A2.*sin(2.*pi.*f2.*t));
x2 = (A3.*cos(2.*pi.*f3.*t))+(A4.*sin(2.*pi.*f4.*t));
x3 = (A1.*cos(2.*pi.*f5.*t))+(A6.*sin(2.*pi.*f6.*t));
x4 = (A7.*cos(2.*pi.*f7.*t))+(A8.*sin(2.*pi.*f8.*t));

massivematrix=zeros(64,64,51);

for n=1:1:32
    for n1=1:1:32
    
    massivematrix(n,n1,:) = x1;
    
    end
end

for n2=1:1:32
    for n3=33:64
        
        massivematrix(n2,n3,:) = x2;
        massivematrix(n3,n2,:) = x3;
        
    end
end


for n4=33:64
    for n5=33:64
    
    massivematrix(n4,n5,:) = x4;
    
    end
end

for n5=1:1:51
    
    file=massivematrix(:,:,n5);
    
    
    if n5 >= 0 && n5 <= 10
        
        filename=['testpiece00',num2str(n5-1),'.tif'];
        
    elseif n5 >= 11 && n5 <= 100 
    
    filename=['testpiece0',num2str(n5-1),'.tif'];
    
    else
        
    filename=['testpiece',num2str(n5-1),'.tif'];
    
    
    end

    imwrite(file,filename)
    
end
    
dlmwrite('testimestamps.txt',t)