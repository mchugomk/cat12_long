#!/bin/bash

## Main shell script for pipeline. We'll call the matlab part from here.

echo Running $(basename "${BASH_SOURCE}")

# Copy inputs to the working directory
copy_inputs.sh

# Handle optional time points 3 and 4
if [ "${t1_3_niigz}" != "none" ]; then
	t1_3_nii="${out_dir}"/t1_3.nii
else
	t1_3_nii="none"
fi

if [ "${t1_4_niigz}" != "none" ]; then
	t1_4_nii="${out_dir}"/t1_4.nii
else 
	t1_4_nii="none"
fi

# Run main matlab code for cat12.
# May need to update this after compiling matlab
run_spm12.sh "${MATLAB_RUNTIME}" function cat12_long \
	t1_1_nii "${out_dir}"/t1_1.nii \
	t1_2_nii "${out_dir}"/t1_2.nii \
	t1_3_nii $t1_3_nii \
	t1_4_nii $t1_4_nii \
	longmodel "${longmodel}" \
	nproc "${nproc}"\
	gcutstr "${gcutstr}" \
	vox "${vox}" \
	bb "${bb}" \
	fwhm "${fwhm}" \
	label_info "${label_info}" \
	out_dir "${out_dir}"

## Create output PDF from cat12 report pdfs
make_pdf.sh

## Organize outputs
finalize.sh

