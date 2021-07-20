#!/bin/bash

# Copy input files to the output/working directory so we don't mess them up. We
# generally assume the output directory starts out empty and will not be 
# interfered with by any other processes - certainly this is true for XNAT/DAX.

echo Running $(basename "${BASH_SOURCE}")

# Copy the input nifti files to the working directory (out_dir) with a hard-coded
# filename.
if [ ! -d "$out_dir" ]; then
	mkdir "$out_dir"
fi

cp "${t1_1_niigz}" "${out_dir}"/t1_1.nii.gz

cp "${t1_2_niigz}" "${out_dir}"/t1_2.nii.gz

if [ "${t1_3_niigz}" != "none" ]; then
	cp "${t1_3_niigz}" "${out_dir}"/t1_3.nii.gz
fi

if [ "${t1_4_niigz}" != "none" ]; then
	cp "${t1_4_niigz}" "${out_dir}"/t1_4.nii.gz
fi

# Unzip files for SPM
gunzip "${out_dir}"/*.nii.gz

