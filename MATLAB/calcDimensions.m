function dims = calcDimensionsn(bw)
  % calcLenght takes a blakc and white image and calculates the length 
  % of the object

  [row, column, height] = ind2sub(size(bw), find(bw));

  bottom_idx = min(height);
  top_idx = max(height);

  N = (top_idx - bottom_idx) + 1;
  dims(N) = struct('x', [], 'y', [], 'z', [], 'major', [], 'minor', [])

  bottom_slice = uint8(bw(:, :, bottom_idx));
  top_slice = uint8(bw(:, :, top_idx));

  for sl = bottom_idx:top_idx
    s = bw(:, :, sl);
    if all(s(:) == 0)
        continue
    end
    props = regionprops(s, 'Centroid', 'MajorAxisLength', 'MinorAxisLength');
    dim = struct(...
          'x', props.Centroid(1),...
          'y', props.Centroid(2),...
          'z', sl,...
          'major', props.MajorAxisLength,...
          'minor', props.MinorAxisLength);

    try
        dims((sl - bottom_idx) + 1) = dim;
    catch ME
	dims
	dim
    end
  end
end
