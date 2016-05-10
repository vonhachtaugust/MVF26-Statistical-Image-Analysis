clc;
clf;
clear all;
warning('off','all')


%% Create webcam object and obtain an image:
% Clear the camera.
clear cam;

% Connect to the webcam. (if such exists and requires matlab package)
cam = webcam(1);
%preview(cam); 

img = snapshot(cam);

% Display the frame in a figure window.
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
clf;
% Read image:
I = imread('23.jpg');
I = rgb2gray(I) > 60;
% figure(1), imshow(I);

% Opening then closing:
% I = dilate(erode(I2)); % Opening

% I = dilate(erode(I2)); % Opening
% I = erode(dilate(I2)); % Closing
% I = erode(dilate(I)); % Closing
% figure(2), imshow(Ir);

% Edge filter:
Ir_edge = edge(I,'Canny');
% [H,T,R] = hough(Ir_edge, 'Theta', [(80:0.2:89.99),(-90:0.2:-80)]);
[H,T,R] = hough(Ir_edge, 'Theta', -10:0.2:10);

figure(1)
% subplot(2,1,1);
% imshow(Ir_edge)
% title('Original edges');
% subplot(2,1,2);
imshow(imadjust(mat2gray(H)),'XData',T,'YData',R,...
      'InitialMagnification','fit');
title('Hough transform of gantrycrane.png');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(hot);

P = houghpeaks(H,8,'threshold',ceil(0.5*max(H(:))));
x = T(P(:,2));
y = R(P(:,1));
plot(x,y,'s','color','blue');

lines = houghlines(Ir_edge,T,R,P,'FillGap',5,'MinLength',7);

figure(2), imshow(I), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
% highlight the longest line segment
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');

sum = 0;
for i = 1:length(lines)
%     if lines(i).theta > 0
        sum = sum + lines(i).theta;
%     else
%         sum = sum + 180 + lines(i).theta;
%     end
end
sum = sum/i
%%
clc; 

%%%%%% Parameters %%%%%%
threshold = 90;
k = 1;
sigma = .8;

%%%%%% Read and paint image %%%%%%
figure(1)
img = imread('6.jpg');
% img = imread('Realms-Uncharted.jpg');
% img = imread('mtglol.png');
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
% alphabet = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'];
load('database.mat')
for i = 1:size(texter.Text,2)-2
    structName = texter.Text(i);
    if (structName ~= ' ')% && ~(strcmp(structName, '\n'))
        Bpos = texter.CharacterBoundingBoxes(i,:);
        newTmpMatrix = tmpMatrix(Bpos(2):Bpos(2)+Bpos(4)-1,Bpos(1):Bpos(1)+Bpos(3)-1);
        database.(structName).glyph = newTmpMatrix;
    end
end
save('database.mat','database');
