function processDirectory(dirpath, structuringEleSize, voxelSize, minGrainSize)
% given a directory will scan for ISQ files and process
% e.g.'dirpath/*/*.ISQ'

% grab all the files to process
files = rdir(dirpath);

for file=1:size(files, 1)
    
    % get filename
    filename = files(file).name;
    % segment image initially in 2D  
    [img, original] = cleanWheat(files(file).name, structuringEleSize);
    
    
    % perform 3D watershedding to segment any leftover data
    img = watershedSplit3D(img);
    
    % generate mask after WS
    % using the original for size/space saving
    for slice= 1:size(img, 3)
        original(:,:,slice) = bsxfun(@times, original(:,:,slice), cast(img(:,:,slice), 'like', original(:,:,slice)));
    end
    
    
    % count objects
    [img, masked, ~] = filterSmallObjs(original, minGrainSize);
    
    % perform grain measurement gathering!
    [stats, rawstats] = countGrain(img, files(file).name, masked, voxelSize, minGrainSize);
    
    % write stats file
    file_output_stats = strcat(filename, '.csv');
    file_output_rawstats = strcat(filename, '-raw_stats.csv');
    % clear previous stat files if they exist
    delete (file_output_stats);
    delete (file_output_rawstats);
    writetable(struct2table(stats), file_output_stats);
    writetable(struct2table(rawstats), file_output_rawstats);
    
    % Write segmented image to file
    file_output_img = strcat(filename, 'cleaned.tif');
    delete (file_output_img);
    for K=1:length(masked(1, 1, :))
        imwrite(masked(:, :, K), file_output_img, 'WriteMode', 'append','Compression','none');
    end
    
end
end
