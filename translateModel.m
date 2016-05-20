function [ opt ] = translateModel( model, dist)
translate = [1 0 0 dist(1);
    0 1 0 dist(2);
    0 0 1 dist(3);
    0 0 0 1];
opt = model;
for i = 1:length(model)
    surf = model{i};
    surf = permute(surf, [3 2 1]);
    [~, ~, depth] = size(surf);
    for j = 1:depth
        surf(:,:,j) = translate * surf(:,:,j);
    end
    surf = permute(surf, [3 2 1]);
    opt{i} = surf;
end
end
