clear all;
clc;
%clf;

% Add source files to path
if ispc
    path(path,'./src');
    path(path,'./images');
    path(path,'./database');
    path(path,'./database/ClassificationDatabase');
else
    path(path,'./src');
    path(path,'./images');
    path(path,'./database');
    path(path,'./database/ClassificationDatabase');
end


% Load necessary data
I = imread('images\7.jpg');
%figure(1), imshow(I);
load('database\database_highres.mat');
load('database\ClassificationDatabase\classDatabase.mat');
letters = getLetters2(I);

%% Compare with database
%database = databaseLower;
letterFields = fieldnames(letters);
euclidean = struct;


% featurelist = randperm(12,2+ceil(rand*8));
for nrOfFeatures = 1:12
    featurelist = nchoosek(1:12,(13-nrOfFeatures));
    for combNr=1:size(featurelist,1)
        for i = 1:numel(fieldnames(letters))
            fields = fieldnames(database);
            len = numel(fieldnames(database));
            
            features = getFeatures(letters.(letterFields{i}),featurelist(combNr,:));
            letter = letters.(letterFields{i});
            [height, width] = size(letter);
            
            for j = 1:len
                databaseFeatures = getFeatures(database.(fields{j}).glyph,featurelist(combNr,:));
                euclidean.(fields{j}).norm = norm(databaseFeatures-features);
                
                databaseGlyph = binaryResample(database.(fields{j}).glyph, width, height);
                densityMatrix = (~letter).*(databaseGlyph);
                euclidean.(fields{j}).density = (sum(sum(densityMatrix))/(height*width))^2;
            end
            min = 10000;
            let = -1;
            for k = 1:len
                val = euclidean.(fields{k}).norm * (euclidean.(fields{k}).density);
                if val < min
                    min = val;
                    let = fields{k};d
                end
            end
            disp(let);
            score = getCrossValidation(classificationDatabase,database,featurelist(combNr,:)); 
            if score < bestScore
                bestScore = score;
                bestPerm = featurelist;
            end
        end
    end
end