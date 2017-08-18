% This is a example file of how you should set up the running of an
% entire experiment's data elements
% 
% 1. you should give a directory with a recursive file
% path (if requried)
%
% 2. a size of structuring element to use for morphological
% operations.
%
% 3. A voxel size used in measurements
%
% 4. A minimum size of interest, this allows for throwing away
% uninteresting data
%
% Current values are just examples. 


%Setup parms
directory = 'C:/Users/Nathan/Desktop/Pre-processing-tifs/*.tif'; 
structEleSize = 5;
voxelSize = 68.8;
minSize = 2000; 

tic % start timer
% Process the file directory! 
processDirectory(directory, structEleSize, voxelSize, minSize); 
toc % get run time
