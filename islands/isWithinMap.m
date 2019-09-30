function [valid] = isWithinMap(idx, params)
%ADDIDXTOQUEUE Returns true or false depending on if idx ([row, col] fits
%within the map

valid = 1;
row = idx(1);
col = idx(2);

if (row < 1 || row > params.map_size_rows)
    valid = 0;
    return
end

if col < 1 || col > params.map_size_cols
   valid = 0;
   return
end

end

