close all;
clear all;

div1 = 0.02;
div2 = 0.1;
div3 = 2*pi/100;

load controlPoint;
t = (0:div1:1)';
A = [t.^3 t.^2 t ones(length(t), 1)];
B = [-1 3 -3 1;
    3 -6 3 0;
    -3 3 0 0;
    1 0 0 0];

%% body
p_body = [A * B * cp_body(1:4,:);
    A * B * cp_body(4:7,:);
    A * B * cp_body(7:10,:)];
figure(1);
subplot(2,2,1);
title('body');
hold on;
plot(cp_body(:,1), cp_body(:,2),'c');
plot(cp_body(:,1), cp_body(:,2), 'k+');
plot(p_body(:,1), p_body(:,2),'r');
axis([0 3 0 3]);

%% lid
p_lid = [A * B * cp_lid(1:4,:);
    A * B * cp_lid(4:7,:)];
figure(1);
subplot(2,2,2);
title('lid');
hold on;
plot(cp_lid(:,1), cp_lid(:,2),'c');
plot(cp_lid(:,1), cp_lid(:,2), 'k+');
plot(p_lid(:,1), p_lid(:,2),'r');
axis([0 3 0 3]);

%% handle
p_handle1 = [A * B * cp_handle(1:4,:);
    A * B * cp_handle(4:7,:)];
p_handle2 = [A * B * cp_handle(8:11,:);
    A * B * cp_handle(11:14,:)];
figure(1);
subplot(2,2,3);
title('handle');
hold on;
plot(cp_handle(1:7,1), cp_handle(1:7,2),'c');
plot(cp_handle(8:14,1), cp_handle(8:14,2),'c');
plot(cp_handle(:,1), cp_handle(:,2), 'k+');
plot(p_handle1(:,1), p_handle1(:,2),'r');
plot(p_handle2(:,1), p_handle2(:,2),'r');
axis([-3 0 0 3]);

% 3D
cl_handle1 = [p_handle1 zeros(length(p_handle1), 1)];
cl_handle2 = [p_handle1 0.3 * ones(length(p_handle1), 1)];
cl_handle3 = [p_handle2 0.3 * ones(length(p_handle2), 1)];
cl_handle4 = [p_handle2 zeros(length(p_handle2), 1)];

t = (0:div2:1)';
A = [t.^3 t.^2 t ones(length(t), 1)];
clp_handle = zeros(length(t),3, 2 * length(cl_handle1));
for i = 1:length(cl_handle1)
    clp_handle(:,:,i) = A * B * [cl_handle1(i,:);
        cl_handle2(i,:);
        cl_handle3(i,:);
        cl_handle4(i,:)];
    clp_handle(:,:,i + length(cl_handle1)) = [clp_handle(:,1:2,i) ...
        -clp_handle(:,3,i)];
end
clp_handle = permute(clp_handle, [1,3,2]);

%% spout
t = (0:div1:1)';
A = [t.^3 t.^2 t ones(length(t), 1)];
p_spout1 = [A * B * cp_spout(1:4,:);
    A * B * cp_spout(4:7,:)];
p_spout2 = [A * B * cp_spout(8:11,:);
    A * B * cp_spout(11:14,:)];
figure(1);
subplot(2,2,4);
title('spout');
hold on;
plot(cp_spout(1:7,1), cp_spout(1:7,2),'c');
plot(cp_spout(8:14,1), cp_spout(8:14,2),'c');
plot(cp_spout(:,1), cp_spout(:,2), 'k+');
plot(p_spout1(:,1), p_spout1(:,2),'r');
plot(p_spout2(:,1), p_spout2(:,2),'r');
axis([1 4 0 3]);

% 3D 
cl_spout1 = [p_spout1(:,1:2) zeros(length(p_spout1), 1)];
cl_spout2 = p_spout1;
cl_spout3 = p_spout2;
cl_spout4 = [p_spout2(:,1:2) zeros(length(p_spout2), 1)];

t = (0:div2:1)';
A = [t.^3 t.^2 t ones(length(t), 1)];
clp_spout = zeros(length(t),3, 2 * length(cl_spout1));
for i = 1:length(cl_spout1)
    clp_spout(:,:,i) = A * B * [cl_spout1(i,:);
        cl_spout2(i,:);
        cl_spout3(i,:);
        cl_spout4(i,:)];
    clp_spout(:,:,i + length(cl_spout1)) = [clp_spout(:,1:2,i) ...
        -clp_spout(:,3,i)];
end
clp_spout = permute(clp_spout, [1,3,2]);

%% Total axis x z y

figure(2);
hold on;
axis([-4 4 -4 4 -1 4]);

cl_body = [p_body zeros(length(p_body),1)];
for i = 0:div3:2*pi
    clr_body = cl_body * [cos(i) 0 sin(i);
        0 1 0;
        -sin(i) 0 cos(i)];
    plot3(clr_body(:,1),clr_body(:,3),clr_body(:,2),'r');
end

cl_lid = [p_lid zeros(length(p_lid),1)];
for i = 0:div3:2*pi
    clr_lid = cl_lid * [cos(i) 0 sin(i);
        0 1 0;
        -sin(i) 0 cos(i)];
    plot3(clr_lid(:,1),clr_lid(:,3),clr_lid(:,2),'r');
end


% plot3(cl_handle1(:,1), cl_handle1(:,2), cl_handle1(:,3));
% plot3(cl_handle2(:,1), cl_handle2(:,2), cl_handle2(:,3));
% plot3(cl_handle3(:,1), cl_handle3(:,2), cl_handle3(:,3));
% plot3(cl_handle4(:,1), cl_handle4(:,2), cl_handle4(:,3));
plot3(clp_handle(:,:,1),clp_handle(:,:,3),clp_handle(:,:,2),'r');

% plot3(cl_spout1(:,1), cl_spout1(:,2), cl_spout1(:,3));
% plot3(cl_spout2(:,1), cl_spout2(:,2), cl_spout2(:,3));
% plot3(cl_spout3(:,1), cl_spout3(:,2), cl_spout3(:,3));
% plot3(cl_spout4(:,1), cl_spout4(:,2), cl_spout4(:,3));
plot3(clp_spout(:,:,1),clp_spout(:,:,3),clp_spout(:,:,2),'r');
