function [copy] = gaussian_smooth(image, gaussian)    
    %gaussian smoothing
    [height, width] = size(image);
    copy = image;
    for h = 1 : height - 4 % 5 is the size of Gaussian smooth window
        for w = 1 : width - 4
            window = image(h : h + 4, w : w + 4);
            g_x = sum(sum(window .* gaussian));
            copy(h + 2, w + 2) = g_x;
        end
    end
end