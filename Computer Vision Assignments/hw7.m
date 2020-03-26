clc;
clear;
close all;
% Displaying Image
% img_data = imread('Image.bmp');
img_d = imread('checkerboard.jpg');
img_d = rgb2gray(img_d); %% Only for checkerboard
img_d= im2double(img_d);
figure(1);
imshow(img_d);
title('Original Image converted to GrayScale');
% feature_threshold =25000;
feature_threshold =10000;
% Harris Detector Function;
function forstnerdata = GetHarrisData(img_data)
ker_x = [-2 -1 0 1 2];
ker_y = transpose(ker_x);
g_x = PerConvo(img_data,ker_x,0);
g_y = PerConvo(img_data,ker_y,0);
figure;
imshow(g_x);
title('X Gradient of Image');
figure;
imshow(g_y);
title('Y Gradient of Image');
grad_sqx = g_x.^2;
grad_sqy = g_y.^2;
grad_xy = g_x.*g_y;
gauss_kernel = GenerateGaussianFilter(1,5);
conv_sqX = PerConvo(grad_sqx,gauss_kernel,0);
conv_sqY = PerConvo(grad_sqy,gauss_kernel,0);
conv_XY = PerConvo(grad_xy,gauss_kernel,0);
forstnerdata = zeros(size(img_data));
alpha = 0.06;
%% Calculating Auto Correlation Matrix for each image pixel
for xv = 1: size(img_data,1)
 for yval = 1: size(img_data,2)
 auto_corr_matrix = [conv_sqX(xv,yval) conv_XY(xv,yval);
conv_XY(xv,yval) conv_sqY(xv,yval)];
 forstner_harris_value = det(auto_corr_matrix) - alpha*(trace(auto_corr_matrix)^2);
 forstnerdata(xv,yval) = forstner_harris_value;
 end
end
%% Forstner Harris on Original Image
forstnerdata = GetHarrisData(img_data);
[fh_output_features,fh_x,fh_y] = HarrisFeatureDetector(forstnerdata,feature_threshold);
figure(2);
imshow(im2double(img_data));
hold on;
plot(fh_x, fh_y, 'g+', 'LineWidth', 3, 'MarkerSize', 5);
title('Image with Features selected using Forstner-Harris Metric');
%% Adaptive Non Maximal Suppression on Original Image
function [returnImg,adaptive_xval,adaptive_yval] = ANMSFeatureDetector(forstner_harris_data,feature_threshold)
threshold = 0;
    for xcount = 1: size(forstner_harris_data,1)
     for ycount = 1: size(forstner_harris_data,2)
     if forstner_harris_data(xcount,ycount) < threshold
     forstner_harris_data(xcount,ycount)=0;
     end
     end
    end
featureCount = sum(sum(forstner_harris_data > 0));
radiusMatrix = FindFeatureRadius(forstner_harris_data);
radNew = radiusMatrix;
[radNew(1,:), ind] = sort(radiusMatrix(1,:),'descend');
    for i = 1: size(ind,2)
     radNew(2,i)=radiusMatrix(2,ind(i));
     radNew(3,i)=radiusMatrix(3,ind(i));
    end
    radiusMatrix=radNew;
    if(featureCount<2*feature_threshold)
     totalVal = featureCount;
    else
     totalVal = 2*feature_threshold;
    end
    returnImg = zeros(size(forstner_harris_data));
    for i= 1:totalVal
     returnImg(radiusMatrix(2,i),radiusMatrix(3,i))= forstner_harris_data(radiusMatrix(2,i),radiusMatrix(3,i));
    end
end
[returnImg,adaptive_xval,adaptive_yval] = ThreshTopValues(returnImg,feature_threshold);
[adaptive_output_features,adaptive_xval,adaptive_yval] = ANMSFeatureDetector(forstner_harris_data,feature_threshold);
figure(4);
imshow(im2double(img_data));
hold on;
plot(adaptive_xval, adaptive_yval, 'g+', 'LineWidth', 1, 'MarkerSize', 5);
title('Image with features selected using Adaptive Non-Maximal Supression');
rotated_img_data= imrotate(img_data,45);
figure(5);
imshow(rotated_img_data);
title('Original Image rotated by 45 degrees');
rotated_forstner_harris_data=GetHarrisData(rotated_img_data);
%% Forstner Harris on Rotated Image
[fh_rotated_output_features,fh_rotated_xval,fh_rotated_yval] = HarrisFeatureDetector(rotated_forstner_harris_data,feature_threshold);
figure(6);
imshow(im2double(rotated_img_data));
hold on;
plot(fh_rotated_xval,fh_rotated_yval, 'g+', 'LineWidth', 1, 'MarkerSize', 5);
title('Rotated Image with Features selected using Forstner-Harris Metric');
%% Adaptive Non Maximal Suppression on Rotated Image
[adaptive_rotated_output_features,adaptive_rotated_xval,adaptive_rotated_yval
] = ANMSFeatureDetector(rotated_forstner_harris_data,feature_threshold);
figure(7);
imshow(im2double(rotated_img_data));
hold on;
plot(adaptive_rotated_xval,adaptive_rotated_yval, 'g+', 'LineWidth', 1,'MarkerSize', 5);
title('Rotated with features selected using Adaptive Non-MaximalSupression');
adaptive_rotated_features = imrotate(adaptive_output_features,45);
figure(8);
imshow(im2double(adaptive_rotated_features));
title('Rotated Features for Matching');
original_aligned_features = GetFeatureCoordinates(adaptive_rotated_features);
rotated_features= GetFeatureCoordinates(adaptive_rotated_output_features);
[count,matched_points_img] = GetFeatureMatchCount(rotated_img_data,original_aligned_features,rotated_features,2);
matched_original_image= imrotate(matched_points_img,-45);
matched_original_image=imresize(matched_original_image,size(img_data));
figure(9);
imshow(im2double(matched_original_image));
title('Plot showing matched features');
vecSize=sum(sum(matched_original_image > 0));
x_coord =zeros(vecSize,1);
y_coord=zeros(vecSize,1);
counter=1;
for i = 1:size(matched_original_image,1)
 for j = 1:size(matched_original_image,2)
 if(matched_original_image(i,j)>0)
 x_coord(counter)=i;
 y_coord(counter)=j;
 counter=counter+1;
 end
 end
end
figure(10);
imshow(im2double(img_data));
hold on;
plot(x_coord,y_coord, 'g+', 'LineWidth', 1, 'MarkerSize', 5);
title('Original image with matched features');

