function [ img, masked] = cleanWheat( filename )

img = readISQ(filename); 

%img = filename; 
%resizeFactor = size(img).*[1/2 1/2 1/2];
%img = resize(img, resizeFactor); 
masked = img;

% generate mask for outter circle
middle_slice = round(size(img, 3)/2);
mask = extractBiggestBlob(im2bw(img(:,:,middle_slice), graythresh(img(:,:,400))), 1);
mask = imdilate(mask, strel('disk', 15));

se = strel('disk', 2); % changed from 5
[pixelCounts, grayLevels] = imhist(img(:));
cdf = cumsum(pixelCounts) / sum(pixelCounts);
thresholdIndex = find(cdf < 0.92, 1, 'last');
thresholdValue = grayLevels(thresholdIndex);

for slice = 1:size(img, 3)

    I = img(:,:,slice) > thresholdValue;
    tmp = imerode(I, se);
    tmp = medfilt2(tmp, [8,8]);
    tmp = imdilate(tmp, se);
    I = tmp & I;
    I = I - mask;    
    img(:,:,slice) = I;
    
end

l = bwlabeln(img);
s = regionprops(l);
idx = find([s.Area] >= 8000 );
img = ismember(l, idx);


% generate the masked outline
for slice= 1:size(img, 3)
    masked(:,:,slice) = bsxfun(@times, masked(:,:,slice), cast(img(:,:,slice), 'like', masked(:,:,slice)));
end

img = logical(img);

end