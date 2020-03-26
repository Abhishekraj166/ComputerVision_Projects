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