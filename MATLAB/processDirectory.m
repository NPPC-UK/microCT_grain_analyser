function processDirectory(dirpath, structuringEleSize, voxelSize, minGrainSize, watershed, startFrom, endAt)
% given a directory will scan for ISQ files and process
% e.g.'dirpath/*/*.ISQ'

% Disable file overwrite warnings so we can see output
warning('off', 'MATLAB:DELETE:FileNotFound');
warning('off', 'MATLAB:MKDIR:DirectoryExists');
warning('off');


% grab all the files to process
files = subdir(dirpath);



if nargin < 7
    endAt = size(files, 1);  
    if nargin < 6
        startFrom = 1;  
    end
elseif endAt == 0
    endAt = size(files,1);
end


for file=startFrom:endAt
   
    
        filename = files(file).name;

        fprintf('Currently on file: %s\nThis is file %d of %d\n', filename, file, size(files,1));

        % segment image initially in 2D  
        [bw, gray, r, rtop, rbot] = cleanWheat(filename, structuringEleSize, minGrainSize, watershed);

        [bw_obj, gray_obj] = cleanObject(filename);

        % get length of object and write immediately in case of crash
        [len, bottom, top] = calcLength(bw);
        file_output_length = strcat(filename, 'length.csv');
        csvwrite(file_output_length, [len, bottom, top]);

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
        [stats, rawstats] = countGrain(gray, filename, voxelSize, minGrainSize);

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

        file_output_bw_obj = strcat(filename, 'bw_obj-segmented.tif');
        writeTif(bw_obj, file_output_bw_obj);

        file_output_gray_obj = strcat(filename, 'gray_obj-segmented.tif');
        writeTif(gray_obj, file_output_gray_obj);


end
end
