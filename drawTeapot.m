close all;
clear;
% model = teapotModel();
model = teapotModel(0.1, 0.1, pi / 10);
figure;
model = translateModel(model, [0 -1.5 0]);
model = rotateModel(model, [30 30 0], [2 1 3]);
%imshow(gridView(zeros(600,800),model,5,90));
light = [0 0 10];
%mat = render(zeros(600,800),model,light,5,90);
texture = imread('name.PNG');
texture = rgb2gray(texture);

mat = renderTexture(zeros(600,800),model,light,5,90,texture);
 imshow(mat, [0 150]);