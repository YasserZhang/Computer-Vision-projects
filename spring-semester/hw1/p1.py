    #!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Mon Jan 29 15:04:32 2018

@author: nz
"""
import numpy as np
import cv2
#take advantage of matrix multiplication to implement convolution
#given an image (H,W,D), filter(height, width), padding, and strides
#first pad the image

def img_to_index(image_shape, filter_shape, padding = 1, strides = 1):
    H,W = image_shape
    filter_height = filter_shape[0]
    filter_width = filter_shape[1]
    #resulted height and width of the image after covolution
    out_height = (H + 2*padding - filter_height)/strides + 1
    out_width = (W + 2*padding - filter_width)/strides + 1
    
    #get row index
    row0 = np.repeat(np.arange(filter_height),filter_width)
    row1 = np.repeat(np.arange(out_height), out_width) * strides
    rows = row0.reshape(-1, 1) + row1.reshape(1, -1)
    
    #get column index
    col0 = np.tile(np.arange(filter_width), filter_height)
    col1 = np.tile(np.arange(out_width), out_height) * strides
    cols = col0.reshape(-1,1) + col1.reshape(1,-1)
    
    return rows, cols

#filter_map = np.array([[[-1,0,1],[0,1,0],[-1,0,-1]],[[-1,0,1],[0,1,0],[-1,0,-1]],[[-1,0,1],[0,1,0],[-1,0,-1]]])
#stretched_filter = filter_map.reshape(1,-1)
#result = stretched_filter.dot(stretched_img)

def gaussian_filter(sigma):
    x = np.linspace(-2*sigma, 2*sigma, 4*sigma + 1)
    filter1d = np.exp((-x*x/sigma**2)/2.0)/(np.sqrt(np.pi*2)*sigma)
    filter1d = filter1d/sum(filter1d)
    filter1d = filter1d.reshape(-1,1)
    return filter1d * filter1d.T

def reflective_padding(img, padding):
    #pad top
    top = img[:padding,:][::-1,:]
    #pad bottom
    bottom = img[-padding:,:][::-1,:]
    img = np.concatenate((top, img, bottom), axis = 0)
    #pad left
    left = img[:,:padding][:,::-1]
    #pad right
    right = img[:,-padding:][:,::-1]
    img = np.concatenate((left, img, right), axis = 1)
    return img

def main1(filename, sigma, strides = 1, channel = None):
    #load image
    if channel is not None:  #it means the image is grayscale
        img = cv2.imread(filename, channel)
    else:
        img = cv2.imread(filename, channel)
    filter2d = gaussian_filter(sigma)
    padding = filter2d.shape[0]/2
    #padding image
    padded_img = reflective_padding(img, padding)
    #get image index for stretching it
    i, j = img_to_index(img.shape, filter2d.shape, padding = padding, strides = strides)
    #stretch the image
    flatten_img = padded_img[i, j]
    #stretch the filter matrix
    flatten_filter = filter2d.reshape(1, -1)
    #apply convolution to the image and reshape it.
    filtered = flatten_filter.dot(flatten_img).reshape(img.shape)
    return filtered

if __name__ == '__main__':
    strides = 1
    names = ['kangaroo','plane', 'red']
    for name in names:
        filename = './cs558s18_hw1/'+name + '.pgm'
        for i in [1,10]:#range(1, 11):
            print 'filtering img '+ str(i)
            sigma = i
            filtered_img = main1(filename, sigma, strides = strides, channel = 0)
            #opencv is way faster than my custom method!!!
            #img = cv2.imread(filename, 0)
            #filtered_img = cv2.GaussianBlur(img, (sigma*4+1, sigma*4+1), sigma)
            cv2.imwrite('./p1_output/'+name + '_sigma_' + str(i)+'.jpg', filtered_img)
