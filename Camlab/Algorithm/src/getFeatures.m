function features = getFeatures(binaryImage,featurelist)


perimeter = sum(sum(bwperim(binaryImage)));
area = bwarea(binaryImage);
%thickness = (perimeter - sqrt(perimeter^2-8*area))/4;
thickness = getThickness(~binaryImage);
convexperim = sum(sum(bwperim(bwconvhull(~binaryImage))));
convexarea = bwarea(bwconvhull(~binaryImage));

n20 = getCentralMoments(binaryImage,2,0);
n02 = getCentralMoments(binaryImage,0,2);
n11 = getCentralMoments(binaryImage,1,1);
n30 = getCentralMoments(binaryImage,3,0);
n03 = getCentralMoments(binaryImage,0,3);
n12 = getCentralMoments(binaryImage,1,2);
n21 = getCentralMoments(binaryImage,2,1);
features = [];

% Ratio:
if any(featurelist == 1)
    features = [features size(binaryImage,1)/size(binaryImage,2)];
end

% Formfactor:
if any(featurelist == 2)
    features = [features 4*pi*area/(perimeter^2)];
end

% Elongatedness:
if any(featurelist == 3)
    %features = [features area/((thickness)^2)];
end

% Convexity:
if any(featurelist == 4)
    features = [features convexperim/perimeter];
end

% Solidity
if any(featurelist == 5)
    %features = [features area/convexarea];
end

% Area moment 1
if any(featurelist == 6)
    features = [features (n20+n02)];
end

% Area moment 2
if any(featurelist == 7)
    features = [features ((n20-n02)^2+4*n11^2)];
end

% Area moment 3
if any(featurelist == 8)
    features = [features ((n30-3*n12)^2+(n03-3*n21)^2)];
end

% Area moment 4
if any(featurelist == 9)
    features = [features ((n30+n12)^2+(n03+n21)^2)];
end

% Perimeter moment 1
if any(featurelist == 10)
    features = [features ((n30-3*n12)*(n30+n12)*((n30+n12)^2-3*(n21+n03)^2) + (n03-3*n21)*(n03+n21)*((n03+n21)^2-3*(n12+n30)^2))];
end

% Perimeter moment 2
if any(featurelist == 11)
    features = [features ((n20-n02)*((n30+n12)^2-(n21+n03)^2) + 4*n11*(n30+n12)*(n21+n03))];
end

% Perimeter moment 3
if any(featurelist == 12)
    features = [features ((3*n21-n03)*(n30+n12)*((n30+n12)^2-3*(n21+n03)^2) - (n30-3*n12)*(n21+n03)*(3*(n30+n12)^2-(n21+n03)^2))];
end
