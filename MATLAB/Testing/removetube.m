function [ img ] = removetube( img )
%Takes a gray image and returns a gray image

%find tube mask
middle_slice = round(size(img, 3)/2);
mask = extractBiggestBlob(im2bw(img(:,:,middle_slice), graythresh(img(:,:,middle_slice))), 1);
mask = imdilate(mask, strel('disk', 15));
for slice = 1:size(img, 3)
    img(:,:,slice) = bsxfun(@times, img(:,:,slice), cast(~mask,class(img(:,:,slice))));
end

end

