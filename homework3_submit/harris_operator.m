function [image_copy] = harris_operator(image, mask_x, gaussian, alpha, threshold)
    [height, width] = size(image);
    mask_y = mask_x';
    image_copy = image;
    %initialize partial direvative matrix
    %I_x = zeros(size(image));
    I_x = image;
    %I_y = zeros(size(image));
    I_y = image;
    %partial derivatives
    for h = 2 : height - 3 % 3 is the size of mask window
        for w = 2 : width - 3
            window = image(h : h + 2, w : w + 2);
            d_x = sum(sum(window .* mask_x));
            d_y = sum(sum(window .* mask_y));
            I_x(h + 1, w + 1) = d_x;
            I_y(h + 1, w + 1) = d_y;
        end
    end
    %second moment matrix
    I_x2 = I_x.^2;
    I_y2 = I_y.^2;
    I_xy = I_x .* I_y;
    %gaussian smooth
    I_x2 = gaussian_smooth(I_x2, gaussian);
    I_y2 = gaussian_smooth(I_y2, gaussian);
    I_xy = gaussian_smooth(I_xy, gaussian);
    %harris R function
    harris_R = (I_x2 .* I_y2 - I_xy .* I_xy) - alpha * (I_x2 + I_y2).^2;
    image_copy(harris_R < threshold) = 0;
    %non-maximum suppression
    for h = 1 : height - 2 % 3 is the size of mask window
        for w = 1 : width - 2
            window = image_copy(h : h + 2, w : w + 2);
            if (window(2, 2) ~= 0 && window(2, 2) ~= max(window(:)))
                image_copy(h + 1, w + 1) = 0;
            end
        end
    end 
end