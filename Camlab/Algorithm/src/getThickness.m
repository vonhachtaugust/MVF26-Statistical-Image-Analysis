function thickness = getThickness(binaryImage)
% Twice the number of erode operations to make 
% all object pixels disappear
NHOOD = [1 1 1; 1 0 1; 1 1 1];
thickness = 0;

while sum(sum(binaryImage)) ~= 0
    binaryImage = imerode(binaryImage,NHOOD);
    thickness = thickness + 1;
end
thickness = 2*thickness;

