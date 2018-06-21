function [ img ] = readTif( filename )
% Reads in a tiff image stack

info = imfinfo(filename);
num_images = numel(info);
height = info(1).Width;  
width = info(1).Height;
%img = zeros(height, width , num_images);


for k = 1:num_images
    img(:,:,k) = imread(filename, k);
end

img = uint8(img); 

end

