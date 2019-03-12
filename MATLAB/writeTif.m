function writeTif(A, filename)
% Writes a image stack A to a tif file
delete (filename); 
imwrite(A(:, :, 1), filename, 'tiff', 'Compression', 'packbits');
for K=2:length(A(1, 1, :))
	try
		imwrite(A(:, :, K), filename, 'tiff', 'WriteMode', 'append','Compression','packbits');
	catch ME
		fprintf(['An error occured at K: ', num2str(K), '\n']);
		fprintf(ME.getReport);
	end
end

end

