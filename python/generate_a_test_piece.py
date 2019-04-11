#python script for generating test pieces to test stack fft tools
import numpy as np
from PIL import Image
import matplotlib.pyplot as plt
import math

time_step = 0.1
frames = 500

base_width = 500
base_height = 500

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

    #build the test piece image
    if region0 < 0:
        np.put(base_image, [0:base_width/2], [0:base_height/2], [0], abs(region0))
    elif region0 > 0:
        np.put(base_image, [0:base_width/2], [0:base_height/2], [0], abs(region0))
    '''
    if region1 < 0:

        base_image[0:base_width/2, base_height/2:base_height, 0] = abs(region1)
    elif region1 > 0:
        base_image[0:base_width/2, base_height/2:base_height, 2] = abs(region1)

    if region2 < 0:
        base_image[base_width/2:base_width, 0:base_height/2, 0] = abs(region2)
    elif region2 > 0:
        base_image[base_width/2:base_width, 0:base_height/2, 2] = abs(region2)

    if region3 < 0:
        base_image[base_width/2:base_width, base_height/2:base_height, 0] = abs(region3)

    elif region3 > 0:
        base_image[base_width/2:base_width, base_height/2:base_height, 2] = abs(region3)
    '''
    base_image = base_image * 255

    base_image = base_image.astype('uint8')

    print(base_image)
    print(np.shape(base_image))
    print(np.max(base_image))
    print(np.min(base_image))

    im = Image.fromarray(base_image)

    im.save(output_folder + str(i) + '.png', 'PNG')

plt.figure()
plt.plot(ts, r0, 'b-', label='r0')
plt.plot(ts, r1, 'k-', label='r1')
plt.plot(ts, r2, 'r-', label='r2')
plt.plot(ts, r3, 'c-', label='r3')
plt.xlabel('t')
plt.ylabel('amplitude')
plt.show()