function [ P, T, B ] = rotateGrain( A )

[theta, T, B] = calcRotation(A);
tform = affine3d(theta);
R = imwarp(A,tform);
C = compact3DImage(R); 


x = 1;
y = 2;
z = 3; 


if size(C,1) > size(C,3)
    [x,z] = deal(z,x);
end 

if size(C,2) > size(C,3)
    [y,z] = deal(y,z);
end

P = permute(C, [x,y,z]);

end

