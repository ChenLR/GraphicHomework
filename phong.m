function I = phong(P, depth, light, Ia, Ip, Ka, Kd, Ks, Kn, a, b, c)
if nargin <= 3
    Ia = 10;
    Ip = 400;
    Ka = 0.4;
    Kd = 0.8;
    Ks = 0.1;
    Kn = 10;
end
if nargin <= 9
    a = 1;
    b = 0.01;
    c = 0.01;
end
% P的行向量为一个点
center = [(P(1,1)+P(2,1)+P(3,1))/3 (P(1,2)+P(2,2)+P(3,2))/3 ...
    (P(1,3)+P(2,3)+P(3,3))/3];
in = center - light;
view = [0 0 depth] - center;
d = norm(in);
n = cross((P(2,:) - P(1,:)),(P(3,:) - P(1,:)));
n = n / norm(n);
cos_theta = abs((in(1)*n(1) + in(2)*n(2) + in(3)*n(3)) / d);
pro = cross(n,cross(n,in));
pro = pro / norm(pro);
out = in - 2 * (in(1)*pro(1) + in(2)*pro(2) + in(3)*pro(3));
cos_alpha = abs((view(1)*out(1) + view(2)*out(2) + view(3)*out(3))/...
    (norm(view) * norm(out)));
fd = 1/(a + b*d + c*d^2);
Ic = Ia * Ka;
Id = fd * Ip * Kd * cos_theta;
Is = fd * Ip * Ks * cos_alpha.^Kn;
if (view(1)*n(1) + view(2)*n(2) + view(3)*n(3)) * ...
        (in(1)*n(1) + in(2)*n(2) + in(3)*n(3)) >= 0;
    I = Ic;
else
    I = Ic + Id + Is;
end
end

