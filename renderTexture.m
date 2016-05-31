function [ opt, zbuffer] = renderTexture( src, zbuffer, model, light,cam_depth, ...
    deg, filename1, filename2)
if nargin <= 6
    filename1 = 'sample_name.PNG';
    filename2 = 'sample_face.jpg';
end
opt = src;
surf = model{1};
texture = imread(filename1);
[opt, zbuffer] = renderSurfT(opt, surf, zbuffer, ...
    light,cam_depth, deg, texture, 0.14,0.42,0.1,0.1);
texture = imread(filename2);
[opt, zbuffer] = renderSurfT(opt, surf, zbuffer, ...
    light,cam_depth, deg, texture, 0.26,0.4,0.075,0.18);
end
