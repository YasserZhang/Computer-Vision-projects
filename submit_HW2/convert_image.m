function [disp_map] = convert_image(disp_image, depth)
    disp_map = uint8(round(disp_image/depth * 255));
end