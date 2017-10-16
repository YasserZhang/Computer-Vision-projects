teddyL = imread('teddyL.pgm');
teddyR = imread('teddyR.pgm');
%ground truth
ground = imread('disp2.pgm');
ground = double(ground);
ground = ground/4.0;
[g_height, g_width] = size(ground);

rank_window_size = 5;
rankedL = rank_transform(teddyL, rank_window_size);
rankedL = fliplr(rankedL);
rankedR = rank_transform(teddyR, rank_window_size);
rankedR = fliplr(rankedR);
depth = 63;

%disparity map with 15 x 15 cost aggregation window
agg_window_size = 15;
%create disparity map
disp_map15 = main(rankedL, rankedR, depth, agg_window_size);
disp_map15 = fliplr(disp_map15);
%calcualte error rate
error_rate15 = sum(sum(abs(ground - disp_map15) > 1))/(g_height*g_width);
%convert to image
disp_map15 = convert_image(disp_map15, depth);
%imwrite(disp_map15, 'disp_map15.jpg')



%disparity map with 3 x 3 cost aggregation window
agg_window_size = 3;
SAD = cost_volume(rankedL, rankedR, depth, agg_window_size);
disp_map = find_depth(SAD);
disp_map = fliplr(disp_map);
%calcualte error rate
error_rate3 = sum(sum(abs(ground - disp_map) > 1))/(g_height*g_width);
%convert to image
disp_map3 = convert_image(disp_map, depth);
%imwrite(disp_map3, 'disp_map3.jpg')


%part 2
%count valid pixels whose prkn are larger than median
prkn = PRKN(SAD);
median_value = median(prkn(:), 'omitnan');
new_disp = zeros(g_height, g_width);
for h = 1 : g_height
    for w = 1 : g_width
        if (prkn(h, w) > median_value)
            new_disp(h, w) = disp_map(h, w);
        end
    end
end
%count total and error pixels
total_pixel = 0;
error_pixel = 0;
for h = 1 : g_height
    for w = 1 : g_width
        if (new_disp(h, w) > 0)
            total_pixel = total_pixel + 1;
            if (abs(new_disp(h, w) - ground(h, w)) > 1)
                error_pixel = error_pixel + 1;
            end
        end
    end
end

error_rate_prkn = error_pixel / total_pixel;
disp_map_conf = convert_image(new_disp, depth);
imshow(disp_map_conf)
%imwrite(disp_map_conf, 'disp_map_50%_conf.jpg')
