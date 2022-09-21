! Fortran example  
!   This example demonstrates commmunication between Fortran and C codes
!   using MPI_Gather with REAL (Fortran) and Float (C) arrays
program hello

  use mpi

  integer :: world_task, world_size, ierror, itask
  integer :: comm_app, app_task, app_size, appnum
  integer(kind=MPI_ADDRESS_KIND) appnum_temp
  logical flag

  real,allocatable :: sndbuf(:),rcvbuf(:,:)
  
! Initialize MPI
  call MPI_Init(ierror)
  call MPI_Comm_size(MPI_COMM_WORLD, world_size, ierror)
  call MPI_Comm_rank(MPI_COMM_WORLD, world_task, ierror)

! Split total mpi processes by how they were invoked by mpiexec on the command line
  ! MPI_Attr_Get is deprecated
  !call MPI_Attr_Get(MPI_COMM_WORLD, MPI_APPNUM, appnum, flag, ierror)
  ! MPI_Comm_Attr seems to require kind=MPI_ADDRESS_KIND for 3rd argument
  call MPI_Comm_Get_Attr(MPI_COMM_WORLD, MPI_APPNUM, appnum_temp, flag, ierror)
  ! MPI_Comm_split seems to require regular integer for 2nd argument
  appnum = appnum_temp
  call MPI_Comm_split(MPI_COMM_WORLD, appnum, world_task, comm_app, ierror);
  call MPI_Comm_size(comm_app, app_size, ierror)
  call MPI_Comm_rank(comm_app, app_task, ierror)

! Verify MPI_Comm_split
  do itask = 0,world_size-1
    if(world_task == itask) then
      write (*,'("F-World: ",I2,"/",I0.2,";    APP ",I2,": ",I2,"/",I0.2)') world_task,world_size,appnum,app_task,app_size
    end if
    call MPI_BARRIER( MPI_COMM_WORLD, ierror)
  end do
  
  allocate(sndbuf(3))
  allocate(rcvbuf(3,world_size))

! Pack send buffer with easily verifiable test data
  sndbuf(1) = real(appnum)+1.
  sndbuf(2) = real(app_task)+1.
  sndbuf(3) = real(app_task)+2.

! Receive message from C program
  call MPI_Gather(sndbuf,3,MPI_REAL,rcvbuf,3,MPI_REAL,0,MPI_COMM_WORLD,ierror)

! Verify MPI_Gather
  if(world_task == 0) then
    do itask = 1,world_size
      write (*,'("F-Gather: ",3F5.2)') rcvbuf(1:3,itask)
    end do
  end if

  deallocate(sndbuf)
  deallocate(rcvbuf)

! Finalize MPI
  call MPI_Finalize(ierror)

end
