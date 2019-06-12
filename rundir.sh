#!/bin/sh
chunk=60
n_images=1266
let uper_lim=$n_images+1

dir="/mnt/mass/scratch/scratch/br09_data/*.ISQ"
voxs="68.8"
mins="100"
structs="2"
wshed="false"

while [ $current -lt $uper_lim ]; do
	start=$current
	let end=$current+$chunk
	if [ $end -gt $n_images ]; then
		let end=$n_images
	fi
	matlab -r "directory = '${dir}'; fixNames(directory); processDirectory(directory, ${structs}, ${voxs}, ${mins}, ${wshed}, ${start}, ${end}); exit;"
	let current=$end+1
done
