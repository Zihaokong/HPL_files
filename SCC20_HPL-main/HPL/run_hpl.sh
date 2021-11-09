#!/bin/bash
#SBATCH --job-name=hpl
#SBATCH --partition=hpc
#SBATCH --nodes=20
#SBATCH --ntasks-per-node=30
#SBATCH --cpus-per-task=4
#SBATCH --output=output.%j.%N

# HPL executable filename and BLIS library location
XHPL=./xhpl
OPENMPI=/opt/openmpi-4.0.3
#~/spack/opt/spack/linux-centos7-x86_64/gcc-4.8.5/openmpi-3.1.6-oyczoz3a6xe7rftc7cdhuukb6sdncwjb

# Number of cores per L3 cache. Change if needed - e.g. on certain
# 48 core, 32 core, 24 core and 16 core SKUs.
CORES=4

# Number of L3 caches per system. Change if needed - e.g. on certain
# 48 core, 32 core, 24 core and 16 core SKUs. Also insure that the
# product of Ps x Qs in HPL.dat matches this value.

# need to change
L3S=600

#
# OpenMP environment variables
#

# Use explicit binding and ignore SMT siblings if SMT is enabled
export OMP_PLACES=cores

# Number of OpenMP threads per MPI process
export OMP_NUM_THREADS=$CORES

#
# BLIS library environment variables
#

# DGEMM parallelization is performed at the 2nd innermost loop (IC)
# This is what we want because the theads in this case are operating
# on single-threaded cores each with a private L1 & L2 but shared L3.
export BLIS_IR_NT=1
export BLIS_JR_NT=1
export BLIS_IC_NT=$CORES
export BLIS_JC_NT=1


#
# OpenMPI settings
#

MPIRUN=$OPENMPI/bin/mpirun

# Number of processes - must match product of Ps x Qs in HPL.dat and should be
# the number of L3 cache domains in the system.
MPI_OPTS="-np $L3S"

# Use vader for Byte Transfer Layer
MPI_OPTS+=" --mca pml ucx --mca osc ucx"

# Map processes to L3 cache
# PPR = Processes Per Resource: ppr:<# of processes for this resource>:<resource>
# PE=n after the resource means assign n processing elements to the resource
# Note if SMT is enabled, the resource list given to the process will include
# the SMT siblings! See OpenMP options above.
MPI_OPTS+=" --map-by l3cache:PE=4"
# Show bindings
#MPI_OPTS+=" --report-bindings"

module load mpi/openmpi-4.0.3
module load amd/blis-mt 
cmd="$MPIRUN $MPI_OPTS $XHPL"

echo $cmd
$cmd

