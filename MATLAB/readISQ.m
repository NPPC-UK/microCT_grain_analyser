function [image,metadata]=readISQ(filename,slicerange)

% [image]=readISQ(filename) reads the image in the file
% [image,metadata]=readISQ(filename) also provides some metadata
% [image]=readISQ(filename,slice_nr) reads one slice at a time
% [image]=readISQ(filename,[first_slice_nr,last_slice_nr]) reads a range of slices
% [image]=readISQ(filename,slicerange,window) reads the
%   window from each slice defined by the vector window=[minx,maxx,miny,maxy]

%
% Originally by:
% Johan Karlsson, AstraZeneca, 2017
% (https://uk.mathworks.com/matlabcentral/fileexchange/view_license?file_info_id=62066)
% Modified by:
% Nathan Hughes
    
fid=fopen(filename);
h=fread(fid,128,'int'); % header
metadata.dimx_p=h(12);
metadata.dimy_p=h(13);
metadata.dimz_p=h(14);
metadata.dimx_um=h(15);
metadata.dimy_um=h(16);
metadata.dimz_um=h(17);
metadata.slice_thickness_um=h(18);
metadata.slice_increment_um=h(19);
metadata.slice_1_pos_um=h(20);
metadata.min_data_value=h(21);
metadata.max_data_value=h(22);
metadata.mu_scaling=h(23);

if nargin<2 || isempty(slicerange)
    first_slice=1;
    last_slice=metadata.dimz_p;
end

if nargin >= 2
    if length(slicerange)==1
        first_slice=slicerange;
        last_slice=slicerange;
    else
        first_slice=slicerange(1);
        last_slice=slicerange(2);
    end    
end




%preallocation
image = zeros(metadata.dimx_p, metadata.dimy_p,last_slice);

for slice=first_slice:last_slice
    fseek(fid,512*(h(end)+1)+metadata.dimx_p*metadata.dimy_p*2*(slice-1),'bof');
    I=permute(reshape(fread(fid,metadata.dimx_p*metadata.dimy_p,'short'),[metadata.dimx_p,metadata.dimy_p]),[2,1]);
    image(:,:,slice-first_slice+1)=I;
end

% image fully read at this point, so we can close it
fclose(fid);

imageMin = min(image(:)); % or imageMin = min(min(image));
imageMax = max(image(:)); % or imageMax = max(max(image));
% Normalise the image data 
image = uint8(255 * ((image - imageMin) / (imageMax - imageMin)));
