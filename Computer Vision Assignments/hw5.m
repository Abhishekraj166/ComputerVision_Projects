%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% HW 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; clc; close all;
%% Problem 1
% Read in the image Text.bmp
im1 = imread('Text.bmp', 'bmp');
BWimageText=LoadThreshold(im1,100); % set the threshold: threshold = 100;
% Erosion
% ErodeDilateFunc(InputImage,numIter,mode,StrElSize)
imErodeText=ErodeDilateFunc(BWimageText,5,'E',3);
figure; imshowpair(BWimageText,imErodeText,'montage');
%title(['Eroded image using ' num2str(Sx) ' by ' num2str(Sy) ' kernel']);
% Dilation
% ErodeDilateFunc(InputImage,numIter,mode,StrElSize)
imDilateText=ErodeDilateFunc(imErodeText,5,'D',3);
figure; imshowpair(imErodeText,imDilateText,'montage');
%title(['Dilated image using ' num2str(Sx) ' by ' num2str(Sy) ' kernel']);
% Difference between Original thresholded image and that image after being
% eroded 5 times followed by dilation 5 times
figure; imshowpair(imErodeText,imDilateText);
title('Difference between Eroded and Dilated');
diffIm=imErodeText-imDilateText;
figure; imshow(abs(diffIm));
title('Difference between Eroded and Dilated');
figure; imshowpair(BWimageText,imDilateText);
title('Difference between Original and Dilated');
diffIm=BWimageText-imDilateText;
figure; imshow(abs(diffIm));
title('Difference between Original and Dilated');
%% Problem 2
% Read in the image bottle.bmp and threshold the image
im2 = imread('bottle.bmp', 'bmp');
BWimageBottle=LoadThreshold(im2,100); % set the threshold: threshold = 100;
% Dilation
% Morphological operator to remove holes from the solid object in the
% foreground
% Create a structuring element s with neighborhood size of Sx by Sy
% close all;
imDilateBottle=ErodeDilateFunc(BWimageBottle,5,'D',3);
figure; imshowpair(BWimageBottle,imDilateBottle,'montage');
%title(['Dilated image using ' num2str(Sx) ' by ' num2str(Sy) ' kernel']);
figure; imshowpair(BWimageBottle,imDilateBottle);
imErodeBottle=ErodeDilateFunc(imDilateBottle,5,'E',3);
figure; imshowpair(imDilateBottle,imErodeBottle,'montage');
%title(['Eroded image using ' num2str(Sx) ' by ' num2str(Sy) ' kernel']);
figure; imshowpair(imDilateBottle,imErodeBottle);
% Distance transform
im2_dt=double(~imErodeBottle);
imshow(im2_dt);
Nx=size(im2_dt,1); Ny=size(im2_dt,2);
% Forward pass
for x = 2:Nx
 for y = 2:Ny
 if im2_dt(x,y)>=1
 distN=1+im2_dt(x-1,y);
 distW=1+im2_dt(x,y-1);
 im2_dt(x,y)=min(distN,distW);
 end
 end
end
im_fp=im2_dt; figure; imshow(uint8(im_fp));
% Backward pass
for x = (Nx-1):-1:1
 for y = (Ny-1):-1:1
 if im2_dt(x,y)>=1
 distS=1+im2_dt(x+1,y);
 distE=1+im2_dt(x,y+1);
 distVals=[distS,distE,im2_dt(x,y)];
 im2_dt(x,y)=min(distVals);
 end
 end
end
im_bp=im2_dt;
figure; imshow(uint8(im_bp));
%%
imContrastBottle=ContrastStretching(im_bp);
