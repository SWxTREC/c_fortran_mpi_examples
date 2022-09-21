// C example
//   This example demonstrates commmunication between Fortran and C codes
//   using MPI_Send/MPI_Recv with REAL (Fortran) and FLOAT (C) arrays
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
  for (itask=0; itask<world_size; itask++) {
    if (itask==world_task) {
      printf("C-World: %2d/%0.2d;  APP %2d: %2d/%0.2d\n",world_task,world_size,appnum,app_task,app_size);
    }
    ierror = MPI_Barrier( MPI_COMM_WORLD );
  }

// Setup send/recv buffers
  float sndbuf[3] = {(float)appnum+5.,(float)app_task+5.,(float)app_task+6.};
  float rcvbuf[3];

// Identify root task of other app
  int idest;
  if (appnum == 0)
    idest = app_size;
  else
    idest = 0;

//
  if (app_task == 0) {
    // Verify MPI_Recv
    printf("C-Send  to  %2d: %5.2f%5.2f%5.2f\n", idest,sndbuf[0],sndbuf[1],sndbuf[2]);
    // Send/Recv
    ierror = MPI_Send(&sndbuf, 3, MPI_FLOAT, idest, 1, MPI_COMM_WORLD);
    ierror = MPI_Recv(&rcvbuf, 3, MPI_FLOAT, idest, 1, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    // Verify MPI_Recv
    printf("C-Recv from %2d: %5.2f%5.2f%5.2f\n", idest,rcvbuf[0],rcvbuf[1],rcvbuf[2]);
  } 
// Finalize the MPI environment.
  MPI_Finalize();
}
