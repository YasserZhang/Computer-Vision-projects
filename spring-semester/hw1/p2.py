#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Tue Jan 30 13:27:14 2018

@author: nz
"""

from p1 import main1, img_to_index, reflective_padding
import numpy as np
import cv2

def get_norm(grad_ver, grad_hor):
    return np.sqrt(np.multiply(grad_ver,grad_ver) + np.multiply(grad_hor, grad_hor))

def main2(filename, sigma, sobel_filter = None, threshold = 80, strides = 1, channel = 0):
    img = main1(filename, sigma, strides = strides, channel = channel)
    if sobel_filter is None:
        filter2d = np.array([[1,2,1],[0,0,0],[-1,-2,-1]])
    else:
        filter2d = sobel_filter
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
    filtered[filtered < threshold] = 0
    return filtered

if __name__ == '__main__':
    names = ['kangaroo','plane', 'red']
    sigma = 1
    for name in names:
        filename = './cs558s18_hw1/'+name+'.pgm'
        sobel_filter = np.array([[1,0,-1],[2,0,-2],[1,0,-1]]) #horizontal
        hor_filter = np.array([[0,0,0],[3,0,-3],[0,0,0]])
        ver_filter = np.array([[0,3,0],[0,0,0],[0,-3,0]])
        sobel_filter1 = np.array([[1,2,1],[0,0,0],[-1,-2,-1]]) #vertical
        grad_ver = main2(filename, sigma, sobel_filter = ver_filter, threshold = 25)
        grad_hor = main2(filename, sigma, sobel_filter = hor_filter, threshold = 25)
        grad_norm = get_norm(grad_ver, grad_hor)
        cv2.imwrite('./p2_output/'+ name+'_sobel_' + str(sigma)+'.jpg', grad_norm)