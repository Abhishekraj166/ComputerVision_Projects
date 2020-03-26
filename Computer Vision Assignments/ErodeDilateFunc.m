function imMorph=ErodeDilateFunc(BWimage,numIter,morphOper,Sx)
% ErodeDilateFunc(InputImage,numIter,mode,StrElSize)
% mode: 'E': Erode, 'D': Dilate, StrElSize: square size for kernel
% Create a structuring element s with neighborhood size of Sx by Sy
Sy=Sx;
s=ones(Sx,Sy);
Nx=size(BWimage,1); Ny=size(BWimage,2);
for IterNum=1:numIter % Perform erosion 5 times

 if IterNum==1
 inputIm=~BWimage; % Input image = complement of the Binary image
 elseif IterNum>1
 inputIm=imMorph; % Eroded image as new input image
 end

 C=zeros(Nx,Ny); imMorph=zeros(Nx,Ny);

 for x = 1:Nx-(Sx-1)
 for y = 1:Ny-(Sy-1)
 prodTheta = inputIm(x:x+(Sx-1),y:y+(Sy-1)) .* s(1:Sx,1:Sy);
 C(x+1,y+1)=sum(prodTheta(:));
 if morphOper=='E' % Erosion
 if C(x+1,y+1)==Sx*Sy
 imMorph(x+1,y+1)=1;
 end
 elseif morphOper=='D' % Dilation
 if C(x+1,y+1)>=1
 imMorph(x+1,y+1)=1;
 end
 end
 end
 end
 if morphOper=='E'
 dispStr=['Erosion image ' num2str(IterNum)];
 elseif morphOper=='D'
 dispStr=['Dilation image ' num2str(IterNum)];
 end
 figure; imshowpair(~inputIm,~imMorph,'montage'); title(dispStr);
end
imMorph=~imMorph;

