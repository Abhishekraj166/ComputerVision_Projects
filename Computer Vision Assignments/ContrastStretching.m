function im_contrast=ContrastStretching(im)
Nx=size(im,1); Ny=size(im,2);
% create a histogram of the image
histo = zeros(256,1);
for i = 1:Nx,
 for j = 1:Ny,
 histo(im(i,j)+1) = histo(im(i,j)+1) + 1;
 end
end
% create the CDF from the PDF (i.e. the histogram)
CDF = zeros(256,1); CDF(1) = histo(1);
for i = 2:256,
 CDF(i) = CDF(i-1) + histo(i);
end
CDF = CDF/Nx/Ny;
% find the lower limit
for i=1:256,
 if CDF(i) > 0.01
 lower = i;
 break;
 end
end
% find the upper limit
for i=1:256,
 if CDF(i) > 0.99
 upper = i;
 break;
 end
end
gain = 255/(upper - lower);
% apply the contrast
im_contrast = gain*(im - lower);
% dispay the image
figure;
imshow(uint8(im_contrast));
title('Distance transform');
