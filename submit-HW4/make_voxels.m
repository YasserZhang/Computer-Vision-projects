function [voxels] = make_voxels(xlim,ylim,zlim,N)
    volume = diff(xlim) * diff(ylim) * diff(zlim);
    voxels.resolution = power(volume/N, 1/3);
    x = xlim(1) : voxels.resolution : xlim(2);
    y = ylim(1) : voxels.resolution : ylim(2);
    z = zlim(1) : voxels.resolution : zlim(2);
    [X, Y, Z] = meshgrid(x, y, z);
    voxels.X = X(:);
    voxels.Y = Y(:);
    voxels.Z = Z(:);
    voxels.Value = ones(numel(X), 1);
    %voxels.R = zeros(numel(X), 1);
    %voxels.G = zeros(numel(X), 1);
    %voxels.B = zeros(numel(X), 1);
    
    