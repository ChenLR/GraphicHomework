function opt = drawChar(src, char)
x_offset = 0;
y_offset = 0;
scale = 1;

opt = src;

incode = unicode2native(char);
qh = int32(incode(1) - hex2dec('a0')); % ÇøÂë
wh = int32(incode(2) - hex2dec('a0')); % Î»Âë
offset = (94 * (qh - 1) + (wh - 1)) * 72;

HZK = fopen('HZK24', 'rb');
fseek(HZK, offset, 'bof');
mat = uint8(fread(HZK, 72));

for j = 0:24 - 1
    for i = 0:3 - 1
        for k = 0:8 - 1
            if bitand(mat(i + j * 3 + 1),bitshift(128,-k))
                for m = 0:scale - 1
                    for n = 0:scale - 1
                        opt(y_offset + j * scale + n + 1,...
                            x_offset + (8 * i + k) * scale + m + 1) = 255;
                    end
                end
            end
        end
    end
end
fclose(HZK);