function [] = plotMap(map, params)
%PLOTMAP Generates a scatter plot

[X, Y]         = meshgrid(1:params.map_size_rows, 1:params.map_size_cols);
[row_i, col_i] = find(map == 1);


scatter(X(:), Y(:), 50, 'filled', 'b');

hold on
scatter(row_i, col_i, 50, 'filled', 'g');

end

