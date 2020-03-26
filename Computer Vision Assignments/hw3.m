% read in the image
im = imread('Image.bmp', 'bmp');
im = double(im);
[Ny Nx] = size(im);
% display the image
figure(1);
imshow(uint8(im));
title('original image');
% set the threshold
threshold = 32;
im_threshold = zeros(Ny, Nx);
for i = 1:Nx
    for j = 1:Ny 
        if im(j,i) > threshold
        im_threshold(j,i) = 255;
        else
        im_threshold(j,i) = 0;
        end
    end
end
figure(2);
imshow(uint8(im_threshold));
title('threshold');
% create a histogram of the image
histo = zeros(256,1);
for i = 1:Nx
    for j = 1:Ny
    histo(im(j,i)+1) = histo(im(j,i)+1) + 1;
    end
end
% create the CDF from the PDF (i.e. the histogram)
CDF = zeros(256,1);
CDF(1) = histo(1);
for i = 2:256
CDF(i) = CDF(i-1) + histo(i);
end
CDF = CDF/Nx/Ny;
% find the lower limit
for i=1:256
if CDF(i) > 0.05
lower = i;
break;
end
end
% find the upper limit
for i=1:256
if CDF(i) > 0.95
upper = i;
break;
end
end
gain = 255/(upper - lower);
% apply the contrast
im_contrast = gain*(im - lower);
% dispay the image
figure(3);
imshow(uint8(im_contrast));
title('contrast');
gamma = 0.45;
im_gamma = im/255;
im_gamma = im_gamma.^gamma;
im_gamma = im_gamma*255;
figure(5);
imshow(uint8(im_gamma));
title('gamma');
CDF = 255*CDF;
im_HE = zeros(Ny, Nx);
for i = 1:Nx
    for j = 1:Ny
    im_HE(j,i) = CDF(im(j,i) + 1);
    end
end
figure(6);
imshow(uint8(im_HE));
title('histogram stretch');