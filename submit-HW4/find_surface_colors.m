function [vertices, colors] = find_surface_colors(cameras, voxels)
    % First grid the data
    ux = unique(voxels.X);
    uy = unique(voxels.Y);
    uz = unique(voxels.Z);
    
    % Expand the model by one step in each direction
    ux = [ux(1)-voxels.resolution; ux; ux(end)+voxels.resolution];
    uy = [uy(1)-voxels.resolution; uy; uy(end)+voxels.resolution];
    uz = [uz(1)-voxels.resolution; uz; uz(end)+voxels.resolution];
    % Convert to a grid
    [X,Y,Z] = meshgrid( ux, uy, uz );
    V = zeros( size( X ) );
    N = numel( voxels.X );
    for ii=1:N
        ix = (ux == voxels.X(ii));
        iy = (uy == voxels.Y(ii));
        iz = (uz == voxels.Z(ii));
        V(iy,ix,iz) = voxels.Value(ii);
    end
    
    ptch = isosurface( X, Y, Z, V, 0.5 );
    vertices = ptch.vertices;
    normals = isonormals( X, Y, Z, V, vertices );
    %vertices = get(patch, 'Vertices');
    %normals = get(patch, 'VertexNormals');
    num_vertices = size( vertices, 1 );
    num_cameras = numel(cameras);
    cam_normals = zeros(3, num_cameras);
    for ii = 1 : num_cameras
        cam_normals(:, ii) = get_camera_direction( cameras(ii) );
    end
    
    % For each vertex, use the normal to find the best camera and then lookup
    % the value.
    colors = zeros( num_vertices, 3 );
    for ii=1 : num_vertices
        % Use the dot product to find the best camera
        angles = normals(ii,:)*cam_normals./norm(normals(ii,:));
        [~,cam_idx] = min( angles );
        % Now project the vertex into the chosen camera
        [imx,imy] = project( cameras(cam_idx), ...
            vertices(ii,1), vertices(ii,2), vertices(ii,3) );
    colors(ii,:) = cameras(cam_idx).Image( round(imy), round(imx), : );
    end
    
    
end