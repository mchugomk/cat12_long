#!/bin/bash

## Primary entrypoint for cat12 longitudinal pipeline. 
#	Parses the command line arguments and exports as environment variables 
#	Call main pipeline script cat12_long_main.sh
#
# Example usage:
# 
# cat12_long_entrypoint.sh --t1_1_niigz /path/to/image_1.nii.gz \
#	--t1_2_niigz /path/to/image_2.nii.gz \
#	--t1_3_niigz /path/to/image_3.nii.gz \
#	--t1_4_niigz /path/to/image_4.nii.gz \
#	--longmodel 1 \
#	--nproc 0 \
#	--gcutstr 2 \
#	--vox 1 \
#	--bb 12 \
#	--fwhm 4 \
#	--label_info "UNKNOWN_SCAN" \
#	--out_dir "../OUTPUTS"
#

# This statement at the top of every bash script is helpful for debugging
echo Running $(basename "${BASH_SOURCE}")


# Initialize defaults for any input parameters where that seems useful
export t1_3_niigz="none"	# Optional 3rd input T1 
export t1_4_niigz="none"	# Optional 4th input T1 
export longmodel=1
export nproc=0
export gcutstr=2
export vox=1
export bb=12
export fwhm=4
export label_info="UNKNOWN_SCAN"
export out_dir="../OUTPUTS"


# Parse input options
while [[ $# -gt 0 ]]
do
    case "$1" in

        --t1_1_niigz)
            # Full path and filename to input T1 image 1
            export t1_1_niigz="$2"; shift; shift ;;

        --t1_2_niigz)
            # Full path and filename to input T1 image 2
            export t1_2_niigz="$2"; shift; shift ;;

        --t1_3_niigz)
            # Full path and filename to input T1 image 3
            export t1_3_niigz="$2"; shift; shift ;;

        --t1_4_niigz)
            # Full path and filename to input T1 image 4
            export t1_4_niigz="$2"; shift; shift ;;

		--longmodel)
            # Model for longitudinal processing
            export longmodel="$2"; shift; shift ;;
            
		--nproc)
            # Number of cores/processors for parallel processing
            export nproc="$2"; shift; shift ;;
        
        --gcutstr)
            # Skull-stripping method
            export gcutstr="$2"; shift; shift ;;

        --vox)
            # Voxel size for output normalized images
            export vox="$2"; shift; shift ;;

        --bb)
            # Bounding box type for output volumes
            export bb="$2"; shift; shift ;;

        --fwhm)
            # FWHM of spatial smoothing kernel applied to output GM images
            export fwhm="$2"; shift; shift ;;
            
        --label_info)
            # Labels from XNAT that we will use to label the QA PDF
            export label_info="$2"; shift; shift ;;

        --out_dir)
            # Where outputs will be stored. 
            export out_dir="$2"; shift; shift ;;
            
		*)
			# Handle any unrecognized options
            echo "Input ${1} not recognized"
            shift ;;

    esac
done



# Now that we have all the inputs stored in environment variables, call the
# main pipeline. We run it in xvfb so that we have a virtual display available.
xvfb-run -n $(($$ + 99)) -s '-screen 0 1600x1200x24 -ac +extension GLX' \
    bash cat12_long_main.sh
