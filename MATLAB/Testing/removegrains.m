function [ gray ] = removegrains( img )
tic

gray = readISQ(img);
[img, ~] = cleanWheat(img, 5, 1000); 

se = strel('disk', 13); 

for slice=1:size(img,3)
    
    img(:,:,slice) = imerode(~img(:,:,slice), se);
    gray(:,:,slice) = bsxfun(@times, gray(:,:,slice), cast(img(:,:,slice),class(gray(:,:,slice))));
end

gray = removetube(gray); 

imshow3D(gray);

toc
end

