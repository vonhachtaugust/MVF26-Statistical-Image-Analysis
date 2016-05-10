function neighbours = Neighbours(row,col)
neighbours = [];
for i = -1:1
  for j = -1:1
    if abs(i) || abs(j) 
      neighbours = [neighbours; row+i, col+j];
    end
  end
end
