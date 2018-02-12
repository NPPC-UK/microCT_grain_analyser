function [W] = watershedSplit3DTestMode(A)
% Takes image stack A and splits it into stack W

% Convert to BW
bw = logical(A);

% Create variable for opening and closing 
se = strel('disk', 5);

% Minimise object missshapen-ness
bw = imerode(bw, se);
bw = imdilate(bw, se);

% Fill in any left over holes
bw = imfill(bw, 'holes');

% Use chessboard for distance calculation for more refined splitting
chessboard = -bwdist(~bw, 'chessboard');

% Modify the intensity of our bwdist to produce chessboard2
mask = imextendedmin(chessboard, 2);
chessboard2 = imimposemin(chessboard, mask);


% Calculate watershed based on the modified chessboard
Ld2 = watershed(chessboard2);

% Take original image and add on the lines calculated for splitting
W = A;
W(Ld2 == 0) = 0;

end