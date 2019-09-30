function [path] = shortestPath(requested_path, graph, params)
%SHORTESTPATH Returns the shortest path requested in requestedPath
% Treats the traversal cost to be equivalent for all moves
%   requestedPath: [island1, island2]

import java.util.LinkedList
q = LinkedList();

% Add all nodes in queue that belong to island1
ids = reshape([graph(:,:).island_id], [], params.map_size_cols);
[r, c] = find(ids == 1);
for i = 1:length(r)
    q.add([r(i), c(i)]);
    
    % For each node added, initialize cost to 0,
    % Set the node to be marked as queued
    % Set the parent to be [0,0]
    graph(r(i),c(i)).cost   = 0;
    graph(r(i),c(i)).queued = 1;
    graph(r(i),c(i)).parent = [0, 0]; % Indicating no parent
end

path_found = 0;
while (q.size() ~= 0)
    node_idx = q.remove()';
    
    % Mark node as not queued anymore
    graph(node_idx(1), node_idx(2)).queued = 0;
    
    % Mark node as explored
    graph(node_idx(1), node_idx(2)).explored = 1;
    
    % Get neighbors
    neighbors = [];
    for i = 1:size(params.neighbors, 1)
        n_x = node_idx(1)+params.neighbors(i,1);
        n_y = node_idx(2)+params.neighbors(i,2);
        
        if isWithinMap([n_x, n_y], params)
            neighbors = vertcat(neighbors, [n_x, n_y]);
        end
    end
    
    % For each node that is:
    % 1. not in the queue
    % 2. not water or island 2
    % 3. not explored
    % ... add to the queue
    for i = 1:size(neighbors, 1)
        n_x = neighbors(i,1);
        n_y = neighbors(i,2);
        
        % Short circuit only possible since BFS will generate shortest path
        % to every single node... for other searches need to check goal
        % criteria until after the node is popped off of the queue
        
        % Check if node meets goal criteria
        if graph(n_x, n_y).island_id == requested_path(2)
            path_found = 1;
            dest = [n_x, n_y];
            
            graph(n_x, n_y).cost   = graph(node_idx(1), node_idx(2)).cost + 1;
            graph(n_x, n_y).parent = node_idx;
            break
        end
        
        if graph(n_x, n_y).queued == 1
           continue 
        end
        
        if graph(n_x, n_y).explored == 1
            continue
        end
        
        if graph(n_x, n_y).island_id ~= 0
            continue
        end
        
        % For each valid neighbor:
        % set queued for node to be true
        % set cost for node to go up by 1
        % set the parent correctly

        graph(n_x, n_y).queued = 1;
        graph(n_x, n_y).cost   = graph(node_idx(1), node_idx(2)).cost + 1;
        graph(n_x, n_y).parent = node_idx;
        
        q.add([n_x, n_y]);
    end
    
    if path_found == 1
        break
    end
end


path = [];
if path_found
   % Generate path
   disp('Yay! Path is found!')
   
   node = dest;
   while (node(1) ~= 0 && node(2) ~= 0)
       path = [path; node];
       node = graph(node(1), node(2)).parent;
   end
end

end

