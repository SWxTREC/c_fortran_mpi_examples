#!/bin/tcsh

# Running with MPT
#/glade/u/apps/ch/opt/mpt/2.22/bin/mpiexec_mpt -p "(p %g/%G| h %h/%H): " -n 2 test_mpi_split_f
# Running with openmpi (i.e., on Casper)
mpiexec -n 1 test_mpi_split_f : -n 1 test_mpi_split_f
mpiexec -n 2 test_mpi_split_f
