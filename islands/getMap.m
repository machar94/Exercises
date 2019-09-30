function [map] = getMap(params)
%GETMAP Returns a grid of 0s and 1s representing islands and water

% Create map, where 0 indicates water and 1 indicates land
map        = zeros(params.map_size_rows, params.map_size_cols);

% Randomly generate the top left corner of each island
island_pos_limit = min(params.map_size_rows-params.island_size+1, ...
                       params.map_size_cols-params.island_size+1);
island_pos       = randi(island_pos_limit, params.num_islands, 2);

% populate 
for i = 1:params.num_islands
   x_i = island_pos(i,1);
   y_i = island_pos(i,2);
   
   map(x_i:x_i+params.island_size-1, y_i:y_i+params.island_size-1) = ...
        ones(params.island_size);
end

end

