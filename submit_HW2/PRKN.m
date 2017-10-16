function prkn = PRKN(SAD)
    [height, width, depth] = size(SAD);
    prkn = zeros(height, width);
    for h = 1 : height
        for w = 1 : width
            column = SAD(h, w, :);
            [min_value, index] = min(column);
            second_min = min(column([1:index-1, index+1:depth]));
            prkn(h, w) = second_min/min_value;
        end
    end
end