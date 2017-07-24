%Setup parms
directory = '~/Data/00000079/*/*.ISQ'; 
structEleSize = 3;
voxelSize = 29.6;
minSize = 7000; 

tic % start timer
% Process the file directory! 
processDirectory(directory, structEleSize, voxelSize, minSize); 
toc % get run time
