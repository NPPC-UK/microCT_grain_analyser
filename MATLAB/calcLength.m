function [len, bottom, top] = calcLength(bw)
  % calcLenght takes a blakc and white image and calculates the length 
  % of the object

  [row, column, height] = ind2sub(size(bw), find(bw));

  bottom_idx = min(height);
  top_idx = max(height);

  bottom_slice = bw(:, :, bottom_idx);
  top_slice = bw(:, :, top_idx);

  p_bottom = regionprops(bottom_slice, 'Centroid');
  p_top = regionprops(top_slice, 'Centroid');

  bottom = [p_bottom.Centroid, bottom_idx];
  top = [p_top.Centroid, top_idx];
  len = norm(top-bottom);

end
