function [p_light] = lightPoint(surf,light,cam_depth)
[m, n, ~] = size(surf);
p_light = zeros(m,n); % 光强控制点
% 生成光强控制点
for j_ = 1:m - 1
    for k_ = 1:n - 1
        P = [surf(j_, k_, 1) surf(j_, k_, 2) surf(j_, k_, 3);
            surf(j_+1, k_, 1) surf(j_+1, k_, 2) surf(j_+1, k_, 3);
            surf(j_,k_+1,1) surf(j_,k_+1,2) surf(j_,k_+1,3)];
        p_light(j_, k_) = p_light(j_, k_) + phong(P, cam_depth, light);
    end
end

for j_ = 2:m
    for k_ = 1:n - 1
        P = [surf(j_, k_, 1) surf(j_, k_, 2) surf(j_, k_, 3);
            surf(j_-1, k_, 1) surf(j_-1, k_, 2) surf(j_-1, k_, 3);
            surf(j_,k_+1,1) surf(j_,k_+1,2) surf(j_,k_+1,3)];
        p_light(j_, k_) = p_light(j_, k_) + phong(P, cam_depth, light);
    end
end

for j_ = 2:m
    for k_ = 2:n
        P = [surf(j_, k_, 1) surf(j_, k_, 2) surf(j_, k_, 3);
            surf(j_-1, k_, 1) surf(j_-1, k_, 2) surf(j_-1, k_, 3);
            surf(j_,k_-1,1) surf(j_,k_-1,2) surf(j_,k_-1,3)];
        p_light(j_, k_) = p_light(j_, k_) + phong(P, cam_depth, light);
    end
end

for j_ = 1:m - 1
    for k_ = 2:n
        P = [surf(j_, k_, 1) surf(j_, k_, 2) surf(j_, k_, 3);
            surf(j_+1, k_, 1) surf(j_+1, k_, 2) surf(j_+1, k_, 3);
            surf(j_,k_-1,1) surf(j_,k_-1,2) surf(j_,k_-1,3)];
        p_light(j_, k_) = p_light(j_, k_) + phong(P, cam_depth, light);
    end
end

p_light(2:m - 1,:) = p_light(2:m - 1,:) / 2;
p_light(:,2:n - 1) = p_light(:,2:n - 1) / 2;
end

