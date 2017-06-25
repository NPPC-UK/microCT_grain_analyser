function [ R, top, bottom ] = segmentRachis( masked )
% Takes the masked image output by cleanWheat and outputs the Rachis
% And the top and bottom Z numbers

target = 5000; 
l = bwlabeln(masked);
s = regionprops(l);
idx = find([s.Area] <= target );
R = ismember(l, idx);
s = regionprops(R); 
top = max([s(3:3:end).Centroid]); 
bottom = min([s(3:3:end).Centroid]);

end

