function [bw,gray] = cleanWheat( filename, seSize, minSize )
% cleanWheat takes the filename of raw ISQ image, returns segmented image
% returns both a black and white image and a masked greyscale image

% Read in the raw image
% using older function strfind to avoid issues with older versions of
% MATLAB
if strfind(filename, '.tif')
    img = readTif(filename);
else
    img = readISQ(filename);  
end

% Create a copy of the original for use as final masked image
gray = img;

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
thresholdIndex = find(cdf < 0.90, 1, 'last'); 
thresholdValue = grayLevels(thresholdIndex);

if ~isempty(which('ginfo'))
   img = gpuArray(img);  
end

% prepare each and every slice of the 3D image stack
for slice = 1:size(img, 3)
    
    I = img(:,:,slice) > thresholdValue;
    tmp = imopen(I, se);  
    tmp = medfilt2(tmp, [3,3]);
    tmp = imclose(tmp, se); 
    I = tmp & I;
    I = I - mask;
    img(:,:,slice) = I;
    
end


% Make sure image is binary
if ~isempty(which('ginfo'))
    bw = logical(gather(img));
else
    bw = logical(img);
end

% Split up image as needed 
%bw = watershedSplit3D(bw); 

% Filter out any left over objects which haven't been split
[bw, gray] = filterSmallObjs(bw, gray, minSize); 

end
