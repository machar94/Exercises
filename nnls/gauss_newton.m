%% Exercise followed from http://math.gmu.edu/~igriva/book/Appendix%20D.pdf
% Resources:
% 1) https://en.wikipedia.org/wiki/Newton%27s_method_in_optimization
% 2) https://en.wikipedia.org/wiki/Gauss?Newton_algorithm

% Antelope data often modeled as a an exponential function y = x1e^(x2t)
t = [1 2 4 5 8]';
y = [3.2939 4.2699 7.1749 9.3008 20.259]';

model = @(x, t) x(1)*exp(x(2)*t);

%% Cost and minimization functions, derivatives:
% f(x) = sum(i -> m) f_i(x)^2 where f_i = x1e^x2t - y_i
% The vector F(x) = [f_1(x) f_2(x) ... f_m(x)]'
F = @(x, t, y) model(x, t) - y;

% The gradient F
d_model_x1 = @(x, t) exp(x(2)*t);
d_model_x2 = @(x, t) x(1)*t.*exp(x(2)*t);
d_F = @(x, t) [d_model_x1(x, t), d_model_x2(x, t)];

%% Gauss-Newton
steps = 10;
tol   = 1e-6;

% Two decompoisiton techniques to solve problem
% If not set, defaults to (A'A) \ (A'b)
decomposition = 'cholesky';
% decomposition = 'qr';

x_old   = [2.50 0.25]'; % Initial condition close to solution
descent = x_old'; 

for i = 1:steps
   % Calculate the jacobian
   J = d_F(x_old, t);
   b = - J'*F(x_old, t, y);
   
   if strcmp(decomposition, 'cholesky')
       % A = LL' where L is a lower triangular matrix
       Lu     = chol(J'*J, 'lower');
       dx  = Lu' \ (Lu \ b);
   elseif strcmp(decomposition,'qr')
       % A = M'M matrix and M is M = QR and b = M'c
       % M is also J (Jacobian)
       [Q, R] = qr(J);
       dx  = R \ Q' * -F(x_old, t, y);
   else
       % Traditional approach
       dx = (J'*J) \ (J' * b); 
   end
   
   x_new = x_old + dx;
   descent = [descent; x_new'];
   
   if norm(dx) < tol
      break 
   end
   
   x_old = x_new;
end

%% Plotting
param1 = 2.45:0.01:2.55;
param2 = 0.245:0.001:0.265;

cost_function = @(x, ts, ys) sum((model(x, ts) - ys).^2);
cost = zeros(length(param1), length(param2));

for i = 1:length(param1)
   for j = 1:length(param2)
       squared_error = 0;
       for k = 1:length(t)
           squared_error = squared_error + (model([param1(i),param2(j)],t(k)) - y(k)).^2;
       end
       squared_error = squared_error.^2;
           
       cost(i,j) = cost_function([param1(i),param2(j)],t,y);
   end
end

residuals = [];
for i = 1:(size(descent,1))
    error = cost_function(descent(i,:),t,y);
    residuals = [residuals; error];
end

% Plot the surface of the cost function
[X, Y] = meshgrid(param1, param2);
surf(X,Y,cost');
hold on

% Plot the descent of the solver
fsize = 20; az = 105; el = 30;
plot3(descent(:,1),descent(:,2),residuals,'-r*', 'markersize', fsize);
title('Gauss Newton - Optimal $x_1$,$x_2$ for $y = x_1e^{x_2t}$', ...
    'fontsize', fsize, 'Interpreter', 'latex');
xlabel('$x_1$', 'fontsize', fsize, 'Interpreter', 'latex');
ylabel('$x_2$', 'fontsize', fsize, 'Interpreter', 'latex');
zlabel('Sum of Squared Errors', 'fontsize', fsize, 'Interpreter', 'latex');
set(gca, 'fontsize', fsize);

% Sets the camera view of the plot
view(az, el);
print('gauss_newton_example.png', '-dpng', '-r100');

