function [xlim, ylim, zlim] = find_ranges(cameras)
    camera_positions = cat( 2, cameras.T);
    xlim = [min(camera_positions(1,:)), max(camera_positions(1,:))];
    ylim = [min(camera_positions(2,:)), max(camera_positions(2,:))];
    zlim = [min(camera_positions(3,:)), max(camera_positions(3,:))];
    
    range = 0.6 * sqrt( diff( xlim ).^2 + diff( ylim ).^2 );
    for ii=1:numel( cameras )
        viewpoint = cameras(ii).T - range * get_camera_direction( cameras(ii) );
        zlim(1) = min( zlim(1), viewpoint(3) );
        zlim(2) = max( zlim(2), viewpoint(3) );
    end
    
    xrange = diff(xlim);
    xlim = xlim + xrange / 5 * [1 -1];
    yrange = diff(ylim);
    ylim = ylim + yrange / 5 * [1 -1];