function BWimage=LoadThreshold(im1,threshold)
im1 = double(im1);
[Nx,Ny] = size(im1);
% Display the image
figure;
imshow(uint8(im1));
title('Original image');
% Thresholding
im_threshold = zeros(Nx, Ny); % Initialize new thresholded image
for i = 1:Nx
 for j = 1:Ny
 if im1(i,j) > threshold % Convert grayscale image to binary
 im_threshold(i,j) = 255;
 else
 im_threshold(i,j) = 0;
 end
 end
end
figure;
imshow(uint8(im_threshold));
title('Thresholded image');
BWimage=(im2bw(im_threshold)); %#ok<IM2BW>
figure;
imshow((BWimage));
title('Binary image');

