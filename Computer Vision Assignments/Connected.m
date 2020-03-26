clc;
clear all;
Im=imread('Connected.bmp');
image(Im);
imshow(Im);
title('Image');
imhist(Im);
g=100;
[p,q]=size(Im);
h1=zeros(p,q);
for a=1:p
    for b=1:q
        if (Im(a,b)>g)
            h1(a,b)=0;
        else
            h1(a,b)=1;
        end
    end
end
imshow(h1);
title ('Invert the image')
hr=zeros(p,q);
lbl=0;
s=[0 0];
for a=2:p
    for b=2:q
    if h1(a,b)~=0
        if hr(a-1,b)==0 && hr(a,b-1)==0
            lbl=lbl+1;
            hr(a,b)=lbl;
        elseif hr(a-1,b)~=0 && hr(a,b-1)==0
            hr(a,b)=hr(a-1,b);
        elseif hr(a-1,b)~=0 && hr(a,b-1)~=0 && hr(a-1,b)==hr(a,b-1)
            hr(a,b)=hr(a,b-1);
        elseif hr(a-1,b)==0 && hr(a,b-1)~=0
            hr(a,b)=hr(a,b-1);
        elseif hr(a-1,b)~=0 && hr(a,b-1)~=0 && hr(a-1,b)~=hr(a,b-1)
            s=[s;hr(a-1,b),hr(a,b-1)];
            hr(a,b)=hr(a,b-1);
        end
    end
    end
end


fp=unique(s,'rows');
G=[1];%% Singelton Set

for r=1:size(fp,1)
    if any(G(:)==fp(r,1))
        G=[G;fp(r,2)];
    end
    if any(G(:)==fp(r,2))
        G=[G;fp(r,1)];
    end
end
for r=1:size(fp,1)
    if any(G(:)==fp(r,1))
        G=[G;fp(r,2)];
    end
    if any(G(:)==fp(r,2))
        G=[G;fp(r,1)];
    end
end

G=sort(G);
G=unique(G);

for a=1:p
    for b=1:q
        if any(G(:)==hr(a,b))
            hr(a,b)=G(1,1);
        end
    end
end

G2=[4];

for r=1:size(fp,1)
    if any(G2(:)==fp(r,1))
        G2=[G2;fp(r,2)];
    end
    if any(G2(:)==fp(r,2))
        G2=[G2;fp(r,1)];
    end
end

for r=1:size(fp,1)
    if any(G2(:)==fp(r,1))
        G2=[G2;fp(r,2)];
    end
    if any(G2(:)==fp(r,2))
        G2=[G2;fp(r,1)];
    end
end
G2=sort(G2);
G2=unique(G2);
for a=1:p
    for b=1:q
        if any(G2(:)==hr(a,b))
            hr(a,b)=G2(1,1);
        end
    end
end

G3=[6];
for r=1:size(fp,1)
    if any(G3(:)==fp(r,1))
        G3=[G3;fp(r,2)];
    end
    if any(G3(:)==fp(r,2))
        G3=[G3;fp(r,1)];
    end
end
for r=1:size(fp,1)
    if any(G3(:)==fp(r,1))
        G3=[G3;fp(r,2)];
    end
    if any(G3(:)==fp(r,2))
        G3=[G3;fp(r,1)];
    end
end

for r=size(fp,1):-1:1
    if any(G3(:)==fp(r,1))
        G3=[G3;fp(r,2)];
    end
    if any(G3(:)==fp(r,2))
        G3=[G3;fp(r,1)];
    end
end

G3=sort(G3);
G3=unique(G3);
for a=1:p
    for b=1:q
        if any(G3(:)==hr(a,b))
            hr(a,b)=G3(1,1);
        end
    end
end
hr(hr==6)=2;
hr(hr==4)=3;
hr=hr.*255/4;
figure;
imshow(uint8(hr))
title('4 - Connected Component')
%After inverting the image there are 4 types of background components and 3
%foreground components D,E,P.
% So after applying conditions we get '7' components.  