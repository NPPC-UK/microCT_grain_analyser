function processDirectory(dirpath)
% Given a directory will scan for ISQ files and process

% Grab all the files to process
%files = rdir('~/ISQ/76/*/*.ISQ');
% '/media/phenomics/storage/CT-Scans/00000076/512x512/*/*.ISQ'
files = rdir(dirpath);

tic
for file=1:size(files, 1)
    
    file
    filename = files(file).name;
    [img, masked] = cleanWheat(files(file).name);
    %img = watershedSplit3D(img);
    
    % count objects
    [img, ~] = filterSmallObjs(img);
    
    % can comment this out if you just want clean images to process other
    % places 
    stats = countGrain(img, files(file).name, masked);
    
    % write stats file
    file_output_stats = strcat(filename, '.csv');
    delete (file_output_stats);
    writetable(struct2table(stats), file_output_stats);
    
    % Write segmented file to inspect
    file_output_img = strcat(filename, 'cleaned.tif');
    delete (file_output_img);
    for K=1:length(masked(1, 1, :))
        imwrite(masked(:, :, K), file_output_img, 'WriteMode', 'append','Compression','none');
    end
    
end
toc
end
