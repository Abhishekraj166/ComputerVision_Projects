% Harris Detector Function;
function forstner_harris_data = GetHarrisData(img_data)
kernel_x = [-2 -1 0 1 2];
kernel_y = transpose(kernel_x);
grad_x = conv2(img_data,kernel_x,'same');
grad_y = conv2(img_data,kernel_y,'same');
sizegradx=size(grad_x)
sizegrady=size(grad_y)
figure;
imshow(grad_x);
title('X Gradient of Image');
figure;
imshow(grad_y);
title('Y Gradient of Image');
grad_sqx = grad_x.^2;
grad_sqy = grad_y.^2;
grad_xy = grad_x.*grad_y;
window=5;
sigma=1;
widV=floor(window/2);
widH=floor(window/2);
%%%%% Find Gaussian kernel
[xx,yy] = meshgrid(-widV:widH, -widV:widH);
tmp=exp(-1/(2*sigma^2) * (xx.^2 + yy.^2));
ss=sum(sum(tmp));
gauss_kernel=tmp/ss;
conv_sqX = conv2(grad_sqx,gauss_kernel,'same');
conv_sqY = conv2(grad_sqy,gauss_kernel,'same');
conv_XY = conv2(grad_xy,gauss_kernel,'same');
forstner_harris_data = zeros(size(img_data));
alpha = 0.06;
%% Calculating Auto Correlation Matrix for each image pixel
for xval = 1: size(img_data,1)
 for yval = 1: size(img_data,2)
 auto_corr_matrix = [conv_sqX(xval,yval) conv_XY(xval,yval);
conv_XY(xval,yval) conv_sqY(xval,yval)];
 forstner_harris_value = det(auto_corr_matrix) - alpha*(trace(auto_corr_matrix)^2);
 forstner_harris_data(xval,yval) = forstner_harris_value;
 end
end