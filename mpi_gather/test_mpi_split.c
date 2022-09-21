// C example
//   This example demonstrates commmunication between Fortran and C codes
//   using MPI_Gather with REAL (Fortran) and Float (C) arrays
#include <mpi.h>
#include <stdio.h>

int main(int argc, char** argv) {

// Initialize the MPI environment
  MPI_Init(NULL, NULL);

// Get the number of processes
  int world_size;
  MPI_Comm_size(MPI_COMM_WORLD, &world_size);

// Get the rank of the process
  int world_task;
  MPI_Comm_rank(MPI_COMM_WORLD, &world_task);

// Split total mpi processes by how they were invoked by mpiexec on the command line
  int ierror;
  int appnum;
  int flag;
  void *v;
  ierror = MPI_Comm_get_attr(MPI_COMM_WORLD, MPI_APPNUM, &v, &flag);
  appnum = *(int*)v;
  MPI_Comm comm_app;
  ierror = MPI_Comm_split(MPI_COMM_WORLD, appnum, world_task, &comm_app);
  int app_size, app_task;
  ierror = MPI_Comm_size(comm_app, &app_size);
  ierror = MPI_Comm_rank(comm_app, &app_task);

// Verify MPI_Comm_split
  int itask;
  for (itask=0; itask<world_size; itask++)
  {
    if (itask==world_task)
    {
      printf("C-World: %2d/%0.2d;    APP %2d: %2d/%0.2d\n",world_task,world_size,appnum,app_task,app_size);
    }
    ierror = MPI_Barrier( MPI_COMM_WORLD );
  }

// Pack send buffer with easily verifiable test data
  float sndbuf[3] = {(float)appnum+1.,(float)app_task+1.,(float)app_task+2.};
  float rcvbuf[world_size][3];
  //float *rcvbuf = NULL;
  ierror = MPI_Gather(&sndbuf,3,MPI_FLOAT,&rcvbuf,3,MPI_FLOAT,0,MPI_COMM_WORLD);

// Verify MPI_Gather
  if (world_task==0)
  {
    for (itask=0; itask<world_size; itask++)
    {
      printf("C-Gather: %5.2f%5.2f%5.2f\n",rcvbuf[itask][0],rcvbuf[itask][1],rcvbuf[itask][2]);
    }
  }

// Finalize the MPI environment.
  MPI_Finalize();
}
