#!/bin/bash
#SBATCH --job-name=hpl
#SBATCH --partition=hpc
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00
#SBATCH --output=output.%j.%N

# HPL executable filename and BLIS library location
OPENMPI=/opt/openmpi-4.0.3
MPIRUN=$OPENMPI/bin/mpirun

# Number of processes - must match product of Ps x Qs in HPL.dat and should be
# the number of L3 cache domains in the system.
MPI_OPTS="-np 2"

# Use vader for Byte Transfer Layer
MPI_OPTS+=" --mca pml ucx --mca osc ucx"

# Map processes to L3 cache
# PPR = Processes Per Resource: ppr:<# of processes for this resource>:<resource>
# PE=n after the resource means assign n processing elements to the resource
# Note if SMT is enabled, the resource list given to the process will include
# the SMT siblings! See OpenMP options above.
#MPI_OPTS+=" -x OMP_NUM_THREADS"
#MPI_OPTS+=" -x OMP_PLACES"
# Show bindings
#MPI_OPTS+=" --report-bindings"

module purge
module load mpi/openmpi-4.0.3
#cmd="srun --mpi=pmi2 -n 60 --cpus-per-task=4 ./xhpl"
cmd="$MPIRUN $MPI_OPTS ./osu_bw"
$cmd
cmd="$MPIRUN $MPI_OPTS ./osu_latency"
$cmd


