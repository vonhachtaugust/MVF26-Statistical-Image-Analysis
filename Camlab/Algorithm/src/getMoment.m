function Mij = getMoment(binaryImage, i, j)
[row, col] = size(binaryImage);
Mij = 0;
for x = 1:row
    for y = 1:col
        Mij = Mij + (x^i)*(y^j)*binaryImage(x,y);
    end
end

