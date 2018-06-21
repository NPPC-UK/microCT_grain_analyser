function [ C ] = compact3DImage( A )

measurements = regionprops(logical(logical(A)), 'BoundingBox');
box = measurements(1).BoundingBox;
box = floor(box);
C = A(box(2):box(2)+box(5),box(1):box(1)+box(4),box(3):box(3)+box(6));

end

