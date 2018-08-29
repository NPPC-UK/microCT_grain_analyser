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



directory = '/home/phenomics/CT-Scans/00000094/*.ISQ';

fixNames(directory);

structEleSize = 7; % Changed this, switched on WS and rerunning
voxelSize = 68.8;
minSize = 300; % This needs to be so low to keep in the internodes


startFrom = 78;
endAt = 78;
watershed = false;


tic % start timer
% Process the file directory!
processDirectory(directory, structEleSize, voxelSize, minSize, watershed, startFrom, endAt);
toc % get run time
