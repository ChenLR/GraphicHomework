close all;
clear;
%% grid
figure;
model = teapotModel();
model = translateModel(model, [0 -1.5 0]);
model = rotateModel(model, [30 30 0], [2 1 3]);
imshow(gridView(zeros(600,800),model,5,90));

%% triangle
figure;
model = teapotModel(0.02, 0.02, pi/200);
model = translateModel(model, [0 -1.5 0]);
model = rotateModel(model, [30 30 0], [2 1 3]);
mat = render(zeros(600,800),model,light,5,90);
imshow(mat, [0 150]);

%% smooth
figure;
light = [0 0 10];
model = teapotModel();
model = translateModel(model, [0 -1.5 0]);
model = rotateModel(model, [30 30 0], [2 1 3]);
texture = imread('name.PNG');
texture = rgb2gray(texture);
mat = renderTexture(zeros(600,800),model,light,5,90,texture);
imshow(mat, [0 150]);