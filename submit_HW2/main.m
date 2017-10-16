function [disp_map] = main(rankedL, rankedR, depth, agg_window_size)
    SAD = cost_volume(rankedL, rankedR, depth, agg_window_size);
    disp_map = find_depth(SAD);
end