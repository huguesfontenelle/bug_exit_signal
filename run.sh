#!/usr/bin/env bash
set -e
export NXF_VER=18.10.1
export NXF_HOME=/cluster/projects/p193/OI/sw/ngs-pipeline/thirdparty/nextflow/${NXF_VER}/
module load java
nextflow -C nextflow.config run bug_exit_signal.nf -profile local
nextflow -C nextflow.config run bug_exit_signal.nf -profile singularity
