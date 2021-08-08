clc
clear;
close all;

%% 拼接配准
%代码块1
fu = pcread('fB2.pcd');
figure,pcshow(fu); 
xlabel('X'); ylabel('Y'); zlabel('Z');
title('俯视奶牛');

%代码块2
ce = pcread('cB2.pcd');
figure,pcshow(ce); 
xlabel('X'); ylabel('Y'); zlabel('Z');
title('侧视奶牛');

fZhuanY=fu.Location';
TR=[-1,0,0
    0,-1,0
    0,0,1];
fZhuan = TR * fZhuanY;
fZhuan = fZhuan';
fX=fZhuan(:,1);
fY=fZhuan(:,2)+70;
fZ=fZhuan(:,3);
F=[fX,fY,fZ];
% pcCloud = pointCloud(F(:,:,:));
% pcwrite(pcCloud,'fnew.pcd','Encoding','ascii');
% figure,pcshow(F);
% title('俯视转置');
% xlabel('X'); ylabel('Y'); zlabel('Z');
[m1,n]=size(fZhuan);

% m1=fu.Count;
%n1统计满足条件的点个数
n1=0;
for i1=1:m1
        if fX(i1) > 10 && fX(i1) < 20 && fY(i1) < 30 && fY(i1)>-10
            n1=n1+1;
        end
end

fPei=zeros(n1,3);
j1=1;

for i1=1:m1
    if fX(i1) > 10 && fX(i1) < 20 && fY(i1) < 30 && fY(i1)>-10
        fPei(j1,1)=fX(i1);
        fPei(j1,2)=fY(i1);
        fPei(j1,3)=fZ(i1);
        j1=j1+1;
    end
end
%figure 4       
% figure,pcshow(fPei);
% xlabel('X'); ylabel('Y'); zlabel('Z');
% title('fPei');

%代码块4
cX=ce.Location(:,1);
cY=ce.Location(:,2);
cZ=ce.Location(:,3);
C=[cX,cY,cZ];
%m1表示点个数
m2=ce.Count;
%n1统计满足条件的点个数
n2=0;
for i2=1:m2
        if cX(i2) < -20 && cY(i2)<22 && cY(i2)>-5 
            n2=n2+1;
        end
end

cPei=zeros(n2,3);
j2=1;

for i2=1:m2
    if cX(i2) < -20 && cY(i2)<22 && cY(i2)>-5
        cPei(j2,1)=cX(i2);
        cPei(j2,2)=cY(i2);
        cPei(j2,3)=cZ(i2);
        j2=j2+1;
    end
end
        
% figure,pcshow(cPei);
% xlabel('X'); ylabel('Y'); zlabel('Z');
% title('cPei');

%调用封装好的icp配准函数
%矩阵转置
a=cPei';
b=fPei';
[TR,TT]=icp_Matlab(a,b);
Fzhuanzhi=F';
Czhuanzhi=C';
%自己修改了旋转和平移矩阵
% TR=[0,0,1
%     0,1,0
%     -1,0,0];
% TT(1,1)=TT(1,1)-165;
% TT(2,1)=TT(2,1)-160;
% TT(3,1)=TT(3,1)+80;
% [TR,TT] = pca_function(a,b);
d = TR * Fzhuanzhi + repmat(TT, 1, m1);
figure,plot3(Czhuanzhi(1,:),Czhuanzhi(2,:),Czhuanzhi(3,:),'b.',d(1,:),d(2,:),d(3,:),'r.');

axis equal;
xlabel('X'); ylabel('Y'); zlabel('Z');
title('ICP结果');


