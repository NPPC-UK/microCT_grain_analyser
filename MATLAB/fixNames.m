function [] = fixNames( baseFolder )
% fixNames is a function that returns nothing but fixes bad filenames

 commandStr = sprintf('python ../Scripts/fixNames.py %s',baseFolder);
 [status, commandOut] = system(commandStr);

 if status==0
     fprintf('File names have been corrected\n');
 end
 
end

