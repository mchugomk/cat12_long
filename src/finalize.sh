#!/bin/bash

## Cleanup after matlab script

echo Running $(basename "${BASH_SOURCE}")

cd "${out_dir}"


## Remove copies of inputs
rm t1_1.nii
rm t1_2.nii
if [ "${t1_3_niigz}" != "none" ]; then
	rm t1_3.nii
fi

if [ "${t1_4_niigz}" != "none" ]; then
	rm t1_4.nii
fi


## Gzip all outputs for xnat
gzip *.nii
gzip mri/*.nii
gzip surf/*.gii


## Move files into sensibly named directories for xnat

# Gray matter
mkdir GRAY_REALIGNED 
mv mri/p1rt1*.nii.gz GRAY_REALIGNED 

mkdir GRAY_NORM
mv mri/wp1rt1*.nii.gz GRAY_NORM
mv mri/wp1avg_t1_1.nii.gz GRAY_NORM

mkdir GRAY_MNORM 
mv mri/mwp1rt1*.nii.gz GRAY_MNORM 

mkdir GRAY_MNORM_SMOOTH 
mv mri/s${fwhm}mwp1rt1*.nii.gz GRAY_MNORM_SMOOTH 


# White matter
mkdir WHITE_REALIGNED 
mv mri/p2rt1*.nii.gz WHITE_REALIGNED 

mkdir WHITE_NORM
mv mri/wp2rt1*.nii.gz WHITE_NORM
mv mri/wp2avg_t1_1.nii.gz WHITE_NORM

mkdir WHITE_MNORM 
mv mri/mwp2rt1*.nii.gz WHITE_MNORM 


# CSF
mkdir CSF_REALIGNED
mv mri/p3rt1*.nii.gz CSF_REALIGNED

mkdir CSF_NORM
mv mri/wp3rt1*.nii.gz CSF_NORM
mv mri/wp3avg_t1_1.nii.gz CSF_NORM

mkdir CSF_MNORM
mv mri/mwp3rt1*.nii.gz CSF_MNORM


# ICV = GM + WM + CSF
mkdir ICV_REALIGNED 
mv mri/p0rt1*.nii.gz  ICV_REALIGNED 
mv mri/p0avg_t1_1.nii.gz ICV_REALIGNED 


# Bias corrected, not skull-stripped
mkdir BIAS_REALIGNED  
mv mri/mrt1*.nii.gz BIAS_REALIGNED 
mv mri/mavg_t1_1.nii.gz BIAS_REALIGNED  


# T1s not bias corrected
mkdir T1_REALIGNED
mv rt1*.nii.gz T1_REALIGNED
mv avg_t1_1.nii.gz T1_REALIGNED

mkdir T1_NORM
mv wavg_t1_1.nii.gz T1_NORM


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


# Log files - may not need this
mkdir LOG 
mv report/catlog*  LOG 
mv log_cat*  LOG 


# MAT and XML files
mkdir MAT 
mv report/cat*.mat  MAT 
mv report/cat*.xml  MAT 


# Concatenated PDF
mkdir PDF 
mv cat12_longitudinal.pdf PDF 


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


# SPM Batch
mkdir BATCH
mv cat12batch.mat BATCH


## Remove extra files - may need to remove
rm mri/mwp3avg*.nii.gz
rm mri/p3avg*.nii.gz

## Cleanup empty directories
rmdir mri 
rmdir surf 


 

