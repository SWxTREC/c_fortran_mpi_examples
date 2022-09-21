#!/bin/tcsh
module unload intel
module load gnu/9.1.0


mpif90 -o test_mpi_split_f test_mpi_split.f90


mpicc -o test_mpi_split_c test_mpi_split.c
