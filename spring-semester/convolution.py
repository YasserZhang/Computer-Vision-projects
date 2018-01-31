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

def get_gaussian_filter(k_size, sigma):
    x = cv2.getGaussianKernel(k_size, sigma)
    return x * x.T

#filter_type: gaussian
def main(filename, a_filter, padding = 1, strides = 1, padding_set = ((1, 1),(1, 1)),channel = None):
    #load image
    if channel is not None:  #it means the image is grayscale
        img = cv2.imread(filename, channel)
    else:
        img = cv2.imread(filename, channel)
    #padding image
    padded_img = np.pad(img, padding_set, mode = 'constant')
    #get image index for stretching it
    i, j = img_to_index(img.shape, a_filter.shape, padding = padding, strides = strides)
    #stretch the image
    flatten_img = padded_img[i, j]
    #stretch the filter matrix
    flatten_filter = a_filter.reshape(1, -1)
    #apply convolution to the image and reshape it.
    filtered = flatten_filter.dot(flatten_img).reshape(img.shape)
    return filtered

if __name__ == '__main__':
    filename = './cs558s18_hw1/kangaroo.pgm'
    k_size = 5
    sigma = 10
    padding = 2
    strides = 1
    
    for i in range(1, 11):
        sigma = i
        a_filter = get_gaussian_filter(k_size, sigma)
        filtered_img = main(filename, a_filter, padding, strides,
                        padding_set = ((padding, padding),(padding, padding)), channel = 0)
        cv2.imwrite('kangaroo_kernel_5_sigma_' + str(i)+'.jpg', filtered_img)
