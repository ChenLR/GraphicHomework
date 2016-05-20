function [ opt ] = rotateModel( model, angle, order )
mat(:,:,1) = [1 0 0 0;
    0 cosd(angle(1)) -sind(angle(1)) 0;
    0 sind(angle(1)) cosd(angle(1)) 0;
    0 0 0 1];
mat(:,:,2) = [cosd(angle(2)) 0 sind(angle(2)) 0;
    0 1 0 0;
    -sind(angle(2)) 0 cosd(angle(2)) 0;
    0 0 0 1];
mat(:,:,3) = [cosd(angle(3)) -sind(angle(3)) 0 0;
    sind(angle(3)) cosd(angle(3)) 0 0;
    0 0 1 0;
    0 0 0 1];
rotate = mat(:,:,order(3)) * mat(:,:,order(2)) * mat(:,:,order(1));
opt = model;
for i = 1:length(model)
    surf = model{i};
    surf = permute(surf, [3 2 1]);
    [~, ~, depth] = size(surf);
    for j = 1:depth
        surf(:,:,j) = rotate * surf(:,:,j);
    end
    surf = permute(surf, [3 2 1]);
    opt{i} = surf;
end
end
