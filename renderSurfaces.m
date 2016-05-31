function [ opt, zbuffer] = renderSurfaces( src, model, light,cam_depth, ...
    deg)
[height, width, ~] = size(src);
opt = src;
zbuffer = ones(height, width);
surf_num = length(model);
for i_surf = 1:surf_num
    surf = model{i_surf};
    [opt, zbuffer] = renderSurf(opt, surf, zbuffer, light,cam_depth, deg);
end
end
