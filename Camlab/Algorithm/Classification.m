clear all;
clc;
%clf;

% Add source files to path
if ispc
    path(path,'./src');
    path(path,'./images');
    path(path,'./database');
else
    path(path,'./src');
    path(path,'./images');
    path(path,'./database');
end


% Load necessary data
I = imread('images\7.jpg');
%figure(1), imshow(I);
load('database\database_highres.mat');
load('database\classificationDatabase.mat');
letters = getLetters2(I);

%% Compare with database
%database = databaseLower;
letterFields = fieldnames(letters);
euclidean = struct;


for i = 1:numel(fieldnames(letters))
    fields = fieldnames(database);
    len = numel(fieldnames(database));
    
    features = getFeatures(letters.(letterFields{i}));
    letter = letters.(letterFields{i});
    [height, width] = size(letter);
    
    for j = 1:len
        databaseFeatures = getFeatures(database.(fields{j}).glyph);
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
end
