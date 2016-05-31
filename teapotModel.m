function [ model ] = teapotModel( div1, div2, div3, detail)
if nargin < 3
    div1 = 0.05;
    div2 = 0.05;
    div3 = 2 * pi/100;
end
if nargin < 4
    detail = 0;
end

% model 为整体模型，结构为元胞数组,均为网格面
model = {};

load controlPoint;
t = (0:div1:1)';
A = [t.^3 t.^2 t ones(length(t), 1)];
B = [-1 3 -3 1;
    3 -6 3 0;
    -3 3 0 0;
    1 0 0 0];

% body
p_body = [A * B * cp_body(1:4,:);
    A * B * cp_body(4:7,:);
    A * B * cp_body(7:10,:)];
[height, ~] = size(p_body);
p_body = [p_body(1:height/3-1,:); p_body(height/3+1:height/3*2-1,:); ...
    p_body(height/3*2+1:height,:)];

depth = length(0:div3:2*pi);
height = length(p_body);
cl_body = [p_body zeros(height,1)];
surf_body = zeros(height, 4, depth);
j = 0;
for i = 0:div3:2*pi
    j = j + 1;
    clr_body = cl_body * [cos(i) 0 sin(i);
        0 1 0;
        -sin(i) 0 cos(i)];
    surf_body(:,1:3,j) = clr_body;
end
surf_body = permute(surf_body, [1 3 2]);
surf_body(:,:,4) = ones(height, depth);
surf_body = permute(surf_body, [2 1 3]);
model = [model {surf_body}];

% lid
cp_lid(1,1) = 0.001;
p_lid = [A * B * cp_lid(1:4,:);
    A * B * cp_lid(4:7,:)];
[height,~] = size(p_lid);
p_lid = [p_lid(1:height/2 - 1,:); p_lid(height/2 + 1:height,:)];

depth = length(0:div3:2*pi);
height = length(p_lid);
cl_lid = [p_lid zeros(height,1)];
surf_lid = zeros(height, 4, depth);
j = 0;
for i = 0:div3:2*pi
    j = j + 1;
    clr_lid = cl_lid * [cos(i) 0 sin(i);
        0 1 0;
        -sin(i) 0 cos(i)];
    surf_lid(:,1:3,j) = clr_lid;
end
surf_lid = permute(surf_lid, [1 3 2]);
surf_lid(:,:,4) = ones(height, depth);
surf_lid = permute(surf_lid, [2 1 3]);
model = [model {surf_lid}];

% handle
p_handle1 = [A * B * cp_handle(1:4,:);
    A * B * cp_handle(4:7,:)];
[height, ~] = size(p_handle1);
p_handle1 = [p_handle1(1:height/2 - 1,:);p_handle1(height/2 + 1:height,:)];
p_handle2 = [A * B * cp_handle(8:11,:);
    A * B * cp_handle(11:14,:)];
[height, ~] = size(p_handle2);
p_handle2 = [p_handle2(1:height/2 - 1,:);p_handle2(height/2 + 1:height,:)];

cl_handle1 = [p_handle1 zeros(length(p_handle1), 1)];
cl_handle2 = [p_handle1 0.3 * ones(length(p_handle1), 1)];
cl_handle3 = [p_handle2 0.3 * ones(length(p_handle2), 1)];
cl_handle4 = [p_handle2 zeros(length(p_handle2), 1)];

t = (0:div2:1)';
A = [t.^3 t.^2 t ones(length(t), 1)];
clp_handle = zeros(length(t),3, 2 * length(cl_handle1) -1 );
for i = 1:length(cl_handle1)
    clp_handle(:,:,i) = A * B * [cl_handle1(i,:);
        cl_handle2(i,:);
        cl_handle3(i,:);
        cl_handle4(i,:)];
    clp_handle(:,:,- i + 2 * length(cl_handle1)) = [clp_handle(:,1:2,i) ...
        -clp_handle(:,3,i)];
end
clp_handle = permute(clp_handle, [1,3,2]);
surf_handle = clp_handle;
surf_handle(:,:,4) = 1;
model = [model {surf_handle}];

% spout
t = (0:div1:1)';
A = [t.^3 t.^2 t ones(length(t), 1)];
p_spout1 = [A * B * cp_spout(1:4,:);
    A * B * cp_spout(4:7,:)];
[height, ~] = size(p_spout1);
p_spout1 = [p_spout1(1:height/2 - 1,:);p_spout1(height/2 + 1:height,:)];
p_spout2 = [A * B * cp_spout(8:11,:);
    A * B * cp_spout(11:14,:)];
[height, ~] = size(p_spout2);
p_spout2 = [p_spout2(1:height/2 - 1,:);p_spout2(height/2 + 1:height,:)];

cl_spout1 = [p_spout1(:,1:2) zeros(length(p_spout1), 1)];
cl_spout2 = p_spout1;
cl_spout3 = p_spout2;
cl_spout4 = [p_spout2(:,1:2) zeros(length(p_spout2), 1)];

t = (0:div2:1)';
A = [t.^3 t.^2 t ones(length(t), 1)];
clp_spout = zeros(length(t),3, 2 * length(cl_spout1) - 1);
for i = 1:length(cl_spout1)
    clp_spout(:,:,i) = A * B * [cl_spout1(i,:);
        cl_spout2(i,:);
        cl_spout3(i,:);
        cl_spout4(i,:)];
    clp_spout(:,:,- i + 2 * length(cl_spout1)) = [clp_spout(:,1:2,i) ...
        -clp_spout(:,3,i)];
end
clp_spout = permute(clp_spout, [1,3,2]);
surf_spout = clp_spout;
surf_spout(:,:,4) = 1;
model = [model {surf_spout}];

% Total
if detail
    subplot(2,2,1);
    title('body');
    hold on;
    plot(cp_body(:,1), cp_body(:,2),'c');
    plot(cp_body(:,1), cp_body(:,2), 'k+');
    plot(p_body(:,1), p_body(:,2),'r');
    axis([0 3 0 3]);
    
    subplot(2,2,2);
    title('lid');
    hold on;
    plot(cp_lid(:,1), cp_lid(:,2),'c');
    plot(cp_lid(:,1), cp_lid(:,2), 'k+');
    plot(p_lid(:,1), p_lid(:,2),'r');
    axis([0 3 0 3]);
    
    subplot(2,2,3);
    title('handle');
    hold on;
    plot(cp_handle(1:7,1), cp_handle(1:7,2),'c');
    plot(cp_handle(8:14,1), cp_handle(8:14,2),'c');
    plot(cp_handle(:,1), cp_handle(:,2), 'k+');
    plot(p_handle1(:,1), p_handle1(:,2),'r');
    plot(p_handle2(:,1), p_handle2(:,2),'r');
    axis([-3 0 0 3]);
    
    subplot(2,2,4);
    title('spout');
    hold on;
    plot(cp_spout(1:7,1), cp_spout(1:7,2),'c');
    plot(cp_spout(8:14,1), cp_spout(8:14,2),'c');
    plot(cp_spout(:,1), cp_spout(:,2), 'k+');
    plot(p_spout1(:,1), p_spout1(:,2),'r');
    plot(p_spout2(:,1), p_spout2(:,2),'r');
    axis([1 4 0 3]);
    
end
end

