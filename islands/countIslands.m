function [counted_islands, island_points] = countIslands(map,params)
%COUNTISLANDS Returns the number of islands in the map
% Problem is similar to the number of connected components search

% Allows the use of a queue
% - q.add method
% - q.remove method
% - q.size method
% - q.clear method

import java.util.LinkedList
q = LinkedList();

[X, Y] = meshgrid(1:params.map_size_rows, 1:params.map_size_cols);
X = X(:); Y = Y(:);

% visited is a loaded boolean representing both
% 1. The location on the map is currently in the queue OR
% 2. The location on the map has been expanded in the BFS
visited = zeros(size(map));
counted_islands = 0;
island_points   = [];

for i = 1:numel(map)

    % If the cell has not been visited and is an island
    % When encountering land, expand all neighbors
    % Using 4 connected neighbor expansion (up, down, left, right)
    if (visited(X(i), Y(i)) ~= 1) && (map(X(i), Y(i)) == 1)
        
        island_points = vertcat(island_points, [X(i), Y(i)]);
        
        % Mark cell as visited
        visited(X(i), Y(i)) = 1;

        q.clear()
        q.add([X(i), Y(i)]);

        % BFS search
        while(q.size() > 0)
            coord = q.remove();

            % Mark cell as visited
            visited(coord(1), coord(2)) = 1;

            % If not visited yet and in bounds of map and land, 
            % add to queue
            for j = 1:size(params.neighbors,1)
                new_coord = zeros(1,2);
                new_coord(1) = coord(1) + params.neighbors(j,1);
                new_coord(2) = coord(2) + params.neighbors(j,2);
                
                if (isWithinMap([new_coord(1), new_coord(2)], params) && ... 
                    ~visited(new_coord(1), new_coord(2)) && ...
                    map(new_coord(1), new_coord(2)) == 1)
                    
                    % Mark cell as visited
                    visited(new_coord(1), new_coord(2)) = 1;
                    
                    q.add([new_coord(1), new_coord(2)]);
                end
            end
        end

        counted_islands = counted_islands + 1;
    else
        visited(X(i), Y(i)) = 1;
    end
    
end

end

