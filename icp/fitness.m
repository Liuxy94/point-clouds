function res = fitness(location, Parameter, top_view_coarse, side_view)

alpha = location(1); beta = location(2); gamma = location(3); 

shift_vector = location(4:6)';

rotation_matrix = [ cos(gamma), -sin(gamma), 0;
                    sin(gamma),  cos(gamma), 0;
                    0,           0,          1;]*...
                  [ cos(beta), 0 , sin(beta);
                    0,         1 , 0        ;
                   -sin(beta), 0 , cos(beta);]*...
                  [ 1, 0,           0;
                    0, cos(alpha), -sin(alpha);
                    0, sin(alpha),  cos(alpha);];
                
top_view_fine = rotation_matrix*top_view_coarse + shift_vector;
num_top = length(top_view_fine); cost = 0; count_point = 0;

for i = 1: num_top
    point = top_view_fine(:,i);
    diff_mat = side_view - point;
    diff_L2 = sum(diff_mat.^2);
    index = diff_L2 < Parameter.radius;
    if ~isempty(index)
        count_point = count_point + 1;
        cost = cost + sum(diff_L2(index));
    end
end

total_cost = cost + Parameter.lambda * abs(Parameter.percent*num_top - count_point);
res = Parameter.value/total_cost;