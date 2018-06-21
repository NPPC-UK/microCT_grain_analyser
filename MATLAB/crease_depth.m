function cd = crease_depth(A)

B = zeros(size(A));

for i=1:size(B, 3)
    tmp = regionprops(imfill(A(:, :, i), 'holes'), 'ConvexImage', 'Image', 'SubarrayIdx');

    if (numel(tmp)==1)
        B(tmp.SubarrayIdx{1}, tmp.SubarrayIdx{2}, i) = tmp.ConvexImage - tmp.Image;
    end
end

CC = bwconncomp(imerode(B ,strel('disk', 3)));
st = regionprops(CC, 'Image', 'FilledArea');
fa = [st.FilledArea];
ind = find(fa==max(fa));

if (numel(st)==0)
    cd = 0;
    return;
end

A = st(ind(1)).Image;

%imshow(mean(A, 3), []);

depth = zeros(size(A, 3), 1);
for i=1:size(A, 3)
    tmp = regionprops(A(:, :, i), 'MinorAxisLength');
    depth(i) = tmp.MinorAxisLength;
end

st = regionprops(A, 'FilledArea');

cd = mean(fa ./ [st.FilledArea]); %max(fa);%mean(depth);