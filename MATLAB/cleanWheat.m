function [ img, original] = cleanWheat( filename, seSize )
% cleanWheat takes the filename of raw ISQ image, returns segmented image
% returns both a black and white image and a masked greyscale image

% Read in the raw image
img = (readISQ(filename)); 
% Create a copy of the original for use as final masked image
original = img;

% generate mask for outter circle
middle_slice = round(size(img, 3)/2);
% largest blob is always the tube in the scan
mask = extractBiggestBlob(im2bw(img(:,:,middle_slice), graythresh(img(:,:,middle_slice))), 1);
% tube moves slightly during scanning, dilating makes it consistantly
% removable 
mask = imdilate(mask, strel('disk', 15));

% structuring element 
se = strel('disk', seSize); % changed from 5

% calculate thresholding value 
[pixelCounts, grayLevels] = imhist(img(:));
cdf = cumsum(pixelCounts) / sum(pixelCounts);
thresholdIndex = find(cdf < 0.92, 1, 'last'); 
thresholdValue = grayLevels(thresholdIndex);

% prepare each and every slice of the 3D image stack
for slice = 1:size(img, 3)

    I = img(:,:,slice) > thresholdValue;  
    tmp = imopen(I, se);  
    tmp = medfilt2(tmp, [2,2]); 
    I = tmp & I;
    I = I - mask;
    img(:,:,slice) = I;
    
end

% ensure that returned img is made binary 
img = logical(img);

end
