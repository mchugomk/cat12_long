#!/bin/bash
#
# PDF for QA check

echo Running $(basename "${BASH_SOURCE}")

echo Making PDF
info_string="${label_info}" # May need to adjust to account for multiple T1s, not currently using

# Work in output directory
cd ${out_dir}

# Get list of all cat12 pdfs
reportlist=`ls report/catreport*.pdf`

# Combine into single PDF
# -gravity NorthWest -fill blue -pointsize 10 -annotate +100+950 "${info_string}" \
convert -density 300 \
	-gravity SouthWest -fill blue -pointsize 10 -annotate +100+30 "$(date)" \
	${reportlist[@]} \
	cat12_longitudinal.pdf

