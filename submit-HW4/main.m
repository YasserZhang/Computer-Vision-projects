%load in images and silhouettes
cameras = load_data();
%show all images
montage( cat( 4, cameras.Image ) );

%find x, y, z ranges according to sihlouettes
[xlim, ylim, zlim] = find_ranges(cameras);
%initialize a voxel volume
voxels = make_voxels(xlim, ylim, zlim, 100000000);
%space carve voxels
for ii=1:numel(cameras)
    voxels = carve( voxels, cameras(ii) );
end

[vertices, colors] = find_surface_colors(cameras, voxels);
colors = int8(colors.*2);
write_ply('dancer.ply', vertices, colors);


    
    