#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Sun Feb  4 12:18:08 2018

@author: nz
"""


'''
steps in non-maximum suppression

after obtaining gradients and norms, and direction_indexes for each pixel,

1, stretch img, get height, width indexes
    for example, for a matrix [[1,2],[3,4]], its x, y indexes can be written as index_height = [0,0,1,1], index_width = [0,1,0,1] when it is streteched to be [1,2,3,4]
    as a result, we get index_height, index_width
    
2, use resulted indexes to fetch norms, and direction_indexes
    the results are both in the form of (1, n), where n is height*width

3, use direction_indexes to fetch delta_neighbors_indexes
    the results are in the form of (n, 2, 2)

4, get the indexes of neighbor1 and neighbor2 for each pixel
    and get corresponding norms for the neighbors

5, concatenate the norms of each pixels and its neighbors
    the results are in the form of (3, n)

6, calculate the maximum by column

7, compare the maximum row with original norms, resulting 1 in each entry if it is equal to maximum

8, element wise multiply norms with the resulted binary row from step 7.

9, reshape the result of 8 in the form of img for return

'''

from p2 import main2
import numpy as np
import cv2
'''
delta_neighbors_indexes = np.array([[[0,1],[0,-1]],[[-1,-1],[1,1]],
                              [[1,0],[-1,0]],[[-1, 1],[1, -1]],
                              [[0,1],[0,-1]],[[-1,-1],[1,1]],
                              [[1,0],[-1,0]],[[-1, 1],[1, -1]],
                              [[0,1],[0,-1]]
                              ])
'''
delta_neighbors_indexes = np.array([
        [[1,0],[-1,0]], [[-1,-1],[1,1]],
        [[0,1],[0,-1]], [[-1,1],[1,-1]],
        [[1,0],[-1,0]], [[-1,-1],[1,1]],
        [[0,1],[0,-1]], [[-1,1],[1,-1]],
        [[1,0],[-1,0]]
        ])

def get_direction_indexes(grad_ver, grad_hor):
    #the orientations of gradients are divided into 8 directions
    #i.e.,radius: 0, pi/4, pi/2, ..., up to 7pi/4 
    #      index: 0, 1,     2,   ...,        7
    '''
    return the index of the 8 directions for each pixel.
    for example, if a pixel is at orientation of 0, then its index is 0, and if it is at orientation of pi/4, then its index 1, if pi/2, index 2, etc.
    the resulted indexes are to be used to reference the neighbors_indexes, which decides for each pixel which two of its neighbors should be compared.
    '''
    thetas = np.arctan2(grad_ver, grad_hor)
    direction_indexes = (np.round(4*thetas/np.pi).astype(int) + 4)
    return direction_indexes

def get_gradients(filename, sigma, threshold = 20, channel = 0):
    hor_filter = np.array([[0,0,0],[1,0,-1],[0,0,0]])
    ver_filter = np.array([[0,1,0],[0,0,0],[0,-1,0]])
    grad_ver = main2(filename, sigma, sobel_filter = ver_filter, threshold = threshold, channel = channel)
    grad_hor = main2(filename, sigma, sobel_filter = hor_filter, threshold = threshold, channel = channel)
    return grad_ver, grad_hor

def img_to_index(img_shape):
    H,W = img_shape
    row = np.repeat(np.arange(H), W)
    col = np.tile(np.arange(W), H)
    return row, col

def get_norm(grad_ver, grad_hor):
    return np.sqrt(np.multiply(grad_ver,grad_ver) + np.multiply(grad_hor, grad_hor))

def get_neighbors_norms(norms, index_height, index_width, index_deltas, idx):
    height = index_height + index_deltas[:,idx,0]
    height[height < 0] = 0
    height[height >= norms.shape[0]] = norms.shape[0]-1
    width = index_width + index_deltas[:,idx,1]
    width[width < 0] = 0
    width[width >= norms.shape[1]] = norms.shape[1]-1
    neighbors_norms = norms[height, width]
    return neighbors_norms


def non_max_suppr(grad_ver, grad_hor, threshold = 15):
    #get 
    norms = get_norm(grad_ver, grad_hor)
    norms[norms < threshold] = 0
    direction_indexes = get_direction_indexes(grad_ver, grad_hor)
    print(np.unique(direction_indexes))
    #1, stretch img, get height, width indexes
    index_height, index_width = img_to_index(grad_ver.shape)
    #get valid indexes whose corresponding norms are nonzeros.
    stretched_norms = norms[index_height, index_width]
    index_height = index_height[stretched_norms > 0.01]
    index_width = index_width[stretched_norms > 0.01]
    print index_height.shape, index_width.shape
    #2, use resulted indexes to fetch norms, and direction_indexes
        #the results are both in the form of (1, n), where n is height*width
    stretched_norms = norms[index_height, index_width]
    stretched_directions = direction_indexes[index_height, index_width]
    #3, use direction_indexes to fetch delta_neighbors_indexes
        #the results are in the form of (n, 2, 2)
    stretched_deltas = delta_neighbors_indexes[stretched_directions]
    #4, get the indexes of neighbor1 and neighbor2 for each pixel
        #and get corresponding norms for the neighbors
    norms_neighbor0 = get_neighbors_norms(norms, index_height, index_width, stretched_deltas, 0)
    norms_neighbor1 = get_neighbors_norms(norms, index_height, index_width, stretched_deltas, 1)
    #5, concatenate the norms of each pixels and its neighbors
        #the results are in the form of (3, n)
    norms_to_cmp = np.concatenate((stretched_norms.reshape(1,-1), norms_neighbor0.reshape(1,-1), norms_neighbor1.reshape(1,-1)), axis = 0)
    #6, calculate the maximum by column and get argmax
    max_indexes = np.argmax(norms_to_cmp, axis = 0)
    #create a boolean array indicating if the targe pixel's norm is maximum among neighbors.
    #max_indexes = (cmp_indexes == 0).astype(int)
    #7, compare the maximum row with original norms, resulting 1 in each entry if it is equal to maximum
    index_height = index_height[max_indexes == 0]
    index_width = index_width[max_indexes == 0]
    print index_height.shape, index_width.shape
    new_norms = np.zeros_like(norms)
    new_norms[index_height, index_width] = norms[index_height, index_width]
    
    return new_norms

def main3(filename, sigma, threshold = 15, channel = 0):
    #implement canny edge detector
    #smooth img and calculate gradients
    grad_ver, grad_hor = get_gradients(filename, sigma, threshold = -1<<31, channel = channel)
    #calculate strength of gradients
    return non_max_suppr(grad_ver, grad_hor,threshold = threshold)

if __name__ == '__main__':
    names = ['kangaroo','plane', 'red']
    sigma = 1
    for name in names:
        filename = './cs558s18_hw1/'+name+'.pgm'
        img = main3(filename, sigma)
        #filtered_img2 = main2(filename, sigma, sobel_filter = None, threshold = 20)
        #filtered_img = filtered_img1 + filtered_img2
        cv2.imwrite('./p3_output/'+ name+'_norm_' + str(sigma)+'.jpg', img)

