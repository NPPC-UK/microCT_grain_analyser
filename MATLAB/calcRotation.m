function [ M, T, B ] = calcRotation( A )

% find top x,y,z
for K=1:length(A(1, 1, :))
    I = logical(A(:,:,K));
    if ~length(I(I>0))
         continue
    end
    P = regionprops(I);
    P=P(1);
    T.x = P.Centroid(1);
    T.y = P.Centroid(2);
    T.z = K;
    break
end

% find bottom x,y,z
for K=1:length(A(1, 1, :))
    I = logical(A(:,:,length(A(1,1,:))-K));
    if ~length(I(I>0))
         continue
    end
    P = regionprops(I);
    P=P(1);
    B.x = P.Centroid(1);
    B.y = P.Centroid(2);
    B.z = length(A(1,1,:)) -K;
    break
end

distZY = pdist([B.y,B.z;T.y,T.z]);
distZX = pdist([B.x,B.z;T.x,T.z]);

% calc first matrix
% ZY  
% using cosine rule
L.y = B.y;
L.z = B.z + distZY; 

% triangle with lines, a, b,c
% where line b is B -> L
% line c is B -> T
% line a is L -> T

b = pdist([B.y,B.z; L.y, L.z]);
c = pdist([B.y,B.z; T.y, T.z]);
a = pdist([L.y,L.z; T.y, T.z]);

theta1 = acosd(cos((b^2+a^2-c^2)/(2*b*a)));

% calc second matrix
% ZX  
% using cosine rule
L.x = B.x;
L.z = B.z + distZX; 

% triangle with lines, a, b,c
% where line b is B -> L
% line c is B -> T
% line a is L -> T

b = pdist([B.x,B.z; L.x, L.z]);
c = pdist([B.x,B.z; T.x, T.z]);
a = pdist([L.x,L.z; T.x, T.z]);

theta2 = acosd(cos((b^2+a^2-c^2)/(2*b*a)));

R1 = [cos(theta1), 0, sin(theta1), 0;
      0, 1, 0, 0;
      -sin(theta1), 0, cos(theta1), 0;
      0,0,0,1];
  
R2 = [1, 0, 0, 0;
      0, cos(theta2), -sin(theta2), 0;
      0, sin(theta2), cos(theta2), 0;
      0,0,0,1];

M=R1*R2;

end

