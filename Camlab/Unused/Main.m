clc;
clf;
clear all;
warning('off','all')

%% Create webcam object and obtain an image:

clear cam;
cam = webcam(1);
%preview(cam);
img = snapshot(cam);
image(img);

clear cam;
%% binaryResample

I = imread('mtglol.png');
I = rgb2gray(I) > 140;
figure(1), imshow(I);
Ir = binaryResample(I,1.5,0.5);
figure(2), imshow(Ir);

%% Database: Magnifiy image by 10 in each dimension

load('database.mat');
figure(1), imshow(database.h.glyph);
I = binaryResample(database.h.glyph,10,10);
figure(2), imshow(I);

%% Morphological operations (binary)

searchResolution = 1;

% Read image:
I = imread('Images/dbImages/7.jpg');
I = rgb2gray(I) > 100;

BW = imclearborder(~I);
I = ~BW;

newI = extendBorders(I,searchResolution);
figure(1), imshow(newI);

%NHOOD = [1,1,1; 1,1,1; 1,1,1];
%Ir = imerode(I,NHOOD);
%Ir = imdilate(Ir,NHOOD);
%figure(2), imshow(Ir);
I2 = I;

NHOOD = [1,1,1; 1,0,1; 1,1,1];
dilates_and_erodes = 8;
for i = 1 : dilates_and_erodes
    I2 = imdilate(I2,NHOOD);
end
for j = 1 : dilates_and_erodes
    I2 = imerode(I2,NHOOD);
end

BW2 = imclearborder(~I2);
I2 = ~BW2;

newI2 = extendBorders(I2,searchResolution);

figure(2), imshow(newI2);

%% Hough transformation

Ir_edge = edge(I2,'Canny');
[H,T,R] = hough(Ir_edge, 'Theta', -10:0.2:10);
[H2,T2,R2] = hough(Ir_edge, 'Theta', [(80:0.2:89.8),(-89.8:0.2:-80)]);

%% Plot of hough matrix and its peaks

% Plot hough matrix
clf(1),figure(1),imshow(imadjust(mat2gray(H)),'XData',T,'YData',R,...
    'InitialMagnification','fit');
title('Hough transform');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal;
colormap(hot);

% Locate and plot peaks in hough matrix
P = houghpeaks(H,18,'threshold',ceil(0.5*max(H(:))));
P2 = houghpeaks(H2,18,'threshold',ceil(0.5*max(H2(:))));
x = T(P(:,2));
y = R(P(:,1));
hold on, plot(x,y,'s','color','blue');

%% Find and plot vertical lines from hough transformation

% Locate lines based on peaks in hough matrix
lines = houghlines(Ir_edge,T,R,P,'FillGap',5,'MinLength',7);

% Plot lines and mark beginning/end in original image
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

%% Find and plot horizontal lines from hough transformation

% Locate lines based on peaks in hough matrix
lines2 = houghlines(Ir_edge,T2,R2,P2,'FillGap',5,'MinLength',7);

% Plot lines and mark beginning/end in original image
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

%% Rotate by angle
angle = (sum + sum2) / 2;
disp(angle);
NEWIMAGE = imrotate(I,angle,'bilinear');

% Clear borders
BW2 = imclearborder(~NEWIMAGE);
NEWNEWIMAGE = ~BW2;
figure(4), imshow(NEWNEWIMAGE)

%% Extend borders to frame
NEWNEWIMAGE = extendBorders(NEWNEWIMAGE,searchResolution);

NEWNEWNEWIMAGE = imdilate(imerode(NEWNEWIMAGE,NHOOD),NHOOD);
% NEWNEWNEWIMAGE = imdilate(imerode(NEWNEWNEWIMAGE,NHOOD),NHOOD);
imshow(NEWNEWNEWIMAGE);
%% Extract Textbox
width = size(NEWNEWNEWIMAGE,2);
height = size(NEWNEWNEWIMAGE,1);

textbox = NEWNEWNEWIMAGE(0.06*height:0.103*height , 0.081*width:0.75*width);
figure(5), imshow(textbox);



%%
clc;

%%%%%% Parameters %%%%%%
threshold = 90;
k = 1;
sigma = .8;

%%%%%% Read and paint image %%%%%%
figure(1)
img = imread('Images\dbImages/26.jpg');
imshow(img)

%%%%%% Binarize and paint image %%%%%%
tmpMatrix = img(:,:,1)/3 + img(:,:,2)/3 + img(:,:,3)/3;
tmpMatrix = (tmpMatrix > threshold);
figure(2)
imshow(tmpMatrix);

%%%%%% Extract textbox (Assuming perfect align) %%%%%%
vertpixs = floor(size(tmpMatrix(:,:,1),1)*0.88/8.8);
vertindent = vertpixs * 0.54;
hortpixs = floor(size(tmpMatrix(:,:,1),2)/6);
hortindent = floor(size(tmpMatrix(:,:,1),2)*.5/6.3);
tmpMatrix(:,1:hortindent,:) = [];
tmpMatrix(:,end-hortindent:end,:) = [];
tmpMatrix(vertpixs:end,:,:) = [];
tmpMatrix(1: vertindent ,:,:) = [];
figure(3)
imshow(tmpMatrix);

%%%%%% Apply Gaussian blur to textbox %%%%%%
blurred = GaussianBlur(tmpMatrix,k,sigma);
figure(4)
imshow(blurred);

%%%%%% Read and paint character %%%%%%
charNumber = 1;
texter = ocr(tmpMatrix);
disp(texter.Text(charNumber));
Bpos = texter.CharacterBoundingBoxes(charNumber,:);
newTmpMatrix = tmpMatrix(Bpos(2):Bpos(2)+Bpos(4)-1,Bpos(1):Bpos(1)+Bpos(3)-1);
figure(5)
imshow(newTmpMatrix)
texter.Text

%%%%%% Put all characters with glyph into database %%%%%%
load('database.mat')
for i = 1:size(texter.Text,2)-2
    structName = texter.Text(i);
    if isletter(structName)%(structName ~= ' ')% && ~(strcmp(structName, '\n'))
        Bpos = texter.CharacterBoundingBoxes(i,:);
        newTmpMatrix = tmpMatrix(Bpos(2):Bpos(2)+Bpos(4)-1,Bpos(1):Bpos(1)+Bpos(3)-1);
        database.(structName).glyph = newTmpMatrix;
    end
end
save('database.mat','database');
