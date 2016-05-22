function nu = getCentralMoments(binaryImage, p, q);
% Assumes binaryImage object is white, black background.
[row,col] = size(binaryImage);
mu = 0;

X = getMoment(binaryImage,1,0)/getMoment(binaryImage,0,0);
Y = getMoment(binaryImage,0,1)/getMoment(binaryImage,0,0);

for x = 1:row
    for y = 1:col
        mu = mu + ( (x-X)^p )*( (y-Y)^q )*binaryImage(x,y);
    end
end
nu = mu / (sum(sum(binaryImage)))^((p+q+2)/2);







