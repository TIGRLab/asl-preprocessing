#!/bin/bash
for sub in `find /scratch/jwong/fmriprep_dl/fmriprep/sub-CMH* -type d -maxdepth 0`
do
(
	# Run in subshell
	cd ${sub}
	datalad unlock -r
	rename.ul "_ses-01" "" ./ses-01/anat/*
	mv ses-01/anat .
	datalad save . -m "Remove session id from the filename and move anat folder one-level below the subject folder"
)
done
