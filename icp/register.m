clc;
clear;
close all;

fu = pcread('7826fu.pcd');
figure,pcshow(fu);
title('俯视');
xlabel('X'),ylabel('Y'),zlabel('Z');

ce = pcread('7826ce.pcd');
figure,pcshow(ce);
title('侧视');
xlabel('X'),ylabel('Y'),zlabel('Z');

fuX = fu.Location(:,1);
fuY = fu.Location(:,2);
fuZ = fu.Location(:,3);
FU = [fuX,fuY,fuZ];
[m,n] = size(FU);

ceX = ce.Location(:,1);  
ceY = ce.Location(:,2);  
ceZ = ce.Location(:,3);  
CE = [ceX,ceY,ceZ];
TR = [-0.24712935  0.05354237  0.96750209;
      0.13084899  0.99117068 -0.02142941;
      -0.96010709  0.12130084 -0.25195333   
     ];
 TT = [-3.98099301;  0.69962964;  3.98655708];


%
% TR = [-0.38865674  0.03465585  0.92073064;
%       0.18903339  0.98103448  0.04286869;
%       -0.90178285  0.19071004 -0.38783678   
%      ];
%  TT = [-3.85669467;  0.4618924;   4.37797797];
 FU = FU';
 FUtrans = TR * FU + repmat(TT, 1, m);
 CEtrans = CE';
 figure,plot3(CEtrans(1,:),CEtrans(2,:),CEtrans(3,:),'b.',FUtrans(1,:),FUtrans(2,:),FUtrans(3,:),'r.');  
 axis equal; 
 xlabel('X'); ylabel('Y'); zlabel('Z'); 
 title('栏杆配准');  
 
