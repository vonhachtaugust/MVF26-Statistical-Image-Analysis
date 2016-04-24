clc;
clf;
clear all;
warning('off','all')

%%%%%% Parameters %%%%%%
threshold = 90;
k = 1;
sigma = .8;

%%%%%% Read and paint image %%%%%%
figure(1)
img = imread('8.jpg');
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
