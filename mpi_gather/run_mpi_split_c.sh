#!/bin/tcsh

# Running with MPT
#/glade/u/apps/ch/opt/mpt/2.22/bin/mpiexec_mpt -p "(p %g/%G| h %h/%H): " -n 2 test_mpi_split_c
# Running with openmpi (i.e., on Casper)
mpiexec -n 1 test_mpi_split_c : -n 1 test_mpi_split_c
mpiexec -n 2 test_mpi_split_c
