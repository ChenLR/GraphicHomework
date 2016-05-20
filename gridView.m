function [opt] = gridView(src, model, depth, deg)
[height, width] = size(src);
opt = src;
plane = projection(model,depth);
for surf_i = 1:length(model)
    view = plane{surf_i};
    view = view * width / (2 * depth * tand(deg / 2));
    view(:,:,1) = view(:,:,1) + width / 2;
    view(:,:,2) = view(:,:,2) + height / 2;
    [m, n, ~] = size(view);
    for i = 1:m
        for j = 1:(n - 1)
            opt = bresLine(opt, view(i, j, :), view(i, j + 1, :));
        end
    end
    for i = 1:(m - 1)
        for j = 1:n;
            opt = bresLine(opt, view(i, j, :), view(i + 1, j, :));
        end
    end
    for i = 1:(m - 1)
        for j = 1:(n - 1);
            %opt = bresLine(opt, view(i, j, :), view(i + 1, j + 1, :));
        end
    end
end
end

