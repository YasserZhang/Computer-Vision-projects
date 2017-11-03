%load in data
teddyL = double(imread('teddy/teddyL.pgm'));
teddyR = double(imread('teddy/teddyR.pgm'));
ground_truth = double(imread('teddy/disp2.pgm'));
padded_teddyL = padarray(teddyL, [1 1]);
padded_teddyR = padarray(teddyR, [1 1]);
padded_ground = padarray(ground_truth, [1 1]);
mask_x = [-1 0 1; -1 0 1; -1 0 1];
gaussian = [1 4 7 4 1;
            4 16 26 16 4;
            7 26 41 26 7;
            4 16 26 16 4;
            1 4 7 4 1]/273;
alpha = 0.12;
threshold = 60000000;
teddyL_harris = harris_operator(padded_teddyL, mask_x, gaussian, alpha, threshold);
teddyR_harris = harris_operator(padded_teddyR, mask_x, gaussian, alpha, threshold);
% sum(sum(teddyL_harris > 0))
% sum(sum(teddyR_harris > 0))
% teddyL_harris = uint8(teddyL_harris);
% imshow(teddyL_harris)
[row_L, col_L] = find(teddyL_harris > 0);
[row_R, col_R] = find(teddyR_harris > 0);
axises_L = [row_L col_L];
axises_R = [row_R col_R];
[r, c] = size(row_L);
correct_set = zeros(20, 1);
incorrect_set = zeros(20, 1);
chosen_portion = 0.05;
for n = 1: 20
    correct = 0;
    incorrect = 0;
    for i = 1 : r
        h = axises_L(i, 1);
        w = axises_L(i, 2);
        sad_table = calculate_sad(h, w, padded_teddyL, axises_R, padded_teddyR);
        chosen_set = sad_table(1:round(r * chosen_portion), :);
        disparity = padded_ground(h, w)/4;
        %compare coordinates of candidate corners (in right image) with least sad values
        %against the true position in the right image matching the corner in the left image.
        %the true position can be found by adding the disparity obtained from
        %ground truth image to the coordinates of the target corner in the left
        %image.
        comparison = calculate_distance(h, w - disparity, chosen_set);
        correct = correct + sum(comparison <= sqrt(2));
        incorrect = incorrect + sum(comparison > sqrt(2));
    end
    correct_set(n) = correct;
    incorrect_set(n) = incorrect;
    chosen_portion = chosen_portion + 0.05;
end

result = [correct_set incorrect_set correct_set./(correct_set + incorrect_set)];
disp(result)