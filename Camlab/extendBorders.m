function image = extendBorders(img,searchResolution)

right_bound = borderFinder(img,searchResolution);
top_bound   = borderFinder(imrotate(img,90),searchResolution);
left_bound  = borderFinder(imrotate(img,180),searchResolution);
down_bound  = borderFinder(imrotate(img,270),searchResolution);

img(: , end - left_bound:end) = [];
img(end - down_bound:end , :) = [];
img(: , 1:right_bound) = [];
img(1:top_bound , :) = [];

image = img;