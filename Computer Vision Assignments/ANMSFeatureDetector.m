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
[returnImg,adaptive_xval,adaptive_yval] = ThreshTopValues(returnImg,feature_threshold);