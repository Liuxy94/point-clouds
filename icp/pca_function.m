function [R,T] = pca_function(P,Q)
	point1=size(P,2);
	point2=size(Q,2);
	
	pc = mean(P,2);
	qc = mean(Q,2); 
	
	x1 = P - repmat(pc,1,point1); 
	Mx =x1 * x1';
	y1 = Q - repmat(qc,1,point2);
	My = y1 * y1';
	
	[Vx,Dx] = eig(Mx,'nobalance'); %Vx特征向量,Dx特征值
	[Vy,Dy] = eig(My,'nobalance');
	
	[~,index]=max(sum(x1.*x1));
	xm=x1(:,index);
	xm(3,1)=-abs(xm(3,1));
	p3 = Vx(:,3);
	if dot(xm,p3)<0
	    p3=-p3;
	end
	p2 = Vx(:,2);
	if dot(xm,p2)<0
	    p2=-p2;
	end
	p1=cross(p3,p2);
	
	[~,index]=max(sum(y1.*y1));
	ym=y1(:,index);
	ym(3,1)=-abs(ym(3,1));
	q3 = Vy(:,3);
	if dot(ym,q3)<0
	    q3=-q3;
	end
	q2 = Vy(:,2);
	if dot(ym,q2)<0
	    q2=-q2;
	end
	q1=cross(q3,q2);
	
	R = [q1,q2,q3]/[p1,p2,p3];
	xc2 = R*pc;
	T = (qc - xc2);
end