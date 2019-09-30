function [graph] = generateGraph(params)
%GENERATEGRAPH Returns a matrix of nodes

graph = [];

for i = 1:params.map_size_rows
    
    graph_row = [];
    for j = 1:params.map_size_cols
        node.cost     = 0;
        node.queued   = 0;
        node.explored = 0;
        node.parent   = [];
        
        % 0 represents water and 1, 2 .. is the island number
        node.island_id   = 0;
        
        graph_row = [graph_row, node];
    end
    
    graph = [graph; graph_row];
end

end

