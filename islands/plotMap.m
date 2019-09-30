function [] = plotMap(map, perimeters, params)
%PLOTMAP Generates a scatter plot

[X, Y]         = meshgrid(1:params.map_size_rows, 1:params.map_size_cols);
[row_i, col_i] = find(map == 1);

% Plot water
scatter(Y(:), X(:), 50, 'filled', 'b');

% Plot island
hold on
scatter(col_i, row_i, 50, 'filled', 'g');

% Plot perimeter
scatter(perimeters(:,2), perimeters(:,1), 50, 'filled', 'r');


ax = gca;
ax.YDir = 'reverse';
ylim([0 params.map_size_rows+1])
xlim([0 params.map_size_cols+1])
legend('water', 'land', 'beach', 'Location', 'eastoutside')

end

