court = imread('basketball-court.ppm');
%by observation
%bottom left: [24 194], [192 209 217]; bl = [0 0]
%bottom right: [280 280], [129 134 164]; br = [500 0];
%top left: [249 51], [99 128 162]; tl = [0 940];
%top right: [404 74], [101 130 174]; tr = [940 500];
%in image it is (y, x)


%imshow(court);
% bl = [194 24 1]; br = [280 280 1]; tl = [51 249 1]; tr = [74 404 1];
% bl1 = [1 1 1]; br1 = [500 1 1]; tl1 = [1 940 1]; tr1 = [500 940 1];
x = [24 280 249 404];
y = [194 280 51 74];
xd = [1 1 940 940];
yd = [1 500 1 500];

npoints = 4;
A = zeros(2*npoints,9);
for i=1:npoints
    A(2*i-1, :)= [x(i) y(i) 1 0 0 0 -x(i)*xd(i) -xd(i)*y(i) -xd(i)];
    A(2*i, :)= [0 0 0 x(i) y(i) 1  -x(i)*yd(i) -yd(i)*y(i) -yd(i)];
end

%[U S V] = svd(A);
%solve the null space of A, we can get homography matrix
h = null(A);
H=[h(1) h(2) h(3)
   h(4) h(5) h(6)
   h(7) h(8) h(9)];

newImage = zeros(500, 940, 3);
court_size = size(court);
for y_i = 1 : court_size(1)
    for x_i = 1 : court_size(2)
        color = court(y_i, x_i, :);
        %disp("color: " + string(color));
        vec = [x_i, y_i, 1];
        new_vec = H*vec';
        size(new_vec);
        new_x = round(new_vec(1)/new_vec(3));
        new_y = round(new_vec(2)/new_vec(3));
        if new_x <= 950 && new_x > 0 && new_y > 0 && new_y <= 500
            %disp(new_x, new_y)
            newImage(new_y, new_x, 1) = color(1);
            newImage(new_y, new_x, 2) = color(2);
            newImage(new_y, new_x, 3) = color(3);
            %disp("new color: " + string(newIamge(new_y, new_x, :)))
        end
    end
end

%bilinear transformation
%evaluate a blank pixel's value by averaging the non-zero values from its
%closest eight neighbors
size = size(newImage);
for y_i = 2 : size(1)-1
    for x_i = 2 : size(2)-1
        if sum(newImage(y_i, x_i, :)) == 0
            %rgb chanels for the eight neighbors
            n_r = newImage([y_i-1, y_i, y_i+1], [x_i-1, x_i, x_i+1], 1);
            n_g = newImage([y_i-1, y_i, y_i+1], [x_i-1, x_i, x_i+1], 2);
            n_b = newImage([y_i-1, y_i, y_i+1], [x_i-1, x_i, x_i+1], 3);
            newImage(y_i, x_i, 1) = round(mean(nonzeros(n_r)));
            newImage(y_i, x_i, 2) = round(mean(nonzeros(n_g)));
            newImage(y_i, x_i, 3) = round(mean(nonzeros(n_b)));
        end
    end
end
%interpolating margina blank pixels
newImage(:, 1, :) = newImage(:, 2, :);
newImage(1, :, :) = newImage(2, :, :);
newImage(:, 940, :) = newImage(:, 939, :);
newImage(500, :, :) = newImage(499, :, :);
newImage = uint8(newImage);
imshow(newImage)
imwrite(newImage, 'output_court.png')