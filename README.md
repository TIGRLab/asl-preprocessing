# asl-preprocessing

## Workflow to obtain ASLPrep output
1. ### Run fMRIPrep
    - ASLprep reuses the anatomical derivatives from fMRIPrep output

2. ### Create a new dataset of fMRIPrep output using Datalad
    - Run `datalad install` to make a copy of the fMRIPrep output: `code/datalad_install_dataset.sh`
    - Rename files and modify folder hierarchy: `code/datalad_rename_dataset.sh`
        - `datalad unlock` the dataset
        - Run `rename.ul`
        - `datalad save` the changes

3. ### Run ASLprep
    - Create a json file describing custom BIDS input filters: `code/aslprep_filter.json`
        - To only include baseline T1w and ASL scans
    - Run the bash script: `code/run_tay_aslprep.sh`
        - Submit SLURM jobs
        - Use output spaces `MNI152NLin2009cAsym` and `asl`
        - Set `--smooth_kernel` to `0`
        - Set `--m0_scale` to `100`
        - Include `--bids-filter-file`, `--anat-derivatives`, `[--skip_bids_validation`

4. ### QC ASLprep output
    - QC file: `sub-CMH*/ses-01/perf/*desc-quality_control_cbf.csv`

5. ### Run statsitical analysis
    - Havard Oxford atlas: `sub-CMH*/ses-01/perf/*desc-HavardOxford_mean_cbf.csv`

## Contact 
Ghazaleh Ahmadzadeh 
ghazaleh.ahmadzadeh@mail.utoronto.ca
