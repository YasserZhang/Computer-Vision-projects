function [distances] = calculate_distance(y_l, x_l, sad_set)
    %output: vector of distances between target position and positions of
    %candidates
    distances = sqrt((x_l - sad_set(:, 3)).^2 + (y_l - sad_set(:, 2)).^2);
end 