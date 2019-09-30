%% Practice script for the following problems
% 1. Count the number of islands in a map

clear; clc;

params.map_size_rows = 20;
params.map_size_cols = 15;
params.island_size   = 2;
params.num_islands   = 2;

map = getMap(params);

plotMap(map, params);

num_islands = countIslands(map, params);
display(['Number of Islands: ', num2str(num_islands)]);



