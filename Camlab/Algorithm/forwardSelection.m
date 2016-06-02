
load('database/training.mat');
load('database/reference.mat');
addpath('src','images','database')
bestFeatureList = zeros(1,12);
bestScore = ones(12,1);

for i = 1:12
    featureList = bestFeatureList;
    for j = 1:12
        featureList(i) = j;
        disp([i,j])
        score = getCrossValidation(training,reference,featureList);
        if score < bestScore(i)
            bestScore(i) = score;
            bestFeatureList = featureList;          
        end
    end
end