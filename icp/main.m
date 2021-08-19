%% data loading
top_view = pcread('fB2.pcd');
side_view = pcread('cB2.pcd');

ptCloud_in = top_view;
% 法向量估计
normals = pcnormals(ptCloud_in);

% 可视化
figure;
pcshow(ptCloud_in.Location,[0.3,0.3,0.7]);
title('法向量估计');
xlabel('X(m)');
ylabel('Y(m)');
zlabel('Z(m)');
hold on

% 所绘制的法向量间隔
setp = 5;

% 法向量位置（x,y,z）
x = ptCloud_in.Location(1:setp:end,1);
y = ptCloud_in.Location(1:setp:end,2);
z = ptCloud_in.Location(1:setp:end,3);

% 法向量（u,v,w）
u = normals(1:setp:end,1);
v = normals(1:setp:end,2);
w = normals(1:setp:end,3);

% 在由（x，y，z）确定的点上，用分量（u，v，w）确定的方向绘制法向量。矩阵x、y、z、u、v和w的大小必须相同，并且包含相应的位置和法向量分量。
quiver3(x,y,z,u,v,w);
hold on