function neighbors = eightNeigbors(row,col);
neighbors = [];

for i = -1:1
    for j = -1:1
        if i == 0 && j == 0
            ;
        else
            neighbors = [neighbors; [row+i col+j]];
        end
    end
end
