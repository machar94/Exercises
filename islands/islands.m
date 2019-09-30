%% Practice script for the following problems
% 1. Count the number of islands in a map (BFS)
% 2. Identify the perimeter of each island (BFS)

clear; clc;

params.map_size_rows = 20;
params.map_size_cols = 15;
params.island_size   = 3;
params.num_islands   = 5;

% 4 connected neighbors
params.neighbors = ...
    [-1, 0;   % up
      0, 1;   % right
      1, 0;   % down
      0, -1]; % left

map = getMap(params);

[num_islands, island_points] = countIslands(map, params);
display(['Number of Islands: ', num2str(num_islands)]);

perimeters = getPerimeters(map, island_points, params);
plotMap(map, perimeters, params);
