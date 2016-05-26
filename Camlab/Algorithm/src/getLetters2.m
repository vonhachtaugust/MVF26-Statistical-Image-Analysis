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

% Apply erosion 10 times, then dilation 10 times to remove clutter
I_bin2 = I_bin;
for i = 1 : dilates_and_erodes
    I_bin2 = imdilate(I_bin2,nhood2);
end
for j = 1 : dilates_and_erodes
    I_bin2 = imerode(I_bin2,nhood2);
end

% Hough transformation ----------------------------------------
I_edge = edge(I_bin2,'Canny');
[H,T,R] = hough(I_edge, 'Theta', -maxAngle:0.2:maxAngle);
[H2,T2,R2] = hough(I_edge, 'Theta', [(90-maxAngle:0.2:89.8),(-89.8:0.2:maxAngle-90)]);

P = houghpeaks(H,maximumHoughLines,'threshold',ceil(houghLineThreshold*max(H(:))));
P2 = houghpeaks(H2,maximumHoughLines,'threshold',ceil(houghLineThreshold*max(H2(:))));

% Locate lines based on peaks in hough matrix ------------------
lines = houghlines(I_edge,T,R,P,'FillGap',5,'MinLength',7);

summary = 0;
for i = 1:length(lines)
    summary = summary + lines(i).theta;
end
summary = summary/i;

% Locate lines based on peaks in hough matrix:-----------------
lines2 = houghlines(I_edge,T2,R2,P2,'FillGap',5,'MinLength',7);

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
angle = (summary + sum2) / 2;
I_rot = imrotate(I_bin,angle,'bilinear');
tmpI = imclearborder(~I_rot);
I_rot = ~tmpI;

% Extend borders to frame:----------------------------------------
I_rot = extendBorders(I_rot,searchResolution);
new_I = imdilate(imerode(I_rot,nhood2),nhood2);

% Extract Textbox:------------------------------------------------
width = size(new_I,2);
height = size(new_I,1);
textbox = new_I(0.052*height:0.113*height , 0.074*width:0.78*width);
BW3 = imclearborder(~imerode(textbox,nhood1));
textbox = ~imerode(BW3,nhood1);

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
