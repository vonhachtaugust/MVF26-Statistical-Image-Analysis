clear all;
clc;
clf;

%% Database set visualize:
load('databaseLowerCase.mat');
load('databaseUpperCase.mat');
figure(1)

% Upper letters
%field = fieldnames(databaseUpper);
%letterDatabase = databaseUpper;

% Lower letters:
field = fieldnames(databaseLower);
letterDatabase = databaseLower;

for i = 1:numel(field);
    I = letterDatabase.(field{i}).glyph;
    
    perimeter = sum(sum(bwperim(I)));
    area = bwarea(I);
    thickness = (perimeter - sqrt(perimeter^2-8*area))/4;
    convexperim = sum(sum(bwperim(bwconvhull(~I))));
    convexarea = bwarea(bwconvhull(~I));
    
    X = 4*pi*area/(perimeter^2); % Formfactor
    Y = area/(thickness^2); % Elongatedness
    Z = convexperim/perimeter; % Convexity
    W = area/convexarea; % Solidity
    
    
    scatter3(X,Y,W,'.')
    %plot(X,Y,'.','MarkerSize',20);
    
    le = 0; %0.005;
    text(X + le,Y + le,W + le, field(i));
    %text(X + le, Y + le, field(i),'FontSize',14);
    
    hold on
end
%title('Feature space');
xlabel('Formfactor'), ylabel('Elongatedness'), zlabel('Solidity');
%xlabel('Formfactor'), ylabel('Elongatedness');
axis on, axis normal;

%% Database with letters and their size independent features
load('databaseLowerCase.mat');
load('databaseUpperCase.mat');

for k = 1:2
    if k == 1
        database = databaseUpper;
    else
        database = databaseLower;
    end
    
    fields = fieldnames(database);
    letterDatabase = database;
    
    features = struct;
    
    for i = 1:numel(fields)
        I = letterDatabase.(fields{i}).glyph;
        
        perimeter = sum(sum(bwperim(I)));
        area = bwarea(I);
        thickness = (perimeter - sqrt(perimeter^2-8*area))/4;
        convexperim = sum(sum(bwperim(bwconvhull(~I))));
        convexarea = bwarea(bwconvhull(~I));
        
        % Char and corresponding glyph:
        features.(fields{i}).glyph = I;
        
        % Formfactor:
        features.(fields{i}).formfactor = 4*pi*area/(perimeter^2);
        
        % Elongatedness:
        features.(fields{i}).elongatedness = area/(thickness^2);
        
        % Convexity:
        features.(fields{i}).convexity = convexperim/perimeter;
        
        % Solidity
        features.(fields{i}).solidity = area/convexarea;
    end
    
    if k == 1
        save('databaseUpperCaseFeatures.mat','features');
    else
        save('databaseLowerCaseFeatures.mat','features');
    end
end

%% Database to separate lower and uppercase letters.
load('database.mat');

% Find perimeter of objects in binary image

fields = fieldnames(database);

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

%save('databaseUpperCase.mat','databaseUpper');
%save('databaseLowerCase.mat','databaseLower');