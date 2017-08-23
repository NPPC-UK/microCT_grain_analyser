function [] = ISQ2Tiff( directory )
% Converts all ISQ files found in the directory 
% into ISQ 
files = subdir(directory); 

for f=1:size(files)
   
    A = readISQ(files(f).name); 
    writeTif(A, strcat(files(f).name, '.tif')); 
    
end

end

