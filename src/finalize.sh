#!/bin/bash

## Cleanup after matlab script

echo Running $(basename "${BASH_SOURCE}")

cd "${out_dir}"


## Gzip all outputs for xnat
gzip *.nii
gzip mri/*.nii
gzip surf/*.gii


## Remove copies of inputs
rm t1_1.nii.gz
rm t1_2.nii.gz
if [ "${t1_3_niigz}" != "none" ]; then
	rm t1_3.nii.gz
fi

if [ "${t1_4_niigz}" != "none" ]; then
	rm t1_4.nii.gz
fi


## Move files into sensibly named directories for xnat
# Gray matter
mkdir GRAY_REALIGNED 
mv mri/p1rt1*.nii.gz GRAY_REALIGNED 

mkdir GRAY_MNORM 
mv mri/mwp1rt1*.nii.gz GRAY_MNORM 

mkdir GRAY_MNORM_SMOOTH 
mv mri/s${fwhm}mwp1rt1*.nii.gz GRAY_MNORM_SMOOTH 

# White matter
mkdir WHITE_REALIGNED 
mv mri/p2rt1*.nii.gz WHITE_REALIGNED 

mkdir WHITE_MNORM 
mv mri/mwp2rt1*.nii.gz WHITE_MNORM 

# ICV = GM + WM + CSF
mkdir ICV_REALIGNED 
mv mri/p0rt1*.nii.gz  ICV_REALIGNED 

mkdir ICV_AVERAGE 
mv mri/p0avg_t1_1.nii.gz  ICV_AVERAGE 

# Bias corrected, not skull-stripped
mkdir BIAS_REALIGNED  
mv rt1*.nii.gz BIAS_REALIGNED 

mkdir BIAS_AVERAGE  
mv avg_t1_1.nii.gz BIAS_AVERAGE 

mkdir BIAS_AVERAGE_NORM  
mv wavg_t1_1.nii.gz BIAS_AVERAGE_NORM 

# Deformation fields
mkdir DEF_FWD 
mv mri/y_*.nii.gz  DEF_FWD 
mv mri/avg_y_*.nii.gz  DEF_FWD 

# Tissue probability maps
mkdir TPM 
mv mri/rp*avg_t1_1_affine.nii.gz TPM 
mv mri/longTPM_rp1avg_t1_1_affine.nii.gz TPM 

# Labels
mv label tmplabel 
mkdir LABEL 
mv tmplabel/catROI*  LABEL 
rmdir tmplabel 

# Log files
mkdir LOG 
mv report/catlog*  LOG 
mv log_cat*  LOG 

# MAT and XML files
mkdir MAT 
mv report/cat*.mat  MAT 
mv report/cat*.xml  MAT 

# Concatenated PDF
mkdir PDF 
mv cat12_longitudinal.pdf  PDF 

# Individual reports
mv report tmpreport 
mkdir REPORT 
mv tmpreport/catreport*.pdf REPORT 

# Snapshots
mkdir SNAPSHOTS 
mv tmpreport/*.jpg SNAPSHOTS 
rmdir tmpreport 

# Surface files
mkdir SURFACE 
mv surf/* SURFACE 

# TIV file
mkdir TIV 
mv TIV.txt TIV 


## Cleanup empty directories
rmdir mri 
rmdir surf 

