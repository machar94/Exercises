%% Practice script for the following problems
% 1. Count the number of islands in a map (BFS)
% 2. Identify the perimeter of each island (BFS)
%     - currently considered perimeter only if location touches water
% 3. Shortest path between two islands (BFS)

clear; clc; close all;

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

graph = generateGraph(params); 

map_invalid = 1;
while (map_invalid)
    disp('Generating a new map...') 
    map = getMap(params);
    graph = generateGraph(params);
    [num_islands, island_points, graph] = countIslands(map, graph, params);
    
    if (num_islands == params.num_islands)
       disp(['Map with ', num2str(params.num_islands), ' islands generated!']);
       map_invalid = 0;  
    end
end

perimeters    = getPerimeters(map, island_points, params);
shortest_path = shortestPath([2,4], graph, params);
plotMap(map, perimeters, shortest_path, params);


