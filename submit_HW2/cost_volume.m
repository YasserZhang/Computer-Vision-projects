function [SAD] = cost_volume(imageL, imageR, depth, k)
    center = floor(k/2);
    [height, width] = size(imageL);
    height_size = height - k + 1;
    width_size = width - k + 1;
    SAD = zeros(height, width, depth + 1);
    SAD(:) = intmax('int32');
    for h = 1 : height_size
        for w = 1 : width_size 
            windowL = imageL(h : h + k - 1, w : w + k - 1);
            for d = 0 : depth
                windowR = imageR(h : h + k - 1, min(width_size, w + d) : min(width_size + k - 1, w + d + k - 1));
                sad = sum(sum(abs(windowL - windowR)));
                SAD(h + center, w + center, d + 1) = sad;
            end
        end
    end
end