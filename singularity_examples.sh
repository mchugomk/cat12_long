#!/bin/bash
# Examples of how to run container
#
# --cleanenv and --contain are used to avoid any conflicts with environment
# variables or filesystems on the host. Better to explicitly bind what's needed.
#
# Matlab uses the home directory for caching, so it's important to bind it
# somewhere safe where other running Matlab processes won't cause collisions in
# the cache. Temp space is also provided. These both need to be bound
# somewhere, not left to be in the container, as the container most likely
# won't have space and a confusing memory error or crash will be the result.

singularity run --cleanenv --contain \
	--home $(pwd -P)/INPUTS \
    	--bind INPUTS:/INPUTS \
    	--bind OUTPUTS:/OUTPUTS \
	cat12_long_v1.0.0.simg
    	--t1_1_niigz /INPUTS/t1_1.nii.gz \
    	--t1_2_niigz /INPUTS/t1_2.nii.gz \
    	--longmodel 1 \
    	--nproc 0 \
    	--gcutstr 2 \
    	--vox 1 \
    	--bb 12 \
    	--fwhm 4 \
    	--out_dir /OUTPUTS

