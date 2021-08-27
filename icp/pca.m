% PCA主元分析法求法向量
% 输入：
% p:3*n的数值矩阵
% k:k近邻参数
% neighbors = transpose(knnsearch(transpose(p), transpose(p), 'k', k+1));
% neighbors一般可缺省。若之前做过k邻域求取操作也可直接调用，提高运算效率
% 输出
% n:法矢，已规定方向由邻域拟合出的平面指向查询点
% w:用于评估曲率的参数，详见：Mark P,et al. Multi-scale Feature Extraction on Point-Sampled Surfaces[J]. Computer Graphics Forum, 2010, 22(3): 281-289.
 
function [n,w] = pca(p, k, neighbors)%p为输入的点云
if nargin < 2
    error('no bandwidth specified')
end
if nargin < 3
    neighbors = transpose(knnsearch(transpose(p), transpose(p), 'k', k+1));%neighbor为一个索引矩阵，第一行代表第几个点，后8行代表K近邻的点。记录每个点及其周围的8个点
end
m = size(p,2);%返回第2维的维度
n = zeros(3,m); %存放法线的矩阵
w = zeros(1,m);
for i = 1:m
    x = p(:,neighbors(2:end, i));%x为8个邻域点    ，3x8的矩阵
    p_bar=mean(x,2);%每一行求均值(一共三行)
    
%     P =  (x - repmat(p_bar,1,k)) * transpose(x - repmat(p_bar,1,k));%中心化样本矩阵，再计算协方差矩阵
%     P = 1/(k) * (x - repmat(p_bar,1,k)) * transpose(x - repmat(p_bar,1,k)); %邻域协方差矩阵P
    P=(x - repmat(p_bar,1,k)) * transpose(x - repmat(p_bar,1,k))./(size(x,2)-1);
    
    [V,D] = eig(P);%求P的特征值、特征向量。 D是对应的特征值对角矩阵，V是特征向量(因为协方差矩阵为实对称矩阵，故特征向量为单位正交向量)
    
    [d0, idx] = min(diag(D)); %d0为最小特征值  idx为特征值的列数索引。diag():创建对角矩阵或获取矩阵的对角元素
 
    
    n(:,i) = V(:,idx);   % 最小特征值对应的特征向量为法矢，即法向量    
    
    %规定法矢方向指向
    flag = p(:,i) - p_bar;%由近邻点的平均点指向对应点的向量
    if dot(n(:,i),flag)<0%如果这个向量与法向量的数量积为负数（反向）
        n(:,i)=-n(:,i);%法向量取反向
    end
    if nargout > 1 
        w(1,i)=abs(d0)./sum(abs(diag(D)));%最小特征值的绝对值在协方差矩阵特征值绝对值的总和中占的比重
    end
end