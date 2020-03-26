I = imread('Connected.bmp','bmp');
I = imresize(I, 0.5); % reduce size not to reach Matlab's maximum 
                      % recursion limit 
global A
A = im2bw(I, 0.5);
global B
B = zeros(size(A));
global currentlabel
currentlabel = 1;
sz1 = size(A,1);
global offset
offset = [-sz1-1:-sz1+1 -1 +1 sz1-1:sz1+1];
for ind = 1:numel(A)
  if A(ind) == 1 && B(ind) == 0
    labelconnected(ind)
    currentlabel = currentlabel + 1;
  end
end
function labelconnected(ind)
global currentlabel
global offset
global A
global B
B(ind) = currentlabel;
imshow(B, []), drawnow
neighbors = ind + offset;
neighbors(neighbors <= 0 | neighbors > numel(A)) = [];
for ind = neighbors
  if A(ind) == 1 && B(ind) == 0
    labelconnected(ind)
  end
end
end