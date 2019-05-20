function dims = calcDimensionsn(bw)
  % calcLenght takes a blakc and white image and calculates the length 
  % of the object
  dims = [];
  dims.None = 0;

  [row, column, height] = ind2sub(size(bw), find(bw));

  bottom_idx = min(height);
  top_idx = max(height);

  bottom_slice = uint8(bw(:, :, bottom_idx));
  top_slice = uint8(bw(:, :, top_idx));

  for sl = bottom_idx:top_idx
    s = bw(:, :, sl);
    props = regionprops(s, 'Centroid', 'MajorAxisLength', 'MinorAxisLength');
    dims(end+1) = struct(...
      x, props.Centroid(1),...
      y, props.Centroid(2),...
      z, sl,...
      major, props.MajorAxisLength,...
      minor, props.MinorAxisLength);

end
