function [all_perimeters] = getPerimeters(map, island_points, params)
%GETPERIMETER Returns all the points on island that TOUCH water
% BFS where if node touches water, add to perimeter
% all_perimeters: row = x_idx, col = y_idx, dim3 = island

import java.util.LinkedList
q = LinkedList();

% visited is a loaded boolean representing both
% 1. The location on the map is currently in the queue OR
% 2. The location on the map has been expanded in the BFS
visited = [];

all_perimeters = [];

for k = 1:size(island_points, 1)
    
    q.clear();
    q.add(island_points(k,:));
    visited = zeros(size(map));
    perimeter = [];

    while (q.size() ~= 0)

        loc = q.remove()';

        % Add location to perimeter if it touches water
        touches_water = 0;
        for j = 1:size(params.neighbors,1)

            adj_loc = loc + params.neighbors(j,:);
            if (isWithinMap(adj_loc, params) && ...
                    map(adj_loc(1), adj_loc(2)) == 0) 
                touches_water = 1;
                break
            end
        end

        if (touches_water == 1)
            perimeter = vertcat(perimeter, loc);
        end

        % Expand neighbors
        for i = 1:size(params.neighbors,1)

            neighbor = loc + params.neighbors(i,:);

            % Neighbor must be within map
            if (isWithinMap(neighbor, params) == 0)
                continue
            end

            % Neighbor must be land
            if (map(neighbor(1), neighbor(2)) ~= 1)
                continue
            end

            % Neighbor must not be visited (not expanded yet / not in queue)
            if (visited(neighbor(1), neighbor(2)) == 1)
                continue
            end

            visited(neighbor(1), neighbor(2)) = 1;
            q.add(neighbor);
        end

    end
    
    all_perimeters = [all_perimeters; perimeter];

end

