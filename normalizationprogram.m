%normalisation subroutine
clear all
close all
initnumberofimages = input('How many images do you want to load ');
disp('What is the prefix? (Eg files names along the lines')
filestyle = input(' S_A1_000.tiff will  have the prefix S_A1_) ','s');


for counter1 = 0:1:initnumberofimages-1
    
    
    
    if counter1 <= 9 && counter1 >=1
        
        imagestack(:,:,counter1+1) = im2double(imread([filestyle,'00',num2str(counter1),'.tif']));
        
    elseif counter1 <= 99 && counter1 >= 10
        
        imagestack(:,:,counter1+1) = im2double(imread([filestyle,'0',num2str(counter1),'.tif']));
        
    elseif counter1 == 0
        imagestack(:,:,counter1+1) = im2double((imread([filestyle,'000','.tif'])));
        
    else
        
        imagestack(:,:,counter1+1) = im2double(imread([filestyle,num2str(counter1),'.tif']));
        
    end
    
end



objectsize=size(imagestack);


for counter2=1:1:initnumberofimages
    largestvalue=max(max(imagestack(:,:,counter2)));
    for counter3=1:1:objectsize(2)
        for counter4=1:1:objectsize(1)
            
            if imagestack(counter4,counter3,counter2)==0
                thisimage(counter4,counter3)=0;
            else
                thisimage(counter4,counter3)=imagestack(counter4,counter3,counter2)./largestvalue;
            end
            
        end
        
    end
    
    if counter2-1 <= 9 && counter2-1 >= 1
        
        dlmwrite([filestyle,'00',num2str(counter2-1),'normalized.txt'],thisimage);
        
    elseif counter2-1 <= 99 && counter2-1 >= 10
        
        dlmwrite([filestyle,'0',num2str(counter2-1),'normalized.txt'],thisimage);
        
    elseif counter2-1 == 0
        dlmwrite([filestyle,'000','normalized.txt'],thisimage);
        
    else
        
        dlmwrite([filestyle,num2str(counter2),'normalized.txt'],thisimage);
    end
    
end

