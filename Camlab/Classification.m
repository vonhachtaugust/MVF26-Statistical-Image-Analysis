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


%%
figure(1)

% Upper letters
field = fieldnames(databaseUpper);
letterDatabase = databaseUpper;

% Lower letters:
%field = fieldnames(databaseLower);
%letterDatabase = databaseLower;

for i = 1:numel(field);
    I = letterDatabase.(field{i}).glyph;
    
    perimeter = sum(sum(bwperim(I)));
    area = bwarea(I);
    thickness = (perimeter - sqrt(perimeter^2-8*area))/4;
    convexperim = sum(sum(bwperim(bwconvhull(~I))));
    
    Y = 4*pi*area/(perimeter^2); % Formfactor
    X = area/(thickness^2); % Elongatedness
    Z = convexperim/perimeter; % Convexity
    
    scatter3(X,Y,Z,'.')
    
    le = 0.005;
    text(X + le,Y + le,Z + le, field(i));
    
    hold on
end
title('Feature space');
xlabel('Formfactor'), ylabel('Elongatedness'), zlabel('Convexity');
axis on, axis normal;

