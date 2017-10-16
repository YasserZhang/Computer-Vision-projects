function [ranked] = rank_transform (image, k)
    [height, width] = size(image);
    center = floor(k/2);
    ranked = zeros(height, width);
    for h = 1 : height - k + 1
        for i = 1 : width - k + 1
            window = image(h : h + k - 1, i: i + k - 1);
            rank = sum(sum(window < window(center + 1, center + 1))) + 1;
            ranked(h + center, i + center) = rank;
        end
    end
end

