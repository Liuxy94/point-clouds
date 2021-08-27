%% data loading
top_view = pcread('7826fu.pcd').Location';
side_view = pcread('7826ce.pcd').Location';
%% coarse registration
rotation_matrix_coarse = [ -0.24712935  0.05354237  0.96750209;
                     0.13084899  0.99117068 -0.02142941;
                    -0.96010709  0.12130084 -0.25195333];
                
shift_vector_coarse = [-3.98099301;  0.69962964;  3.98655708];

figure()
top_view_coarse = rotation_matrix_coarse*top_view + shift_vector_coarse;
plot3(top_view_coarse(1,:),top_view_coarse(2,:),top_view_coarse(3,:),'b.')
hold on
plot3(side_view(1,:),side_view(2,:),side_view(3,:),'r.')
title('Coarse Registration')
hold off

%% apply the dolphin-echolocation for fine registration

%% set the parameter for dolphin-echolocation
NL = 30; % number of location
Parameter.NL = NL;
NA = 10; % number of altenative / length of alternative
Parameter.NA = NA;
NV_angle = 3; 
Parameter.NV_angle = NV_angle;
NV_shift = 3;
Parameter.NV_shift = NV_shift;
NV = NV_angle + NV_shift; % number of optimazion variables
Parameter.NV = NV;
Re = floor(NA/4); % effective radius from the paper recommended less than 1/4 of the searching space dimension
loops_number = 20; power = 0.2; PP1 = 0.1; eps = 1; record = zeros(loops_number,1);

%% set the parameter for fitness
Parameter.radius = 0.01; Parameter.percent = 0.5; Parameter.lambda = 1e-3; Parameter.value = 1e4;

%% generate the alternative matrix (ordered searching space)
data_angle = linspace(-pi/50,pi/50,NA)';
data_shift = linspace(-0.005,0.005,NA)';
alternative_matrix = [data_angle * ones(1,NV_angle), data_shift * ones(1, NV_shift)];

%% generate the probabilty distribution
probability_matrix = (1/NA)*ones(NA, NV);

%% generate the location matrix which initiate NL locations for a dolphin 
location_matrix = zeros(NL, NV);
for i = 1: NL
    for j = 1:NV
        location_matrix(i,j) = alternative_matrix(randi(NA),j);
    end
end

fitness_matrix = zeros(NL,1); 
accumulative_fitness_matrix = zeros(NA,NV);
tic
for loop = 1 : loops_number
    %% calculate the predefined probability
    PP = PP1 + (1-PP1)* (loop^power - 1)/(loops_number^power - 1);
    %% calculate the fitness matrix for each location
    for i = 1: NL
        location = location_matrix(i,:);
        fitness_matrix(i) = fitness(location, Parameter, top_view_coarse, side_view);
    end
    %% calculate the accumulative fitness matrix
    %% part (a)
    for i = 1: NL
        for j = 1: NV
            variable = location_matrix(i,j);
            position = find(alternative_matrix(:,j) == variable);
            for k = -Re: Re
                if position+k < 1
                    i_new = 1 - (position+k);
                elseif position+k > NA
                    i_new = 2*NA - (position+k);
                else
                    i_new = position + k;
                end
                accumulative_fitness_matrix(i_new, j) = (1/Re)* (Re - abs(k))*fitness_matrix(i) + accumulative_fitness_matrix(i_new,j);
            end
        end
    end
    %% part (b)
    accumulative_fitness_matrix = accumulative_fitness_matrix + eps;
    %% part (c)
    [best_fitness, best_location_i] = max(fitness_matrix);
    record(loop) = Parameter.value/best_fitness;
    best_location = location_matrix(best_location_i, :);
    for j = 1:NV
        best_variable = best_location(j);
        best_position = find(alternative_matrix(:,j) == best_variable); 
        accumulative_fitness_matrix(best_position,j) = 0;
    end
    %% calculate the probability
    for j = 1: NV
        total = sum(accumulative_fitness_matrix(:,j));
        probability_matrix(:,j) = accumulative_fitness_matrix(:,j)/total;
    end
    probability_matrix = probability_matrix * (1-PP);
    
    for j = 1:NV
        best_variable = best_location(j);
        best_position = find(alternative_matrix(:,j) == best_variable); 
        probability_matrix(best_position,j) = PP;
    end
    %% generate new location
    for j = 1:NV
        alphabet = alternative_matrix(:,j)'; prob = probability_matrix(:,j)';
        location_matrix(:,j) = randsrc(NL,1,[alphabet; prob]);
    end

end
figure()
plot(record)
xlabel('loop number')
ylabel('cost')
toc

location = best_location;
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
all = [top_view_coarse, side_view];
%% compute the PCA vector
k = 5;
[n,w] = pca(top_view_fine, k);

figure()
plot3(top_view_fine(1,:),top_view_fine(2,:),top_view_fine(3,:),'b.')
hold on
plot3(side_view(1,:),side_view(2,:),side_view(3,:),'r.')
title('Fine Registration')
hold off