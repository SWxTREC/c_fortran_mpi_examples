#!/bin/tcsh
# This script is designed to run on NSF's Cheyenne HPC (using MPT or OpenMPI) or Casper system (OpenMPI only).
# Modify as needed.

# Running with MPT
#/glade/u/apps/ch/opt/mpt/2.22/bin/mpiexec_mpt -p "(p %g/%G| h %h/%H): " -n 2 test_mpi_split_f 1 2 3 4 5 6 7 8 9 : -n 3 test_mpi_split_c 
/glade/u/apps/ch/opt/mpt/2.22/bin/mpiexec_mpt -p "(p %g/%G| h %h/%H): " -n 1 test_mpi_split_f : -n 1 test_mpi_split_c
echo -------------------------------------------------------------------
/glade/u/apps/ch/opt/mpt/2.22/bin/mpiexec_mpt -p "(p %g/%G| h %h/%H): " -n 1 test_mpi_split_c : -n 1 test_mpi_split_f
echo -------------------------------------------------------------------
/glade/u/apps/ch/opt/mpt/2.22/bin/mpiexec_mpt -p "(p %g/%G| h %h/%H): " -n 2 test_mpi_split_f : -n 2 test_mpi_split_c
echo -------------------------------------------------------------------
/glade/u/apps/ch/opt/mpt/2.22/bin/mpiexec_mpt -p "(p %g/%G| h %h/%H): " -n 2 test_mpi_split_c : -n 2 test_mpi_split_f
# Running with openmpi (i.e., on Casper)
#mpiexec -n 1 test_mpi_split_f : -n 1 test_mpi_split_c
#echo -------------------------------------------------------------------
#mpiexec -n 1 test_mpi_split_c : -n 1 test_mpi_split_f
#echo -------------------------------------------------------------------
#mpiexec -n 2 test_mpi_split_f : -n 2 test_mpi_split_c
#echo -------------------------------------------------------------------
#mpiexec -n 2 test_mpi_split_c : -n 2 test_mpi_split_f
