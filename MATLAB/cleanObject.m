function [bw,gray] = cleanObject( filename, seSize )
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

% Set thresholding value
thresholdValue = 30;

if ~isempty(which('ginfo'))
   img = gpuArray(img);  
end


% prepare each and every slice of the 3D image stack
for slice = 1:size(img, 3)
    
    I = img(:, :, slice);
    [~, threshold] = edge(I, 'sobel');
    fudgeFactor = 0.5;
    edges = edge(I, 'sobel', threshold * fudgeFactor);
    I = edges - mask;
    I = convhull(I)
    img(:,:,slice) = I;
    
end


% Make sure image is binary
if ~isempty(which('ginfo'))
    bw = logical(gather(img));
else
    bw = logical(img);
end

end
