clc;
clear('cam')
threshold = 180;

k = 2;
sigma = 1.2;
figure(1)
% cam = webcam(1);
% cam.AvailableResolutions
% cam.Resolution = '352x288';
% preview(cam)
% img = snapshot(cam);
img = imread('mtglol.png');
% image(img);
% pause(.1)
tmpMatrix = img(:,:,1) + img(:,:,2) + img(:,:,3);
tmpMatrix = (tmpMatrix > threshold);

imshow(tmpMatrix);

figure(2)



% blurred = GaussianBlur(img,k,sigma);
% figure(2)
% image(blurred/255);

% closePreview(cam)
