clc
clf
clearvars
warning('off','all')

% Read image:---------------------------------------------------
I = imread('Images/dbImages/2.jpg');
I = rgb2gray(I) > 100;
figure(1), imshow(I);

I2 = I;

NHOOD = [1,1,1; 1,0,1; 1,1,1];
dilates_and_erodes = 8;
for i = 1 : dilates_and_erodes
    I2 = imdilate(I2,NHOOD);
end
for j = 1 : dilates_and_erodes
    I2 = imerode(I2,NHOOD);
end
% figure(2), imshow(I2);

% Hough transformation:----------------------------------------
Ir_edge = edge(I2,'Canny');
[H,T,R] = hough(Ir_edge, 'Theta', -10:0.2:10);
[H2,T2,R2] = hough(Ir_edge, 'Theta', [(80:0.2:89.8),(-89.8:0.2:-80)]);

% Plot of hough matrix and its peaks

% Plot hough matrix:-------------------------------------------
clf(1),figure(1),imshow(imadjust(mat2gray(H)),'XData',T,'YData',R,...
    'InitialMagnification','fit');
title('Hough transform');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal;
colormap(hot);

% Locate and plot peaks in hough matrix:------------------------
P = houghpeaks(H,18,'threshold',ceil(0.5*max(H(:))));
P2 = houghpeaks(H2,18,'threshold',ceil(0.5*max(H2(:))));
% x = T(P(:,2));
% y = R(P(:,1));
% hold on, plot(x,y,'s','color','blue');

% Find and plot vertical lines from hough transformation

% Locate lines based on peaks in hough matrix:------------------
lines = houghlines(Ir_edge,T,R,P,'FillGap',5,'MinLength',7);

% Plot lines and mark beginning/end in original image:----------
figure(3), imshow(I), hold on
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end

sum = 0;
for i = 1:length(lines)
    sum = sum + lines(i).theta;
end
sum = sum/i;

% Find and plot horizontal lines from hough transformation

% Locate lines based on peaks in hough matrix:-----------------
lines2 = houghlines(Ir_edge,T2,R2,P2,'FillGap',5,'MinLength',7);

% Plot lines and mark beginning/end in original image:---------
figure(3), imshow(I), hold on
for k = 1:length(lines2)
    xy = [lines2(k).point1; lines2(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end

sum2 = 0;
for i = 1:length(lines2)
    if lines2(i).theta > 0
        sum2 = sum2 + lines2(i).theta;
    else
        sum2 = sum2 + 180 + lines2(i).theta;
    end
end
sum2 = sum2/i - 90;

% Rotate by angle:-----------------------------------------------
angle = (sum + sum2) / 2;
disp(['Angle corrected: ', num2str(angle), 'degrees']);
NEWIMAGE = imrotate(I,angle,'bilinear');

% Clear borders:-------------------------------------------------
BW2 = imclearborder(~NEWIMAGE);
NEWNEWIMAGE = ~BW2;
figure(4), imshow(NEWNEWIMAGE)

% Extend borders to frame:----------------------------------------
searchResolution = 20;
NEWNEWIMAGE = extendBorders(NEWNEWIMAGE,searchResolution);

NEWNEWNEWIMAGE = imdilate(imerode(NEWNEWIMAGE,NHOOD),NHOOD);
figure(5), imshow(NEWNEWNEWIMAGE);

% Extract Textbox:------------------------------------------------
width = size(NEWNEWNEWIMAGE,2);
height = size(NEWNEWNEWIMAGE,1);

textbox = NEWNEWNEWIMAGE(0.05*height:0.107*height , 0.081*width:0.75*width);

BW3 = imclearborder(~textbox);
textbox = ~BW3;

% textbox = imerode(imdilate(textbox,NHOOD),NHOOD);
% textbox = imdilate(imerode(textbox,NHOOD),NHOOD);


figure(6), imshow(textbox);
%% Extract each letter and insert into struct names "letters"
clear letters

middle = ceil(size(textbox,1) /2);
counter = 0;
i = 1;
while i < size(textbox,2)
    if textbox(middle,i) == 0;
        counter = counter + 1;
        structName = ['nr' ,num2str(counter)];
        [glyph, backtrack] = letterFiller(textbox,middle,i);
        letters.(structName) = glyph;
        i = i + size(glyph,2) - backtrack;
    else
        i = i + 1;
    end
end

%% Automatically read and add all letters to database
%%%%%% Read and paint character %%%%%%
charNumber = 2;
texter = ocr(textbox);
disp(texter.Text(charNumber));
Bpos = texter.CharacterBoundingBoxes(charNumber,:);
newTextbox = textbox(Bpos(2):Bpos(2)+Bpos(4)-1,Bpos(1):Bpos(1)+Bpos(3)-1);
figure(7),imshow(newTextbox)
texter.Text

%%%%%% Put all characters with glyph into database %%%%%%
load('database.mat')
for i = 1:size(texter.Text,2)-2
    structName = texter.Text(i);
    if isletter(structName)%(structName ~= ' ')% && ~(strcmp(structName, '\n'))
        Bpos = texter.CharacterBoundingBoxes(i,:);
        newTextbox = textbox(Bpos(2):Bpos(2)+Bpos(4)-1,Bpos(1):Bpos(1)+Bpos(3)-1);
        database.(structName).glyph = newTextbox;
    end
end
save('database.mat','database');
