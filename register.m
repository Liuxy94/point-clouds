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

fuX = fu.Location(:,1)*100;
fuY = fu.Location(:,2)*100;
fuZ = fu.Location(:,3)*100;
FU = [fuX,fuY,fuZ];
[m,n] = size(FU);

ceX = ce.Location(:,1)*100;  
ceY = ce.Location(:,2)*100;  
ceZ = ce.Location(:,3)*100;  
CE = [ceX,ceY,ceZ];
TR = [-0.24712935  0.05354237  0.96750209;
      0.13084899  0.99117068 -0.02142941;
      -0.96010709  0.12130084 -0.25195333   
     ];
% TT = [-405;  65;  400];
TT = [-398.0993009; 69.96296418; 398.65570757];



 FU = FU';
 FUtrans = TR * FU + repmat(TT, 1, m);
 CEtrans = CE';
 figure,plot3(CEtrans(1,:),CEtrans(2,:),CEtrans(3,:),'b.',FUtrans(1,:),FUtrans(2,:),FUtrans(3,:),'r.');  
 axis equal; 
 xlabel('X'); ylabel('Y'); zlabel('Z'); 
 title('栏杆配准');  
 
