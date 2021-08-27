clc
clear
close all
n=50;
z=peaks(n);
x=1:n;y=1:n;
[x,y]=meshgrid(x,y);
P=[x(:),y(:),z(:)];
 
%读入屋顶点云
% P=load('building_Example2.txt');
% P=P(:,1:1:3);
 
%读入Building1.txt
% P=load('point_w.txt');
% P=P(:,1:1:3);
 
 
P=P';%P=3x2500
k=8;
[pn,pw] = pca(P, k);
pp = P+3.*pn;%pn为法向量，pw为评价曲率的一个参数
 
%求取曲率最大的500个点
P_=P';%P_ 是2500x3
[pw_,indice]=sort(pw);
indice=indice';
 
%找出曲率最大（或最小）的几个点，验证
% pw_first=indice(size(indice,1)-100:1:size(indice,1),:);%曲率最大值排前1000的点
pw_first=indice(1:1:700,:);%曲率最小值（最平坦）排前1000的点
 
for i=1:size(pw_first)
    Point_pw(i,1)=P_(pw_first(i),1);
    Point_pw(i,2)=P_(pw_first(i),2);
    Point_pw(i,3)=P_(pw_first(i),3);%Point_pw为曲率的前500个点
end
 
 
figure;
% scatter3( P(1,:)',P(2,:)',P(3,:)','.');
plot3(P(1,:)',P(2,:)',P(3,:)','g.');
hold on
plot3(Point_pw(:,1),Point_pw(:,2),Point_pw(:,3),'r*');
title("最平坦的前780个点");
 
 
 
 
% 使用matlab工具箱计算的法向量
figure(2);
P=P';
pt=pointCloud(P);
pcshow(pt);
hold on;
 
normals=pcnormals(pt,8);
u = normals(1:5:end,1);
v = normals(1:5:end,2);
w = normals(1:5:end,3);
 
x=P(1:5:end,1);
y=P(1:5:end,2);
z=P(1:5:end,3);
title('Matlab点云工具箱计算的 Normals of Point Cloud')
hold on
quiver3(x, y, z, u, v, w);
view(-37.5,45);
hold off
 
%使用pca计算的法向量
figure(3)
pcshow(pt);
hold on;
pn=pn';%对pn进行转置
 
u_p = pn(1:5:end,1);
v_p = pn(1:5:end,2);
w_p = pn(1:5:end,3);
 
 
title('PCA计算的 Normals of Point Cloud')
hold on
quiver3(x, y, z, u_p, v_p, w_p);
view(-37.5,45);
hold off