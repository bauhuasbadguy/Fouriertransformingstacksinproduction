#python script for generating test pieces to test stack fft tools
import numpy as np
from PIL import Image
import matplotlib.pyplot as plt
import math

def write_to_region(base, region_value, region_dims):

    region_dims[:] = [int(x) for x in region_dims]

    area = np.zeros((region_dims[1]-region_dims[0], region_dims[3]-region_dims[2]))
    area[area == 0] = abs(region_value)

    if region_value < 0:
        base_image[region_dims[0]:region_dims[1], region_dims[2]:region_dims[3], 0] = area
    elif region_value > 0:
        base_image[region_dims[0]:region_dims[1], region_dims[2]:region_dims[3], 2] = area
    
    
    return base_image
###################################
### End of function definitions ###
###################################

time_step = 0.1
frames = 500

base_width = 100
base_height = 100

output_folder = './test_piece/'

[ts, r0, r1, r2, r3] = [[], [], [], [], []]

[f0, f1, f2, f3] = [(2* math.pi)/5, (2* math.pi)/7, (2* math.pi)/13, (2* math.pi)/17]

[p0, p1, p2, p3] = [0, 0, 0, 0]

print('generating frames')
for i in range(frames):

    base_image = np.zeros((base_width, base_height, 3))

    #calculate the values in each region
    region0 = np.sin((f0 * time_step * i) + p0)
    region1 = np.sin((f1 * time_step * i) + p1)
    region2 = np.sin((f2 * time_step * i) + p2)
    region3 = np.sin((f3 * time_step * i) + p3)

    #save the values of the regions in 1D
    ts.append(time_step * i)
    r0.append(region0)
    r1.append(region1)
    r2.append(region2)
    r3.append(region3)

    #write to region 0 (top left)
    base_image = write_to_region(base_image, region0, [0, base_width/2, 0, base_height/2])

    #write to region 1 (bottom left)
    base_image = write_to_region(base_image, region1, [0, base_width/2, base_height/2, base_height])

    #write to region 2 (top right)
    base_image = write_to_region(base_image, region2, [base_width/2, base_width, 0, base_height/2])

    #write to region 3 (top right)
    base_image = write_to_region(base_image, region3, [base_width/2, base_width, base_height/2, base_height])

    base_image = base_image * 255

    base_image = base_image.astype('uint8')

    im = Image.fromarray(base_image)

    target_length = 5

    num_len = len(str(i))

    if num_len < target_length:

        out_string = '0'* (target_length - num_len)
        out_string += str(i)


    im.save(output_folder + out_string + '.bmp', 'BMP')

plt.figure()
plt.plot(ts, r0, 'b-', label='r0')
plt.plot(ts, r1, 'k-', label='r1')
plt.plot(ts, r2, 'r-', label='r2')
plt.plot(ts, r3, 'c-', label='r3')
plt.xlabel('t')
plt.ylabel('amplitude')
plt.show()