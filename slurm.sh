#!/bin/bash
#SBATCH --job-name=hpl
#SBATCH --partition=hpc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4

#SBATCH --output=output.%j.%N

export PATH=$PATH:/shared/home/others/mpi/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/shared/home/others/mpi/lib:/shared/home/others/blas/lib

mpirun -np 4 ./xhpl
