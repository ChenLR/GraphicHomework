function [ opt ] = bresLine( src,P1,P2)
[h, w] = size(src);
P1 = round(P1);
P2 = round(P2);
opt = src;
dx = abs(P1(1) - P2(1));
dy = abs(P1(2) - P2(2));
up = (P1(1) - P2(1))*(P1(2) - P2(2)) >= 0;

if dy <= dx
    if P1(1) <= P2(1)
        x = P1(1);
        y = P1(2);
    else
        x = P2(1);
        y = P2(2);
    end
    if up
        % 0 <= k <= 1
        m = 2 * dy - dx;
        neg = 2 * dy;
        pos = 2 * (dy - dx);
        for i = 0:dx
            if isQualified([x y])
                opt(h + 1 - y, x) = 1;
            end
            if m < 0
                m = m + neg;
            else
                m = m + pos;
                y = y + 1;
            end
            x = x + 1;
        end
    else
        % 0 > k >= -1
        m = 2 * dy - dx;
        neg = 2 * dy;
        pos = 2 * (dy - dx);
        for i = 0:dx
            if isQualified([x y])
                opt(h + 1 - y, x) = 1;
            end
            if m < 0
                m = m + neg;
            else
                m = m + pos;
                y = y - 1;
            end
            x = x + 1;
        end
    end
else % dy > dx
    if P1(2) <= P2(2)
        x = P1(1);
        y = P1(2);
    else
        x = P2(1);
        y = P2(2);
    end
    if up
        % 1 < k < inf
        m = 2 * dx - dy;
        neg = 2 * dx;
        pos = 2 * (dx - dy);
        for i = 0:dy
            if isQualified([x y])
                opt(h + 1 - y, x) = 1;
            end
            if m < 0
                m = m + neg;
            else
                m = m + pos;
                x = x + 1;
            end
            y = y + 1;
        end
    else
        % -1 > k > -inf
        m = 2 * dx - dy;
        neg = 2 * dx;
        pos = 2 * (dx - dy);
        for i = 0:dy
            if isQualified([x y])
                opt(h + 1 - y, x) = 1;
            end
            if m < 0
                m = m + neg;
            else
                m = m + pos;
                x = x - 1;
            end
            y = y + 1;
        end
    end
end
    function bool = isQualified(P)
        if P(1) <= 0 || P(1) > w ||...
                P(2) <= 0 || P(2) > h
            bool = 0;
        else
            bool = 1;
        end
    end
end
