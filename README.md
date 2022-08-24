# asl-preprocessing

## Workflow to obtain ASLPrep output
1. ### Run fMRIPrep
    - ASLprep reuses the anatomical derivatives from fMRIPrep output
- A total of 1 T1-weighted (T1w) images were found within the input BIDS dataset. The T1-weighted (T1w) image was corrected for intensity non-uniformity (INU) with N4BiasFieldCorrection (Tustison et al. 2010), distributed with ANTs 2.3.3 (Avants et al. 2008, RRID:SCR_004757), and used as T1w-reference throughout the workflow. The T1w-reference was then skull-stripped with a Nipype implementation of the antBrainExtraction. Sh workflow (from ANTs), using OASIS30ANTs as target template. Brain tissue segmentation of cerebrospinal fluid (CSF), white-matter (WM) and gray-matter (GM) was performed on the brain-extracted T1w using fast (FSL 5.0.9, RRID:SCR_002823, Zhang, Brady, and Smith 2001). Brain surfaces were reconstructed using recon-all (FreeSurfer 6.0.1, RRID:SCR_001847, Dale, Fischl, and Sereno 1999), and the brain mask estimated previously was refined with a custom variation of the method to reconcile ANTs-derived and FreeSurfer-derived segmentations of the cortical gray-matter of Mindboggle (RRID:SCR_002438, Klein et al. 2017). Volume-based spatial normalization to two standard spaces (MNI152NLin2009Asym, MNI152NLin6Asym) was performed through nonlinear registration with antsRegistration (ANTs 2.3.3), using brain-extracted versions of both T1w reference and the T1w template. The following templates were selected for spatial normalization: ICBM 152 Nonlinear Asymmetrical template version 2009c [Fonov et al. (2009), RRID:SCR_008796; TemplateFlow ID: MNI152NLin2009cAsym], FSL’s MNI ICBM 152 non-linear 6th Generation Asymmetric Average Brain Stereotaxic Registration Model [Evans et al. (2012), RRID:SCR_002823; TemplateFlow ID: MNI152NLin6Asym]. 

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
 
  - Preprocessing of ASL (Arterial Spin Labelling) files is split into multiple sub-workflows. ASL reference image estimation workflow estimates a reference image for an ASL series. The reference image is then used to calculate a brain mask for the ASL signal using NiWorkflow’s init_enhance_and_skullstrip_asl_wf(). Subsequently, the reference image is fed to the head-motion estimation workflow and the registration workflow to map the ASL series onto the T1w image of the same subject. Using the previously estimated reference scan, FSL mcflirt or AFNI 3dvolreg is used to estimate head-motion. As a result, one rigid-body transform with respect to the reference image is written for each ASL time-step. Additionally, a list of 6-parameters (three rotations and three translations) per time-step is written and fed to the confounds workflow, for a more accurate estimation of head-motion. If the SliceTiming field is available within the input dataset metadata, this workflow performs slice time correction prior to other signal resampling processes. Slice time correction is performed using AFNI 3dTShift. All slices are realigned in time to the middle of each TR. Slice time correction can be disabled with the --ignore slicetiming command line argument. Calculated confounds include frame-wise displacement, 6 motion parameters, and DVARS. One of the major problems that affects EPI (echo planar imaging) data is the spatial distortion caused by the inhomogeneity of the field inside the scanner. In preprocessed ASL in native space a new preproc ASL series is generated from either the slice-timing corrected data or the original data (if STC (slice-timing correction) was not applied) in the original space. All volumes in the ASL series are resampled in their native space by concatenating the mappings found in previous correction workflows (HMC (head-motion correction) and
SDC (susceptibility-derived distortion correction), if executed) for a one-shot interpolation process. Interpolation uses a Lanczos kernel.

4. ### QC ASLprep output
    - QC file: `sub-CMH*/ses-01/perf/*desc-quality_control_cbf.csv`

5. ### Run statsitical analysis
    - Havard Oxford atlas: `sub-CMH*/ses-01/perf/*desc-HavardOxford_mean_cbf.csv`
We investigated the relationship between age and biological sex on mean CBF within GM. Post-hoc ROI analyses were conducted within limbic regions (i.e., the amygdala, hippocampus, and the anterior division of the cingulate gyrus). Independent sample t-test were performed to examine differences in demographic and clinical characteristics of the participants. Correlational analysis was performed to look for correlations between age and CBF within GM and each ROI. All analyses were performed using R statistical software. 
## Contact 
Ghazaleh Ahmadzadeh 
- HBSc University of Toronto
- ghazaleh.ahmadzadeh@mail.utoronto.ca
