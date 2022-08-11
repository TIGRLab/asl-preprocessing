# Ran on bayes
module load datalad

mkdir fmriprep_dl
cd fmriprep_dl
datalad install -r -s file:///archive/data/TAY/pipelines/bids_apps/fmriprep-ciftify/fmriprep fmriprep
cd fmriprep
datalad get */ses-01/anat/*
