function opt = drawChar(src, char, scale, blur, x_offset, y_offset)
% ���룺
% src   ԭͼ
% char  �����ַ�
% scale ��ʾ����
% blur  �Ƿ���и�˹�˲�
if nargin == 2
    x_offset = 0;
    y_offset = 0;
    scale = 1;
    blur = 0;
elseif nargin == 3
    x_offset = 0;
    y_offset = 0;
    blur = 0;
elseif nargin == 4
    x_offset = 0;
    y_offset = 0;
end

opt = src;

% ��ȡ��������
% ÿ��24x24�ĵ����ַ���Ӧ72byte���� 24*24/8 = 72
incode = unicode2native(char);
qh = int32(incode(1) - hex2dec('a0')); % ����
wh = int32(incode(2) - hex2dec('a0')); % λ��
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

if blur
    gFilter = fspecial('gaussian',(scale*2 + 1) * [1 1],0.6 * scale^0.8);
    opt=imfilter(opt,gFilter,'replicate');
    opt=opt / max(max(opt)) * 255;
end

fclose(HZK);