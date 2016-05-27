clc;
load('database/classificationDatabase.mat');
load('database/database.mat');

for nrOfFeatures = 1:12
    
    featurelist = nchoosek(1:12,(13-nrOfFeatures));
    
    for combNr=1:size(featurelist,1)
        combNr
        score = getCrossValidation(classificationDatabase,database,featurelist(combNr,:));
        if score < bestScore
            bestScore = score;
            bestPerm = featurelist;
        end
        
    end
end