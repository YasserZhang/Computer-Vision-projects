function dirn = get_camera_direction( camera )
    x = [size(camera.Image, 2) / 2
        size(camera.Image, 1) / 2
        1.0];
    X = camera.K \ x;
    X = camera.R' * X;
    dirn = X ./ norm(X);