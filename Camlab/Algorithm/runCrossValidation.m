clc;
load('database/classificationDatabase.mat');
load('database/database.mat');
addpath('src','images','database');
bestScore = 1;
% for nrOfFeatures = 1:8
    
    featurelist = nchoosek(1:12,11);
    
    for combNr=1:size(featurelist,1)
        combNr
        score = getCrossValidation(classificationDatabase,database,featurelist(combNr,:));
        if score < bestScore
            bestScore = score;
            bestPerm = featurelist(combNr,:);
        end
        
    end
% end