function writeTif(A, filename)
% Writes a image stack A to a tif file
delete (filename); 
for K=1:length(A(1, 1, :))
    imwrite(A(:, :, K), filename, 'WriteMode', 'append','Compression','none');
end

end

