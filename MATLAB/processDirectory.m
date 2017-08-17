function processDirectory(dirpath, structuringEleSize, voxelSize, minGrainSize)
% given a directory will scan for ISQ files and process
% e.g.'dirpath/*/*.ISQ'

% Disable file overwrite warnings so we can see output
warning('off', 'MATLAB:DELETE:FileNotFound');
warning('off', 'MATLAB:MKDIR:DirectoryExists');

% grab all the files to process
files = subdir(dirpath);
for file=1:size(files, 1)
       
    filename = files(file).name;
    
    fprintf('Currently on file: %s\nThis is file %d of %d\n', filename, file, size(files,1));
    
    % segment image initially in 2D  
    [bw, gray] = cleanWheat(filename, structuringEleSize, minGrainSize);
    
    % perform grain measurement gathering!
    [stats, rawstats] = countGrain(bw, filename, gray, voxelSize, minGrainSize);
    
    % write stats file
    file_output_stats = strcat(filename, '.csv');
    file_output_rawstats = strcat(filename, '-raw_stats.csv');
   
    % clear previous stat files if they exist
    delete (file_output_stats);
    delete (file_output_rawstats);
    writetable(struct2table(stats), file_output_stats);
    writetable(struct2table(rawstats), file_output_rawstats);
    
    % Write segmented images to file
    file_output_bw = strcat(filename, 'bw-segmented.tif');
    writeTif(bw, file_output_bw);
    
    file_output_gray = strcat(filename, 'gray-segmented.tif');
    writeTif(gray, file_output_gray);
    
        
end
end
