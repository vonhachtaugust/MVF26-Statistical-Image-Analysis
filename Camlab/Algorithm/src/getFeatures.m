function features = getFeatures(binaryImage)

features = [];

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

% Ration:


% Formfactor:
features = [features 4*pi*area/(perimeter^2)];

% Elongatedness:
%features = [features area/((thickness)^2)];

% Convexity:
features = [features convexperim/perimeter];

% Solidity
%features = [features area/convexarea];

% Area moment 1
features = [features (n20+n02)];
    
% Area moment 2
features = [features ((n20-n02)^2+4*n11^2)];

% Area moment 3
features = [features ((n30-3*n12)^2+(n03-3*n21)^2)];

% Area moment 4 
features = [features ((n30+n12)^2+(n03+n21)^2)];

% Perimeter moment 1
features = [features ((n30-3*n12)*(n30+n12)*((n30+n12)^2-3*(n21+n03)^2) + (n03-3*n21)*(n03+n21)*((n03+n21)^2-3*(n12+n30)^2))];

% Perimeter moment 2
features = [features ((n20-n02)*((n30+n12)^2-(n21+n03)^2) + 4*n11*(n30+n12)*(n21+n03))];

% Perimeter moment 3
features = [features ((3*n21-n03)*(n30+n12)*((n30+n12)^2-3*(n21+n03)^2) - (n30-3*n12)*(n21+n03)*(3*(n30+n12)^2-(n21+n03)^2))];