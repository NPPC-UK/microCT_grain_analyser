function [ img, gray] = filterSmallObjs( img, gray, minSize )
% removes objects smaller than minSize from wheat_img
% try and catch if nothing is found. 
try    
    l = bwlabeln(img);
    s = regionprops(l);
    idx = find([s.Area] >= minSize );
    tmp = ismember(l, idx);
    
catch
    % if there's no data in the image this is the default 
    tmp = img;
end

% Switcheroo 
img = tmp; 
clear tmp; 


for slice=1:size(img,3)
    gray(:,:,slice) = bsxfun(@times, gray(:,:,slice), cast(img(:,:,slice),class(gray(:,:,slice))));
end

end

