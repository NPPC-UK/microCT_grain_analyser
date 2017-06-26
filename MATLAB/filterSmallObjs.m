function [ largest, s] = filterSmallObjs( wheat_img )

% set a minimum wheat size to find
min = 10000; 
%min = 119131;

tic
% try and catch if nothing is found. 
try
    %l = bwconncomp(wheat_img); % whilst this is generally better 
    % bwlabeln works with find better
    
    l = bwlabeln(wheat_img);
    s = regionprops(l);
    idx = find([s.Area] >= min );
    largest = ismember(l, idx);
    
catch
    largest = wheat_img;
end
toc

% clean up stats a little
s([s.Area] < min) = [];

end

