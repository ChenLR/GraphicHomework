close all;
A = drawChar(zeros(24),'��');
figure;
title('before');
imshow(A,[0 255],'InitialMagnification', 100);

B = drawChar(zeros(24),'��',1,1);
figure;
title('after');
imshow(B,[0 255],'InitialMagnification', 100);

C = drawChar(zeros(100),'��',3,0,2,1);
figure;
title('before');
imshow(C,[0 255],'InitialMagnification', 100);

D = drawChar(zeros(100),'��',3,1,2,1);
figure;
title('after');
imshow(D,[0 255],'InitialMagnification', 100);

