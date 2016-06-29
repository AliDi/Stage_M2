#!/bin/bash

#OAR -n tfm
#OAR -l /nodes=1/core=4,walltime=00:10:00

# Modules loading
source /soft/env.bash
module load MATLAB/R2014b

# Launch compute job
/soft/MATLAB/R2014b/bin/matlab -nodisplay -nosplash < config.m > /home/dinsenma/simul_TFM/matlab_tfm.out
