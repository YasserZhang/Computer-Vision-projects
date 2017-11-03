function [sad_table] = calculate_sad(h, w, self_image, target_axises,  target_image)
    %initialize output
    [rows, cols] = size(target_axises);
    self_window = self_image(h - 1 : h + 1, w - 1 : w + 1);
    sad_table = zeros(rows, 3);
    for i = 1 : rows
        t_h = target_axises(i, 1);
        t_w = target_axises(i, 2);
        target_window = target_image(t_h - 1 : t_h + 1, t_w - 1 : t_w + 1);
        sad = sum(sum(abs(self_window - target_window)));
        sad_table(i, :) = [sad t_h t_w];
    end
    sad_table = sortrows(sad_table);
end