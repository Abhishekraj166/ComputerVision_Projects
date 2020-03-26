clear
close all
%%%%%%%%%%%% load the image file and display %%%%%%%%%%%%
% read in the image
im = imread('Image.bmp', 'bmp');
[Ny Nx] = size(im);
% display the image
figure(1);
imshow(uint8(im));
title('original image');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
window=5;
sigma=1;
widV=floor(window/2);
widH=floor(window/2);
%%%%% Find Gaussian kernel
[xx,yy] = meshgrid(-widV:widV, -widV:widV);
tmp=exp(-1/(2*sigma^2) * (xx.^2 + yy.^2));
ss=sum(sum(tmp));
gaussianF=tmp/ss;
MovAvgF=1/(window^2)*ones(window);
A_pad=zeros(Ny+2*widV,Nx+2*widH);
A_pad(1+widV:widV+Ny,1+widH:widH+Nx)=im; % zero padding for the image
%%%%%%%%%%%%% Moving average filter %%%%%%%%%%%%
filter=MovAvgF;
im_movAvg=zeros(Ny,Nx);
for i = 1:Ny
 for j = 1:Nx
 i_ex=i+widV;
 j_ex=j+widH;
 Neigbrhood=A_pad(i_ex-widH:i_ex+widH,j_ex-widV:j_ex+widV);
 im_movAvg(i,j)=sum(sum(Neigbrhood.*filter));

 end
end
figure(2);
imshow(uint8(im_movAvg));
title('Moving Average');
%%%%%%%%%%%%% Gaussian filter %%%%%%%%%%%%
filterG=gaussianF;
im_gauss=zeros(Ny,Nx);
for i = 1:Ny
 for j = 1:Nx
 i_ex=i+widV;
 j_ex=j+widH;
 Neigbrhood=A_pad(i_ex-widH:i_ex+widH,j_ex-widV:j_ex+widV);
 im_gauss(i,j)=sum(sum(Neigbrhood.*filterG));

 end
end
figure(3);
imshow(uint8(im_gauss));
title('Gaussian Filter');