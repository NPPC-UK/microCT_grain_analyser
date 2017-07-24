function [ largest, mask, s] = filterSmallObjs( wheat_img, minSize )
% removes objects smaller than minSize from wheat_img
% try and catch if nothing is found. 
try    
    l = bwlabeln(wheat_img);
    s = regionprops(l);
    idx = find([s.Area] >= minSize );
    largest = ismember(l, idx);
    
catch
    largest = wheat_img;
end
% clean up stats a little
s([s.Area] < minSize) = [];

% preallocate
mask = wheat_img;

% remask
for slice= 1:size(wheat_img, 3)
    mask(:,:,slice) = bsxfun(@times, wheat_img(:,:,slice), cast(largest(:,:,slice), 'like', wheat_img(:,:,slice)));    
end



end

