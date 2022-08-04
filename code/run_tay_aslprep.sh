#!/bin/bash -l

#SBATCH --partition=high-moby
#SBATCH --array=1-154
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=4096
#SBATCH --cpus-per-task=4
#SBATCH --time=24:00:00
#SBATCH --export=ALL
#SBATCH --job-name aslprep
#SBATCH --output=/scratch/jwong/aslprep/log/aslprep_%j.txt

cd $SLURM_SUBMIT_DIR

STUDY="TAY"

sublist="/scratch/jwong/aslprep/aslprep_sublist2.txt"

index() {
   head -n $SLURM_ARRAY_TASK_ID $sublist \
   | tail -n 1
}

sub=`index`
sub=$(echo "$sub" | tr -d '\r')

BIDS_DIR=/archive/data/TAY/data/bids
OUT_DIR=/scratch/jwong/aslprep/output/
WORK_DIR=/scratch/jwong/aslprep/work/
DANAT_DIR=/scratch/jwong/fmriprep_dl/fmriprep

mkdir -p $BIDS_DIR $OUT_DIR $WORK_DIR

echo singularity run \
  -H /scratch/jwong/aslprep/sing_tmp \
  -B ${BIDS_DIR}:/bids \
  -B ${OUT_DIR}:/out \
  -B ${WORK_DIR}:/work \
  -B /scratch/smansour/freesurfer/6.0.1/build/license.txt:/li \
  -B ${DANAT_DIR}:/danat \
  -B /scratch/jwong/aslprep/aslprep_filter.json:/ft \
  /archive/code/containers/ASLPREP/pennlinc_aslprep_0.2.7-2021-03-07-75bc2564a7c2.simg \
  /bids /out participant \
  --participant_label ${sub} \
  -w /work \
  --fs-license-file /li \
  --n_cpus 4 \
  --anat-derivatives /danat \
  --smooth_kernel 0 \
  --m0_scale 100 \
  --output-spaces MNI152NLin2009cAsym asl \
  --notrack --skip-bids-validation \
  --bids-filter-file /ft

singularity run \
  -H /scratch/jwong/aslprep/sing_tmp \
  -B ${BIDS_DIR}:/bids \
  -B ${OUT_DIR}:/out \
  -B ${WORK_DIR}:/work \
  -B /scratch/smansour/freesurfer/6.0.1/build/license.txt:/li \
  -B ${DANAT_DIR}:/danat \
  -B /scratch/jwong/aslprep/aslprep_filter.json:/ft \
  /archive/code/containers/ASLPREP/pennlinc_aslprep_0.2.7-2021-03-07-75bc2564a7c2.simg \
  /bids /out participant \
  --participant_label ${sub} \
  -w /work \
  --fs-license-file /li \
  --n_cpus 4 \
  --anat-derivatives /danat \
  --smooth_kernel 0 \
  --m0_scale 100 \
  --output-spaces MNI152NLin2009cAsym asl \
  --notrack --skip-bids-validation \
  --bids-filter-file /ft
