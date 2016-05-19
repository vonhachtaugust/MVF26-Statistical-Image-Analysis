function letters = augustsMestEfterlaengtadeFunktion2016(image)

I = image;
I = rgb2gray(I) > 80;
I2 = I;

NHOOD = [1,1,1; 1,0,1; 1,1,1];
dilates_and_erodes = 8;
for i = 1 : dilates_and_erodes
    I2 = imdilate(I2,NHOOD);
end
for j = 1 : dilates_and_erodes
    I2 = imerode(I2,NHOOD);
end

% Hough transformation:----------------------------------------
Ir_edge = edge(I2,'Canny');
[H,T,R] = hough(Ir_edge, 'Theta', -10:0.2:10);
[H2,T2,R2] = hough(Ir_edge, 'Theta', [(80:0.2:89.8),(-89.8:0.2:-80)]);

% Locate peaks in hough matrix:------------------------
P = houghpeaks(H,18,'threshold',ceil(0.5*max(H(:))));
P2 = houghpeaks(H2,18,'threshold',ceil(0.5*max(H2(:))));

% Locate lines based on peaks in hough matrix:------------------
lines = houghlines(Ir_edge,T,R,P,'FillGap',5,'MinLength',7);
sum = 0;
for i = 1:length(lines)
    sum = sum + lines(i).theta;
end
sum = sum/i;

lines2 = houghlines(Ir_edge,T2,R2,P2,'FillGap',5,'MinLength',7);
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

% Extend borders to frame:----------------------------------------
searchResolution = 20;
NEWNEWIMAGE = extendBorders(NEWNEWIMAGE,searchResolution);
NEWNEWNEWIMAGE = imdilate(imerode(NEWNEWIMAGE,NHOOD),NHOOD);

% Extract Textbox:------------------------------------------------
width = size(NEWNEWNEWIMAGE,2);
height = size(NEWNEWNEWIMAGE,1);
textbox = NEWNEWNEWIMAGE(0.06*height:0.105*height , 0.079*width:0.74*width);
BW3 = imclearborder(~textbox);
textbox = ~BW3;


% Extract each letter and insert into struct names "letters"
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
