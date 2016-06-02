function [u,v] = interpolation( P, Px, Py)

a = (Px(3) - Px(4)) * (Py(2) - Py(1)) - ...
    (Px(2) - Px(1)) * (Py(3) - Py(4));
b = Py(1) * (Px(3) - Px(4)) + Px(4) * (Py(2) - Py(1)) ...
    - Py(4) * (Px(2) - Px(1)) - Px(1) * (Py(3) - Py(4)) ...
    + P(1) * (Py(3) + Py(1) - Py(2) - Py(4)) ...
    + P(2) * (Px(2) + Px(4) - Px(1) - Px(3));
c = (Py(1) - P(2)) * (Px(4) - P(1)) ...
    -(Py(4) - P(2)) * (Px(1) - P(1));
if a == 0;
    u = -c / b;
elseif (Px(2) - Px(1)) * (Px(4) - P(1)) == ...
        (Px(3) - Px(4)) * (Px(1) - P(1))
    u = -(Px(1) - P(1))/(Px(2) - Px(1));
elseif c == 0;
    u = 0;
else
    u1 = (-b + (b^2 - (4*a*c))^0.5)/(2 * a);
    u2 = (-b - (b^2 - (4*a*c))^0.5)/(2 * a);
    if abs(u1 - 0.5) > abs(u2 - 0.5)
        u = u2;
    else
        u = u1;
    end
end

buffer = Px(2);
Px(2) = Px(4);
Px(4) = buffer;
buffer = Py(2);
Py(2) = Py(4);
Py(4) = buffer;

a = (Px(3) - Px(4)) * (Py(2) - Py(1)) - ...
    (Px(2) - Px(1)) * (Py(3) - Py(4));
b = Py(1) * (Px(3) - Px(4)) + Px(4) * (Py(2) - Py(1)) ...
    - Py(4) * (Px(2) - Px(1)) - Px(1) * (Py(3) - Py(4)) ...
    + P(1) * (Py(3) + Py(1) - Py(2) - Py(4)) ...
    + P(2) * (Px(2) + Px(4) - Px(1) - Px(3));
c = (Py(1) - P(2)) * (Px(4) - P(1)) ...
    -(Py(4) - P(2)) * (Px(1) - P(1));

if a == 0;
    v = -c / b;
elseif (Px(2) - Px(1)) * (Px(4) - P(1)) == ...
        (Px(3) - Px(4)) * (Px(1) - P(1))
    v = -(Px(1) - P(1))/(Px(2) - Px(1));
elseif c == 0;
    v = 0;
else
    v1 = (-b + (b^2 - (4*a*c))^0.5)/(2 * a);
    v2 = (-b - (b^2 - (4*a*c))^0.5)/(2 * a);
    if abs(v1 - 0.5) > abs(v2 - 0.5)
        v = v2;
    else
        v = v1;
    end
end

% P = P(:);
% Px = Px(:);
% Py = Py(:);
% P(1) = P(1) - Px(4);
% Px = Px - Px(4);
% P(2) = P(2) - Py(4);
% Py = Py - Py(4);
% Px = Px';
% Py = Py';
% T = [0 1 1;1 1 0] / ([Px(1:3); Py(1:3)]);
% P_ = T * P;
% u = P_(1);
% v = 1 - P_(2);

t = 1;
if (u - 0.5) > t
    u = 0.5 + t;
elseif (u - 0.5) < -t
    u = 0.5 - t;
end
if (v - 0.5) > t
    v = 0.5 + t;
elseif (v - 0.5) < -t
    v = 0.5 - t;
end

end
