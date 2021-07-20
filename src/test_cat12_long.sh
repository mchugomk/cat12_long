#!/bin/bash
#
# Test the pipeline outside the container. Be sure the src directory is in the
# path.

# Just the PDF creation part
# export project=TESTPROJ
# export subject=TESTSUBJ
# export session=TESTSESS
# export scan=TESTSCAN
# export out_dir=../OUTPUTS
# make_pdf.sh
# exit 0

   
    
cat12_long_entrypoint.sh \
    --t1_1_niigz ../INPUTS/t1_1.nii.gz \
    --t1_2_niigz ../INPUTS/t1_2.nii.gz \
    --longmodel 1 \
    --nproc 18 \
    --gcutstr 2 \
    --vox 1 \
    --bb 12 \
    --fwhm 4 \
    --out_dir ../OUTPUTS

