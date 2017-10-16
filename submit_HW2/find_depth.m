function [disp_image] = find_depth(SAD)
    [height, width, depth] = size(SAD);
    disp_image = zeros(height, width);
    for h = 1 : height
        for w = 1 : width
            [min_sad, index] = min(SAD(h, w, :));
            disp_image(h, w) = index - 1;
        end
    end
end