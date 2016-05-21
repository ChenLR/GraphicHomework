close all;
clear;
model = teapotModel();
figure;
model = translateModel(model, [0 -1.5 0]);
model = rotateModel(model, [30 30 0], [2 1 3]);
% imshow(gridView(zeros(600,800),model,5,90));
light = [4 0 10];
mat = render(zeros(600,800),model,light,5,90);
imshow(mat, [0 max(max(mat))]);