function [ opt ] = projection( model, depth)
surf_num = length(model);
opt = model;
for surf_i = 1:surf_num
    surf = model{surf_i};
    [h, w, d] = size(surf);
    if d ~= 4
        surf(:,:,4) = ones(h,w);
    end
    surf = permute(surf, [3 2 1]);
    view = zeros(d, w, h);
    A = [1 0 0 0;
        0 1 0 0;
        0 0 0 0;
        0 0 -1/depth 1];
    for i = 1:h
        view(:,:,i) = A * surf(:,:,i);
    end;
    view = permute(view, [3 2 1]);
    view(:,:,1) = view(:,:,1)./view(:,:,4);
    view(:,:,2) = view(:,:,2)./view(:,:,4);
    opt{surf_i} = view;
end
end