
load('database/classificationDatabase.mat');
load('database/database.mat');
addpath('src','images','database')
bestFeatureList = ones(12,12);
bestScore = ones(12,1);

for i = 1:12
    if i > 1
        featureList = bestFeatureList(i-1,:);
    else
        featureList = 1:12; 
    end
    positions = find(featureList > 0);
    for j = 1:size(positions)
        tmpFeatureList = featureList;
        tmpFeatureList(j) = 0;
        score = getCrossValidation(classificationDatabase,database,tmpFeatureList);
        if score < bestScore(i)
            bestScore(i) = score;
            bestFeatureList(i,:) = tmpFeatureList;          
        end
    end
end