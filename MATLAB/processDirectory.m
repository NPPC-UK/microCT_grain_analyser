function processDirectory(dirpath, structuringEleSize, voxelSize, minGrainSize)
% given a directory will scan for ISQ files and process
% e.g.'dirpath/*/*.ISQ'

% Disable file overwrite warnings so we can see output
warning('off', 'MATLAB:DELETE:FileNotFound');
warning('off', 'MATLAB:MKDIR:DirectoryExists');

% grab all the files to process
files = subdir(dirpath);
for file=1:size(files, 1)
<<<<<<< HEAD
=======
       
    filename = files(file).name;
    
    fprintf('Currently on file: %s\nThis is file %d of %d\n', filename, file, size(files,1));
    
    % segment image initially in 2D  
    [bw, gray] = cleanWheat(filename, structuringEleSize, minGrainSize);

    % Write information on rachis
    rstats = []
    rstats.rtop = rtop;
    rstats.rbot = rbot;
    file_output_rstats = strcat(filename, '-rachis.csv')
    delete(file_output_rstats);
    writetable(struct2table(rstats), file_output_rstats);
    
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
>>>>>>> af7cd5bf6a4fc2b41ff0096bddbbf7b6e3679e20
    
    try
        filename = files(file).name;

        fprintf('Currently on file: %s\nThis is file %d of %d\n', filename, file, size(files,1));

        % segment image initially in 2D  
        [bw, gray, r, rtop, rbot] = cleanWheat(filename, structuringEleSize, minGrainSize);

	% Write rachis information and file
	file_output_rachis = strcat(filename, '-rachis.tif');
	writeTif(r, file_output_rachis);
        rstats = [];
        rstats.rtop = rtop;
        rstats.rbot = rbot;
        file_output_rstats = strcat(filename, '-rachis.csv');
        delete(file_output_rstats);
        writetable(struct2table(rstats), file_output_rstats);
        
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
end
