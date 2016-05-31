function [ opt ] = renderTexture( src, model, light,cam_depth, deg, text)
[height, width] = size(src);
opt = src;
plane = projection(model, cam_depth);
depth = ones(height, width);
surf_num = length(model);
x_base = 0.39; % 向下
y_base = 0.2; %顺时针旋转
x_scaler = 1000;
y_scaler = 1300;
text = text / max(max(text));
text = text';
[y_limit, x_limit] = size(text);
for i_surf = 1:surf_num
    surf = model{i_surf};
    view = plane{i_surf};
    view = view * width / (2 * cam_depth * tand(deg / 2));
    view(:,:,1) = view(:,:,1) + width / 2;
    view(:,:,2) = view(:,:,2) + height / 2;
    [m, n, ~] = size(surf);
    p_light = lightPoint(surf,light,cam_depth); % 光强控制点
    for j_ = 1:m - 1
        for k_ = 1:n - 1
            VP = [view(j_, k_, 1) view(j_, k_, 2);
                view(j_+1, k_, 1) view(j_+1, k_, 2);
                view(j_+1,k_+1,1) view(j_+1,k_+1,2);
                view(j_,k_+1,1) view(j_,k_+1,2)];
            SP =  [surf(j_, k_, 1) surf(j_, k_, 2) surf(j_, k_, 3);
                surf(j_+1, k_, 1) surf(j_+1, k_, 2) surf(j_+1, k_, 3);
                surf(j_+1,k_+1,1) surf(j_+1,k_+1,2) surf(j_,k_+1,3);
                surf(j_,k_+1,1) surf(j_,k_+1,2) surf(j_,k_+1,3)];
            PI = [p_light(j_, k_, 1);
                p_light(j_+1, k_, 1);
                p_light(j_+1,k_+1,1);
                p_light(j_,k_+1,1)];
            polyFill(VP(:,1),VP(:,2),SP,PI);
        end
    end
end
opt(opt < 0) = 0;

    function polyFill(Pxd, Pyd,SP,PI)
        
        Px = round(Pxd(:));
        Py = round(Pyd(:));
        point_num = length(Px);
        allLine = [Px Py];
        allLine(2:point_num,3) = Px(1:point_num - 1);
        allLine(1,3) = Px(point_num);
        allLine(2:point_num,4) = Py(1:point_num - 1);
        allLine(1,4) = Py(point_num);
        for i = 1:point_num
            if allLine(i, 2) > allLine(i, 4)
                buff = allLine(i, 1);
                allLine(i, 1) = allLine(i, 3);
                allLine(i, 3) = buff;
                buff = allLine(i, 4);
                allLine(i, 4) = allLine(i, 2);
                allLine(i, 2) = buff;
            end
        end
        y_max = max(allLine(:,4));
        y_min = min(allLine(:,2));
        dy = y_max - y_min;
        net = cell(1, dy);
        % create NET
        for i = 1:point_num
            if allLine(i, 2) == allLine(i, 4) % dy == 0 直线水平
                if allLine(i, 2) == y_min % 直线在最低边上
                    for x = min(allLine(i, 1), allLine(i, 3)):...
                            max(allLine(i, 1), allLine(i, 3));
                        if isQualified([x y_min])
                            [u,v] = interpolation( [x y_min], Pxd, Pyd);
                            matrix = [(1 - u)*(1 - v) (u)*(1 - v) ...
                                (u)*(v) (1 - u)*(v)];
                            I = real(matrix*PI);
                            if isnan(I)
                                
                            end
                            if i_surf == 1
                                %原图坐标
                                origin_x = ((j_ + u)/m - x_base)*x_scaler;
                                origin_y = ((k_ + v)/n - y_base)*y_scaler;
                                origin_x = round(origin_x);
                                origin_y = round(origin_y);
                                if origin_x > 0 && origin_x <= x_limit ...
                                        && origin_y > 0 && ...
                                        origin_y <= y_limit;
                                    I = I * text(y_limit+1 - origin_y, ...
                                        origin_x);
                                end
                            end                               
                            center = real(matrix*SP);
                            dep = 1 - exp(-norm(center - [0 0 cam_depth]));
                            if dep <= depth(height + 1 - y_min, x)
                                depth(height + 1 - y_min, x) = dep;
                                opt(height + 1 - y_min, x) = I;
                            end
                        end
                    end
                end
                continue
            end
            x_line = allLine(i, 1);
            dx = (allLine(i, 1) - allLine(i, 3)) / ...
                (allLine(i, 2) - allLine(i, 4));
            ymax = allLine(i, 4); % 该直线的y最大值
            ymin = allLine(i, 2);
            net{y_max - ymin} = [net{y_max - ymin}; x_line dx ymax];
        end
        % 建立AET
        for i = y_min:y_max - 1
            net{y_max - i} = sortrows(net{y_max - i}, 1);
            lines = net{y_max - i};
            [p_num, ~] = size(lines);
            for j = 1:p_num
                x_line = lines(j, 1);
                dx = lines(j, 2);
                ymax = lines(j, 3);
                k = i + 1;
                if k <= ymax - 1
                    x_line = x_line + dx;
                    net{y_max - k} = [net{y_max - k}; x_line dx ymax];
                end
            end
        end
        % plot
        for i = y_min:y_max - 1
            lines = net{y_max - i};
            [p_num, ~] =size(lines);
            for j = 1:p_num/2
                for k = round(lines(2*j - 1, 1)):round(lines(2*j, 1))
                    if isQualified([k i])
                        [u,v] = interpolation( [k i], Pxd, Pyd);
                            matrix = [(1 - u)*(1 - v) (u)*(1 - v) ...
                                (u)*(v) (1 - u)*(v)];
                            I = real(matrix*PI);
                            if isnan(I)
                                
                            end
                            if i_surf == 1
                                %原图坐标
                                origin_x = ((j_ + u)/m - x_base)*x_scaler;
                                origin_y = ((k_ + v)/n - y_base)*y_scaler;
                                origin_x = round(origin_x);
                                origin_y = round(origin_y);
                                if origin_x > 0 && origin_x <= x_limit ...
                                        && origin_y > 0 && ...
                                        origin_y <= y_limit;
                                    I = I * text(y_limit+1 - origin_y, ...
                                        origin_x);
                                end
                            end
                            center = real(matrix*SP);
                            dep = 1 - exp(-norm(center - [0 0 cam_depth]));
                        if dep <= depth(height + 1 - i, k)
                            depth(height + 1 - i, k) = dep;
                            opt(height + 1 - i, k) = I;
                        end
                    end
                end
            end
        end
    end
    function bool = isQualified(P)
        if P(1) <= 0 || P(1) > width ||...
                P(2) <= 0 || P(2) > height
            bool = 0;
        else
            bool = 1;
        end
    end
end