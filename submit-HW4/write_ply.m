% file = fopen('testply.ply', 'w');
% fprintf(file, 'ply\n');
% num_vertices = numel(pc(:,1));
% fprintf(file, 'format ascii 1.0\n');
% fprintf(file, 'element vertex %d\n', num_vertices);
% fprintf(file, 'property float x\n');
% fprintf(file, 'property float y\n');
% fprintf(file, 'property float z\n');
% fprintf(file, 'property uchar red\n');
% fprintf(file, 'property uchar green\n');
% fprintf(file, 'property uchar blue\n');
% fprintf(file, 'element face 0\n');
% fprintf(file, 'end_header\n');
% dlmwrite(file, pc,'delimiter',' ');
% fclose();
% fprintf(file, '%f %f %f %u %u %u\n', pc(:, 1), pc(:, 2), pc(:, 3), pc(:, 4), pc(:, 5), pc(:, 6));

function write_ply(fname, P, C)
% Written by Chenxi cxliu@ucla.edu
% Input: fname: output file name, e.g. 'data.ply'
%        P: 3*m matrix with the rows indicating X, Y, Z
%        C: 3*m matrix with the rows indicating R, G, B

num = size(P, 1);
header = 'ply\n';
header = [header, 'format ascii 1.0\n'];
header = [header, 'element vertex ', num2str(num), '\n'];
header = [header, 'property float x\n'];
header = [header, 'property float y\n'];
header = [header, 'property float z\n'];
header = [header, 'property uchar red\n'];
header = [header, 'property uchar green\n'];
header = [header, 'property uchar blue\n'];
header = [header, 'end_header\n'];

data = [P, double(C)];

fid = fopen(fname, 'w');
fprintf(fid, header);
dlmwrite(fname, data, '-append', 'delimiter', ' ', 'precision', 3);
fclose(fid);