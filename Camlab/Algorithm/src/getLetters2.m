function letters = getLetters2(RGBimage)
%%%%%%%%%% PARAMETERS %%%%%%%%%%%

nhood1 = [0,1,0; 1,0,1; 0,1,0]; %neumann neighbourhood
nhood2 = [1,1,1; 1,0,1; 1,1,1]; %complete euclidean neighbourhood
% nhood3 = [0,1,1,1,0; 1,1,0,1,1; 0,1,1,1,0]; %complete euclidean neighbourhood
maxAngle = 10; % Maximum angle of picture in degrees
binarizationThreshold = 70; %[0,255]
dilates_and_erodes = 8; % Number of times to erode and dilate before hough transform
houghLineThreshold = 0.5; % Threshold for how "strong" lines must be to be included
maximumHoughLines = 18; % Maximum number of lines to be found by hough transformation
searchResolution = 20; % Resolution when searching for borders of card, recommended max 1/50 of picture size, lower when large angles allowed for card

%%%%%%%%%% END OF PARAMETERS %%%%%%%%%%

I_bin = rgb2gray(RGBimage) > binarizationThreshold;
% figure(2), imshow(I_bin);
figure(2), imhist(rgb2gray(I));
A = imhist(rgb2gray(I));
B = zeros(size(A,1),1);
meansize = 4;
for i = 1+meansize: size(A,1)-meansize
    B(i) = sum(A(i-meansize:i+meansize))/(meansize*2+1);
end
hold on
plot(B)

% Apply erosion 10 times, then dilation 10 times to remove clutter
I_bin2 = I_bin;
for i = 1 : dilates_and_erodes
    I_bin2 = imdilate(I_bin2,nhood2);
end
for j = 1 : dilates_and_erodes
    I_bin2 = imerode(I_bin2,nhood2);
end
figure(3), imshow(I_bin2);

% Hough transformation ----------------------------------------
I_edge = edge(I_bin2,'Canny');
[H,T,R] = hough(I_edge, 'Theta', -maxAngle:0.2:maxAngle);
[H2,T2,R2] = hough(I_edge, 'Theta', [(90-maxAngle:0.2:89.8),(-89.8:0.2:maxAngle-90)]);

% Plot hough matrix -------------------------------------------
figure(4),imshow(imadjust(mat2gray(H)),'XData',T,'YData',R,...
    'InitialMagnification','fit');
title('Hough transform'); xlabel('\theta'), ylabel('\rho'); axis on, axis normal;
colormap(hot);

% Locate and plot peaks in hough matrix ------------------------
P = houghpeaks(H,maximumHoughLines,'threshold',ceil(houghLineThreshold*max(H(:))));
P2 = houghpeaks(H2,maximumHoughLines,'threshold',ceil(houghLineThreshold*max(H2(:))));
x = T(P(:,2));
y = R(P(:,1));
hold on, plot(x,y,'s','color','blue');

% Locate lines based on peaks in hough matrix ------------------
lines = houghlines(I_edge,T,R,P,'FillGap',5,'MinLength',7);

% Plot lines and mark beginning/end in original image ----------
figure(5), imshow(I_bin), hold on
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

% Locate lines based on peaks in hough matrix:-----------------
lines2 = houghlines(I_edge,T2,R2,P2,'FillGap',5,'MinLength',7);

% Plot lines and mark beginning/end in original image:---------
figure(6), imshow(I_bin), hold on
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

% Rotate by angle and I_rot:-----------------------------------------------
angle = (sum + sum2) / 2;
disp(['Angle corrected: ', num2str(angle), 'degrees']);
I_rot = imrotate(I_bin,angle,'bilinear');
tmpI = imclearborder(~I_rot);
I_rot = ~tmpI;
figure(7), imshow(I_rot)

% Extend borders to frame:----------------------------------------
I_rot = extendBorders(I_rot,searchResolution);
new_I = imdilate(imerode(I_rot,nhood2),nhood2);
figure(8), imshow(new_I);

% Extract Textbox:------------------------------------------------
width = size(new_I,2);
height = size(new_I,1);
textbox = new_I(0.052*height:0.113*height , 0.074*width:0.78*width);
figure(9), imshow(textbox)
BW3 = imclearborder(~imerode(textbox,nhood1));
textbox = ~imerode(BW3,nhood1);
figure(10), imshow(textbox);

% Extract each letter and insert into struct names "letters"
clear letters
middle = ceil(size(textbox,1) /2);
counter = 0;
counter2 = 0;
limit = 0.04*size(textbox,2);
i = 1;
while i < size(textbox,2)
    counter2 = counter2 + 1;
    if textbox(middle,i) == 0;
        disp(counter2)
        counter = counter + 1;
        if counter2 > limit && counter > 1
            structName = ['nr' ,num2str(counter)];
            letters.(structName) = ones(64,64);
            counter = counter + 1;
        end
        structName = ['nr' ,num2str(counter)];
        [glyph, backtrack] = letterFiller(textbox,middle,i,1);
        letters.(structName) = glyph;
        i = i + size(glyph,2) - backtrack;
        counter2 = 0;
    else
        i = i + 1;
    end
end
