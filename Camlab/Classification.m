clear all;
clc;
clf;

%% Database

load('database.mat');

%%

% Find perimeter of objects in binary image

fields = fieldnames(database);
points = zeros(numel(fields),3);

databaseUpper = struct;
databaseLower = struct;

for i = 1:numel(fields)
    glyph = database.(fields{i}).glyph;
    tf = isstrprop(fields(i),'upper');
    
    if tf{1}
     databaseUpper.(fields{i}).glyph = glyph;
    else
     databaseLower.(fields{i}).glyph = glyph;
    end
end

%% Upper letters
figure(1)
upperFields = fieldnames(databaseUpper);

for i = 1:numel(upperFields);
    I = databaseUpper.(upperFields{i}).glyph;
    
    perimeter = sum(sum(bwperim(I)));
    area = bwarea(I);
    thickness = (perimeter - sqrt(perimeter^2-8*area))/4;
    convexperim = sum(sum(bwperim(bwconvhull(~I))));
    
    Y = 4*pi*area/(perimeter^2); % Formfactor
    X = area/(thickness^2); % Elongatedness
    Z = convexperim/perimeter; % Convexity
    
    scatter3(X,Y,Z,'.')
    
    le = 0.005;
    text(X + le,Y + le,Z + le, upperFields(i));
    
    hold on
end
title('Feature space');
xlabel('Formfactor'), ylabel('Elongatedness'), zlabel('Convexity');
axis on, axis normal;


%% Lower letters 
figure(2)
lowerFields = fieldnames(databaseLower);

for i = 1:numel(lowerFields);
    I = databaseLower.(lowerFields{i}).glyph;
    
    perimeter = sum(sum(bwperim(I)));
    area = bwarea(I);
    thickness = (perimeter - sqrt(perimeter^2-8*area))/4;
    convexperim = sum(sum(bwperim(bwconvhull(~I))));7
    
    Y = 4*pi*area/(perimeter^2); % Formfactor
    X = area/(thickness^2); % Elongatedness
    Z = convexperim/perimeter; % Convexity
    
    scatter3(X,Y,Z,'.')
    
    le = 0.001;
    text(X + le,Y + le,Z + le, lowerFields(i));
    
    hold on
end
title('Feature space');
xlabel('Formfactor'), ylabel('Elongatedness'), zlabel('Convexity');
axis on, axis normal;

