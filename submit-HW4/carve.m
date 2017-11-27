function [voxels, keep] = carve( voxels, camera )
    [im_x, im_y] = project(camera, voxels.X, voxels.Y, voxels.Z);
    [h, w, d] = size(camera.Image);
    %clear points out of the image
    keep = find((im_x >= 1) & (im_x <= w) & (im_y >= 1) & (im_y <= h));
    im_x = im_x(keep);
    im_y = im_y(keep);
    
    index = sub2ind( [h, w], round(im_y), round(im_x));
    keep = keep(camera.Silhouette(index) >= 1);
    
    voxels.X = voxels.X(keep);
    voxels.Y = voxels.Y(keep);
    voxels.Z = voxels.Z(keep);
    voxels.Value = voxels.Value(keep);
    