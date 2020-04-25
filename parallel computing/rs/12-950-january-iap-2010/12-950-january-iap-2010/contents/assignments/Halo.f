      PROGRAM TIMEAG
      IMPLICIT NONE
C
C     TIME A SIMULATED HALO EXCHANGE, MPI VERSION.
C     PRINT AVERAGE TIME FROM ABOUT 3 SECONDS WORTH OF TRANSFERS.
C
      INCLUDE 'mpif.h'
C
      INTEGER        MPIERR,MPIREQ,MPISTAT
      COMMON/XCMPII/ MPIERR,MPIREQ(4),
     +               MPISTAT(MPI_STATUS_SIZE,4)
C
      INTEGER    NMAX
      PARAMETER (NMAX=1024)
C
      INTEGER          L,LREP,M,MYPE,N,N1,N2,NPES
      DOUBLE PRECISION T,TALL
C
      CALL MPI_INIT(MPIERR)
      CALL MPI_COMM_RANK(MPI_COMM_WORLD, MYPE, MPIERR)
      CALL MPI_COMM_SIZE(MPI_COMM_WORLD, NPES, MPIERR)
C
C     INITIALIZE 2D GRID.
C
      CALL GRID2D(N1,N2)
      IF     (MYPE.EQ.0) THEN
        WRITE(6,*) 
        WRITE(6,*) NPES,' PE''S AS A ',N1,' BY ',N2,' GRID'
        WRITE(6,*) 
        CALL FLUSH(6)
      ENDIF
      CALL MPI_BARRIER(MPI_COMM_WORLD,MPIERR)
C
C     SENDRECV VERSION.
C
      DO M= 1,10
        N = MIN( NMAX, 2**M )
        CALL HALO2A(N)
        CALL MPI_BARRIER(MPI_COMM_WORLD,MPIERR)
        T = MPI_WTIME()
        CALL HALO2A(N)
        CALL HALO2A(N)
        CALL HALO2A(N)
        CALL HALO2A(N)
        CALL HALO2A(N)
        T = MPI_WTIME() - T
        CALL REDUCE(T, TALL)
        LREP = MAX( 5, NINT(3.0/(TALL/5.0)) )
C
        CALL MPI_BARRIER(MPI_COMM_WORLD,MPIERR)
        T = MPI_WTIME()
        DO L= 1,LREP
          CALL HALO2A(N)
        ENDDO
        T = MPI_WTIME() - T
        CALL REDUCE(T,TALL)
        IF     (MYPE.EQ.0) THEN
          WRITE(6,6000) 'HALO2A',NPES,N,TALL/LREP
          CALL FLUSH(6)
        ENDIF
      ENDDO
      IF     (MYPE.EQ.0) THEN
        WRITE(6,*)
        CALL FLUSH(6)
      ENDIF
      CALL MPI_BARRIER(MPI_COMM_WORLD,MPIERR)
C
C     STANDARD SEND/RECV VERSION, BUT ONLY FOR N1 AND N2 EVEN
C
      IF     (.FALSE. .AND.
     +        MOD(N1,2).EQ.0 .AND. MOD(N2,2).EQ.0) THEN
      DO M= 1,10
        N = MIN( NMAX, 2**M )
        CALL HALO2B(N)
        CALL MPI_BARRIER(MPI_COMM_WORLD,MPIERR)
        T = MPI_WTIME()
        CALL HALO2B(N)
        CALL HALO2B(N)
        CALL HALO2B(N)
        CALL HALO2B(N)
        CALL HALO2B(N)
        T = MPI_WTIME() - T
        CALL REDUCE(T, TALL)
        LREP = MAX( 5, NINT(3.0/(TALL/5.0)) )
C
        CALL MPI_BARRIER(MPI_COMM_WORLD,MPIERR)
        T = MPI_WTIME()
        DO L= 1,LREP
          CALL HALO2B(N)
        ENDDO
        T = MPI_WTIME() - T
        CALL REDUCE(T,TALL)
        IF     (MYPE.EQ.0) THEN
          WRITE(6,6000) 'HALO2B',NPES,N,TALL/LREP
          CALL FLUSH(6)
        ENDIF
      ENDDO
      IF     (MYPE.EQ.0) THEN
        WRITE(6,*)
        CALL FLUSH(6)
      ENDIF
      CALL MPI_BARRIER(MPI_COMM_WORLD,MPIERR)
      ENDIF
C
C     ISEND THEN IRECV VERSION.
C
      DO M= 1,10
        N = MIN( NMAX, 2**M )
        CALL HALO2D(N)
        CALL MPI_BARRIER(MPI_COMM_WORLD,MPIERR)
        T = MPI_WTIME()
        CALL HALO2D(N)
        CALL HALO2D(N)
        CALL HALO2D(N)
        CALL HALO2D(N)
        CALL HALO2D(N)
        T = MPI_WTIME() - T
        CALL REDUCE(T, TALL)
        LREP = MAX( 5, NINT(3.0/(TALL/5.0)) )
C
        CALL MPI_BARRIER(MPI_COMM_WORLD,MPIERR)
        T = MPI_WTIME()
        DO L= 1,LREP
          CALL HALO2D(N)
        ENDDO
        T = MPI_WTIME() - T
        CALL REDUCE(T,TALL)
        IF     (MYPE.EQ.0) THEN
          WRITE(6,6000) 'HALO2D',NPES,N,TALL/LREP
          CALL FLUSH(6)
        ENDIF
      ENDDO
      IF     (MYPE.EQ.0) THEN
        WRITE(6,*)
        CALL FLUSH(6)
      ENDIF
      CALL MPI_BARRIER(MPI_COMM_WORLD,MPIERR)
C
C     PERSISTENT ISEND THEN IRECV VERSION.
C
      DO M= 1,10
        N = MIN( NMAX, 2**M )
        CALL HALO2P(N)
        CALL MPI_BARRIER(MPI_COMM_WORLD,MPIERR)
        T = MPI_WTIME()
        CALL HALO2P(N)
        CALL HALO2P(N)
        CALL HALO2P(N)
        CALL HALO2P(N)
        CALL HALO2P(N)
        T = MPI_WTIME() - T
        CALL REDUCE(T, TALL)
        LREP = MAX( 5, NINT(3.0/(TALL/5.0)) )
C
        CALL MPI_BARRIER(MPI_COMM_WORLD,MPIERR)
        T = MPI_WTIME()
        DO L= 1,LREP
          CALL HALO2P(N)
        ENDDO
        T = MPI_WTIME() - T
        CALL REDUCE(T,TALL)
        IF     (MYPE.EQ.0) THEN
          WRITE(6,6000) 'HALO2P',NPES,N,TALL/LREP
          CALL FLUSH(6)
        ENDIF
      ENDDO
      IF     (MYPE.EQ.0) THEN
        WRITE(6,*)
        CALL FLUSH(6)
      ENDIF
      CALL MPI_BARRIER(MPI_COMM_WORLD,MPIERR)
C
C     IRECV THEN ISEND VERSION.
C
      DO M= 1,10
        N = MIN( NMAX, 2**M )
        CALL HALO2E(N)
        CALL MPI_BARRIER(MPI_COMM_WORLD,MPIERR)
        T = MPI_WTIME()
        CALL HALO2E(N)
        CALL HALO2E(N)
        CALL HALO2E(N)
        CALL HALO2E(N)
        CALL HALO2E(N)
        T = MPI_WTIME() - T
        CALL REDUCE(T, TALL)
        LREP = MAX( 5, NINT(3.0/(TALL/5.0)) )
C
        CALL MPI_BARRIER(MPI_COMM_WORLD,MPIERR)
        T = MPI_WTIME()
        DO L= 1,LREP
          CALL HALO2E(N)
        ENDDO
        T = MPI_WTIME() - T
        CALL REDUCE(T,TALL)
        IF     (MYPE.EQ.0) THEN
          WRITE(6,6000) 'HALO2E',NPES,N,TALL/LREP
          CALL FLUSH(6)
        ENDIF
      ENDDO
      IF     (MYPE.EQ.0) THEN
        WRITE(6,*)
        CALL FLUSH(6)
      ENDIF
      CALL MPI_BARRIER(MPI_COMM_WORLD,MPIERR)
C
C     PERSISTENT IRECV THEN ISEND VERSION.
C
      DO M= 1,10
        N = MIN( NMAX, 2**M )
        CALL HALO2Q(N)
        CALL MPI_BARRIER(MPI_COMM_WORLD,MPIERR)
        T = MPI_WTIME()
        CALL HALO2Q(N)
        CALL HALO2Q(N)
        CALL HALO2Q(N)
        CALL HALO2Q(N)
        CALL HALO2Q(N)
        T = MPI_WTIME() - T
        CALL REDUCE(T, TALL)
        LREP = MAX( 5, NINT(3.0/(TALL/5.0)) )
C
        CALL MPI_BARRIER(MPI_COMM_WORLD,MPIERR)
        T = MPI_WTIME()
        DO L= 1,LREP
          CALL HALO2Q(N)
        ENDDO
        T = MPI_WTIME() - T
        CALL REDUCE(T,TALL)
        IF     (MYPE.EQ.0) THEN
          WRITE(6,6000) 'HALO2Q',NPES,N,TALL/LREP
          CALL FLUSH(6)
        ENDIF
      ENDDO
      IF     (MYPE.EQ.0) THEN
        WRITE(6,*)
        CALL FLUSH(6)
      ENDIF
      CALL MPI_BARRIER(MPI_COMM_WORLD,MPIERR)
C
      CALL MPI_FINALIZE(MPIERR)
      CALL EXIT(0)
      STOP
C
 6000 FORMAT(2X,A6,'  NPES,N =',I3,I5,'  TIME =',F10.6,' SECONDS' )
      END
      SUBROUTINE GRID2D(N1,N2)
      IMPLICIT NONE
C
      INTEGER N1,N2
C
      INTEGER     MYPE,NPES1,NPES2,MYPEN,MYPES,MYPEE,MYPEW
      COMMON/G2D/ MYPE,NPES1,NPES2,MYPEN,MYPES,MYPEE,MYPEW
      SAVE  /G2D/
C
C     DECOMPOSE NPES NODES INTO A 2-D GRID, WITH 1X/3X/5X A POWER OF 2
C     FIRST DIMENSION, AND WITH THE TWO DIMENSIONS APPROXIMATELY EQUAL.
C
C     THEN IDENTIFY NEAREST NEIGHBORS, USING PERIODIC WRAP.
C
      INTEGER I,J,N,NPES
C
      INCLUDE 'mpif.h'
C
      INTEGER        MPIERR,MPIREQ,MPISTAT
      COMMON/XCMPII/ MPIERR,MPIREQ(4),
     +               MPISTAT(MPI_STATUS_SIZE,4)
C
      INTEGER    NMAX
      PARAMETER (NMAX=1024)
C
      REAL*4      HONS,HOEW
      COMMON/G2O/ HONS(NMAX*3),HOEW(NMAX*3)
      SAVE  /G2O/
C
      DATA HOEW / NMAX*0.0, NMAX*0.0, NMAX*0.0 /
C
      CALL MPI_COMM_RANK(MPI_COMM_WORLD, MYPE, MPIERR)
      CALL MPI_COMM_SIZE(MPI_COMM_WORLD, NPES, MPIERR)
C
      IF     (MOD(NPES,25).EQ.0) THEN
        N  = NPES/5
        N1 = 5
      ELSEIF (MOD(NPES,9).EQ.0) THEN
        N  = NPES/3
        N1 = 3
      ELSE
        N  = NPES
        N1 = 1
      ENDIF
      DO 110 I= 1,99
        IF     (MOD(N,2).NE.0 .OR. N1*N1.GE.NPES .OR. N.EQ.1) THEN
          GOTO 1110
        ELSE
          N  = N/2
          N1 = N1*2
        ENDIF
  110 CONTINUE
 1110 CONTINUE
      N2 = NPES/N1
      I  = MOD(MYPE,N1)
      J  =     MYPE/N1
C
      NPES1 = N1
      NPES2 = N2
      MYPEN = I + N1*MOD(J   +1,N2)
      MYPES = I + N1*MOD(J+N2-1,N2)
      MYPEE = MOD(I   +1,N1) + N1*J
      MYPEW = MOD(I+N1-1,N1) + N1*J
C
*     IF     (MYPE.EQ.NPES/2) THEN
*       WRITE(6,*) '     GRID2D - NPES,N1,N2   = ',NPES,N1,N2
*       WRITE(6,*) '     GRID2D - MYPE,N,S,E,W = ',
*    +                            MYPE,NPES1,NPES2,MYPEN,MYPES,MYPEE,MYPEW
*       CALL FLUSH(6)
*     ENDIF
*     CALL MPI_BARRIER(MPI_COMM_WORLD,MPIERR)
      RETURN
C     END OF GRID2D.
      END
      SUBROUTINE REDUCE(T, TALL)
      IMPLICIT NONE
      DOUBLE PRECISION T,TALL
C
C     T IS THE TIME IN SECONDS FOR AN OPERATION ON THE LOCAL NODE.
C     RETURN WITH TALL AS THE GLOBAL MAXIMUM OF T OVER ALL NODES.
C
      INCLUDE 'mpif.h'
C
      INTEGER        MPIERR,MPIREQ,MPISTAT
      COMMON/XCMPII/ MPIERR,MPIREQ(4),
     +               MPISTAT(MPI_STATUS_SIZE,4)
C
      DOUBLE PRECISION TMAX
C
      CALL MPI_ALLREDUCE(T,TMAX,1,MPI_DOUBLE_PRECISION,MPI_MAX,
     +                   MPI_COMM_WORLD,MPIERR)
      TALL = TMAX
      RETURN
C     END OF REDUCE.
      END
      SUBROUTINE HALO2A(N)
      IMPLICIT NONE
      INTEGER N
C
C     SIMULATE A HALO TRANSFER
C
C     EXCHANGE N WORDS SOUTH AND 2N WORDS NORTH
C     ONCE THEY HAVE ARRIVED
C     EXCHANGE N WORDS WEST  AND 2N WORDS EAST
C
C     THIS VERSION USES SENDRECV.
C
      INCLUDE 'mpif.h'
C
      INTEGER        MPIERR,MPIREQ,MPISTAT
      COMMON/XCMPII/ MPIERR,MPIREQ(4),
     +               MPISTAT(MPI_STATUS_SIZE,4)
C
      INTEGER    NMAX
      PARAMETER (NMAX=1024)
C
      INTEGER     MYPE,NPES1,NPES2,MYPEN,MYPES,MYPEE,MYPEW
      COMMON/G2D/ MYPE,NPES1,NPES2,MYPEN,MYPES,MYPEE,MYPEW
      SAVE  /G2D/
C
      REAL        HINS,HIEW
      COMMON/G2I/ HINS(NMAX*3),HIEW(NMAX*3)
      SAVE  /G2I/
      REAL        HONS,HOEW
      COMMON/G2O/ HONS(NMAX*3),HOEW(NMAX*3)
      SAVE  /G2O/
C
      INTEGER I
C
      DO I= 1,3*N
        HINS(I) = HOEW(I)
      ENDDO
C
      CALL MPI_SENDRECV(
     +          HINS(  1),  N,MPI_REAL,MYPES, 9901,
     +          HONS(  1),  N,MPI_REAL,MYPEN, 9901,
     +          MPI_COMM_WORLD, MPISTAT, MPIERR)
      CALL MPI_SENDRECV(
     +          HINS(N+1),2*N,MPI_REAL,MYPEN, 9902,
     +          HONS(N+1),2*N,MPI_REAL,MYPES, 9902,
     +          MPI_COMM_WORLD, MPISTAT, MPIERR)
C
      DO I= 1,3*N
        HIEW(I) = HONS(I)
      ENDDO
C
      CALL MPI_SENDRECV(
     +          HIEW(  1),  N,MPI_REAL,MYPEW, 9903,
     +          HOEW(  1),  N,MPI_REAL,MYPEE, 9903,
     +          MPI_COMM_WORLD, MPISTAT, MPIERR)
      CALL MPI_SENDRECV(
     +          HIEW(N+1),2*N,MPI_REAL,MYPEE, 9904,
     +          HOEW(N+1),2*N,MPI_REAL,MYPEW, 9904,
     +          MPI_COMM_WORLD, MPISTAT, MPIERR)
      RETURN
C     END OF HALO2A.
      END
      SUBROUTINE HALO2B(N)
      IMPLICIT NONE
      INTEGER N
C
C     SIMULATE A HALO TRANSFER
C
C     EXCHANGE N WORDS SOUTH AND 2N WORDS NORTH
C     ONCE THEY HAVE ARRIVED
C     EXCHANGE N WORDS WEST  AND 2N WORDS EAST
C
C     THIS VERSION USES SEND/RECV ON HALF THE NODES,
C                   AND RECV/SEND ON THE OTHER HALF.
C     MUST HAVE AN EVEN NUMBER OF NODES N-S AND E-W.
C
      INCLUDE 'mpif.h'
C
      INTEGER        MPIERR,MPIREQ,MPISTAT
      COMMON/XCMPII/ MPIERR,MPIREQ(4),
     +               MPISTAT(MPI_STATUS_SIZE,4)
C
      INTEGER    NMAX
      PARAMETER (NMAX=1024)
C
      INTEGER     MYPE,NPES1,NPES2,MYPEN,MYPES,MYPEE,MYPEW
      COMMON/G2D/ MYPE,NPES1,NPES2,MYPEN,MYPES,MYPEE,MYPEW
      SAVE  /G2D/
C
      REAL        HINS,HIEW
      COMMON/G2I/ HINS(NMAX*3),HIEW(NMAX*3)
      SAVE  /G2I/
      REAL        HONS,HOEW
      COMMON/G2O/ HONS(NMAX*3),HOEW(NMAX*3)
      SAVE  /G2O/
C
      INTEGER I
C
      DO I= 1,3*N
        HINS(I) = HOEW(I)
      ENDDO
C
      IF     (MOD(NPES1,2).EQ.0) THEN
        CALL MPI_SEND(
     +          HINS(  1),  N,MPI_REAL,MYPES, 9901,
     +          MPI_COMM_WORLD, MPIERR)
        CALL MPI_RECV(
     +          HONS(  1),  N,MPI_REAL,MYPEN, 9901,
     +          MPI_COMM_WORLD, MPIERR)
        CALL MPI_SEND(
     +          HINS(N+1),2*N,MPI_REAL,MYPEN, 9902,
     +          MPI_COMM_WORLD, MPIERR)
        CALL MPI_RECV(
     +          HONS(N+1),2*N,MPI_REAL,MYPES, 9902,
     +          MPI_COMM_WORLD, MPIERR)
      ELSE
        CALL MPI_RECV(
     +          HONS(  1),  N,MPI_REAL,MYPEN, 9901,
     +          MPI_COMM_WORLD, MPIERR)
        CALL MPI_SEND(
     +          HINS(  1),  N,MPI_REAL,MYPES, 9901,
     +          MPI_COMM_WORLD, MPIERR)
        CALL MPI_RECV(
     +          HONS(N+1),2*N,MPI_REAL,MYPES, 9902,
     +          MPI_COMM_WORLD, MPIERR)
        CALL MPI_SEND(
     +          HINS(N+1),2*N,MPI_REAL,MYPEN, 9902,
     +          MPI_COMM_WORLD, MPIERR)
      ENDIF
C
      DO I= 1,3*N
        HIEW(I) = HONS(I)
      ENDDO
C
      IF     (MOD(NPES2,2).EQ.0) THEN
        CALL MPI_SEND(
     +          HIEW(  1),  N,MPI_REAL,MYPEW, 9903,
     +          MPI_COMM_WORLD, MPIERR)
        CALL MPI_RECV(
     +          HOEW(  1),  N,MPI_REAL,MYPEE, 9903,
     +          MPI_COMM_WORLD, MPIERR)
        CALL MPI_SEND(
     +          HIEW(N+1),2*N,MPI_REAL,MYPEE, 9904,
     +          MPI_COMM_WORLD, MPIERR)
        CALL MPI_RECV(
     +          HOEW(N+1),2*N,MPI_REAL,MYPEW, 9904,
     +          MPI_COMM_WORLD, MPIERR)
      ELSE
        CALL MPI_RECV(
     +          HOEW(  1),  N,MPI_REAL,MYPEE, 9903,
     +          MPI_COMM_WORLD, MPIERR)
        CALL MPI_SEND(
     +          HIEW(  1),  N,MPI_REAL,MYPEW, 9903,
     +          MPI_COMM_WORLD, MPIERR)
        CALL MPI_RECV(
     +          HOEW(N+1),2*N,MPI_REAL,MYPEW, 9904,
     +          MPI_COMM_WORLD, MPIERR)
        CALL MPI_SEND(
     +          HIEW(N+1),2*N,MPI_REAL,MYPEE, 9904,
     +          MPI_COMM_WORLD, MPIERR)
      ENDIF
      RETURN
C     END OF HALO2B.
      END
      SUBROUTINE HALO2D(N)
      IMPLICIT NONE
      INTEGER N
C
C     SIMULATE A HALO TRANSFER
C
C     EXCHANGE N WORDS SOUTH AND 2N WORDS NORTH
C     ONCE THEY HAVE ARRIVED
C     EXCHANGE N WORDS WEST  AND 2N WORDS EAST
C
C     THIS VERSION USES ISEND THEN IRECV.
C
      INCLUDE 'mpif.h'
C
      INTEGER        MPIERR,MPIREQ,MPISTAT
      COMMON/XCMPII/ MPIERR,MPIREQ(4),
     +               MPISTAT(MPI_STATUS_SIZE,4)
C
      INTEGER    NMAX
      PARAMETER (NMAX=1024)
C
      INTEGER     MYPE,NPES1,NPES2,MYPEN,MYPES,MYPEE,MYPEW
      COMMON/G2D/ MYPE,NPES1,NPES2,MYPEN,MYPES,MYPEE,MYPEW
      SAVE  /G2D/
C
      REAL        HINS,HIEW
      COMMON/G2I/ HINS(NMAX*3),HIEW(NMAX*3)
      SAVE  /G2I/
      REAL        HONS,HOEW
      COMMON/G2O/ HONS(NMAX*3),HOEW(NMAX*3)
      SAVE  /G2O/
C
      INTEGER I
C
      DO I= 1,3*N
        HINS(I) = HOEW(I)
      ENDDO
C
      CALL MPI_ISEND(
     +        HINS(  1),  N,MPI_REAL,MYPES, 9901,
     +        MPI_COMM_WORLD, MPIREQ(1), MPIERR)
      CALL MPI_ISEND(
     +        HINS(N+1),2*N,MPI_REAL,MYPEN, 9902,
     +        MPI_COMM_WORLD, MPIREQ(2), MPIERR)
      CALL MPI_IRECV(
     +        HONS(  1),  N,MPI_REAL,MYPEN, 9901,
     +        MPI_COMM_WORLD, MPIREQ(3), MPIERR)
      CALL MPI_IRECV(
     +        HONS(N+1),2*N,MPI_REAL,MYPES, 9902,
     +        MPI_COMM_WORLD, MPIREQ(4), MPIERR)
      CALL MPI_WAITALL(4, MPIREQ, MPISTAT, MPIERR)
C
      DO I= 1,3*N
        HIEW(I) = HONS(I)
      ENDDO
C
      CALL MPI_ISEND(
     +        HIEW(  1),  N,MPI_REAL,MYPEW, 9903,
     +        MPI_COMM_WORLD, MPIREQ(1), MPIERR)
      CALL MPI_ISEND(
     +        HIEW(N+1),2*N,MPI_REAL,MYPEE, 9904,
     +        MPI_COMM_WORLD, MPIREQ(2), MPIERR)
      CALL MPI_IRECV(
     +        HOEW(  1),  N,MPI_REAL,MYPEE, 9903,
     +        MPI_COMM_WORLD, MPIREQ(3), MPIERR)
      CALL MPI_IRECV(
     +        HOEW(N+1),2*N,MPI_REAL,MYPEW, 9904,
     +        MPI_COMM_WORLD, MPIREQ(4), MPIERR)
      CALL MPI_WAITALL(4, MPIREQ, MPISTAT, MPIERR)
      RETURN
C     END OF HALO2D.
      END
      SUBROUTINE HALO2P(N)
      IMPLICIT NONE
      INTEGER N
C
C     SIMULATE A HALO TRANSFER
C
C     EXCHANGE N WORDS SOUTH AND 2N WORDS NORTH
C     ONCE THEY HAVE ARRIVED
C     EXCHANGE N WORDS WEST  AND 2N WORDS EAST
C
C     THIS VERSION USES ISEND THEN IRECV,
C     AND ESTABLISHES PERSISTENT REQUESTS.
C
      INCLUDE 'mpif.h'
C
      INTEGER        MPIERR,MPIREQ,MPISTAT
      COMMON/XCMPII/ MPIERR,MPIREQ(4),
     +               MPISTAT(MPI_STATUS_SIZE,4)
C
      INTEGER    NMAX
      PARAMETER (NMAX=1024)
C
      INTEGER     MYPE,NPES1,NPES2,MYPEN,MYPES,MYPEE,MYPEW
      COMMON/G2D/ MYPE,NPES1,NPES2,MYPEN,MYPES,MYPEE,MYPEW
      SAVE  /G2D/
C
      REAL        HINS,HIEW
      COMMON/G2I/ HINS(NMAX*3),HIEW(NMAX*3)
      SAVE  /G2I/
      REAL        HONS,HOEW
      COMMON/G2O/ HONS(NMAX*3),HOEW(NMAX*3)
      SAVE  /G2O/
C
      INTEGER MPIREQA(4),MPIREQB(4),NSAVE
      SAVE    MPIREQA,MPIREQB,NSAVE
C
      INTEGER I
C
      DATA NSAVE / 0 /
C
      DO I= 1,3*N
        HINS(I) = HOEW(I)
      ENDDO
C
      IF     (N.NE.NSAVE) THEN
        CALL MPI_SEND_INIT(
     +          HINS(  1),  N,MPI_REAL,MYPES, 9901,
     +          MPI_COMM_WORLD, MPIREQA(1), MPIERR)
        CALL MPI_SEND_INIT(
     +          HINS(N+1),2*N,MPI_REAL,MYPEN, 9902,
     +          MPI_COMM_WORLD, MPIREQA(2), MPIERR)
        CALL MPI_RECV_INIT(
     +          HONS(  1),  N,MPI_REAL,MYPEN, 9901,
     +          MPI_COMM_WORLD, MPIREQA(3), MPIERR)
        CALL MPI_RECV_INIT(
     +          HONS(N+1),2*N,MPI_REAL,MYPES, 9902,
     +          MPI_COMM_WORLD, MPIREQA(4), MPIERR)
      ENDIF
      CALL MPI_STARTALL(4, MPIREQA,          MPIERR)
      CALL MPI_WAITALL( 4, MPIREQA, MPISTAT, MPIERR)
C
      DO I= 1,3*N
        HIEW(I) = HONS(I)
      ENDDO
C
      IF     (N.NE.NSAVE) THEN
        NSAVE = N
        CALL MPI_SEND_INIT(
     +          HIEW(  1),  N,MPI_REAL,MYPEW, 9903,
     +          MPI_COMM_WORLD, MPIREQB(1), MPIERR)
        CALL MPI_SEND_INIT(
     +          HIEW(N+1),2*N,MPI_REAL,MYPEE, 9904,
     +          MPI_COMM_WORLD, MPIREQB(2), MPIERR)
        CALL MPI_RECV_INIT(
     +          HOEW(  1),  N,MPI_REAL,MYPEE, 9903,
     +          MPI_COMM_WORLD, MPIREQB(3), MPIERR)
        CALL MPI_RECV_INIT(
     +          HOEW(N+1),2*N,MPI_REAL,MYPEW, 9904,
     +          MPI_COMM_WORLD, MPIREQB(4), MPIERR)
      ENDIF
      CALL MPI_STARTALL(4, MPIREQB,          MPIERR)
      CALL MPI_WAITALL( 4, MPIREQB, MPISTAT, MPIERR)
      RETURN
C     END OF HALO2P.
      END
      SUBROUTINE HALO2E(N)
      IMPLICIT NONE
      INTEGER N
C
C     SIMULATE A HALO TRANSFER
C
C     EXCHANGE N WORDS SOUTH AND 2N WORDS NORTH
C     ONCE THEY HAVE ARRIVED
C     EXCHANGE N WORDS WEST  AND 2N WORDS EAST
C
C     THIS VERSION USES IRECV THEN ISEND.
C
      INCLUDE 'mpif.h'
C
      INTEGER        MPIERR,MPIREQ,MPISTAT
      COMMON/XCMPII/ MPIERR,MPIREQ(4),
     +               MPISTAT(MPI_STATUS_SIZE,4)
C
      INTEGER    NMAX
      PARAMETER (NMAX=1024)
C
      INTEGER     MYPE,NPES1,NPES2,MYPEN,MYPES,MYPEE,MYPEW
      COMMON/G2D/ MYPE,NPES1,NPES2,MYPEN,MYPES,MYPEE,MYPEW
      SAVE  /G2D/
C
      REAL        HINS,HIEW
      COMMON/G2I/ HINS(NMAX*3),HIEW(NMAX*3)
      SAVE  /G2I/
      REAL        HONS,HOEW
      COMMON/G2O/ HONS(NMAX*3),HOEW(NMAX*3)
      SAVE  /G2O/
C
      INTEGER I
C
      DO I= 1,3*N
        HINS(I) = HOEW(I)
      ENDDO
C
      CALL MPI_IRECV(
     +        HONS(  1),  N,MPI_REAL,MYPEN, 9901,
     +        MPI_COMM_WORLD, MPIREQ(1), MPIERR)
      CALL MPI_IRECV(
     +        HONS(N+1),2*N,MPI_REAL,MYPES, 9902,
     +        MPI_COMM_WORLD, MPIREQ(2), MPIERR)
      CALL MPI_ISEND(
     +        HINS(  1),  N,MPI_REAL,MYPES, 9901,
     +        MPI_COMM_WORLD, MPIREQ(3), MPIERR)
      CALL MPI_ISEND(
     +        HINS(N+1),2*N,MPI_REAL,MYPEN, 9902,
     +        MPI_COMM_WORLD, MPIREQ(4), MPIERR)
      CALL MPI_WAITALL(4, MPIREQ, MPISTAT, MPIERR)
C
      DO I= 1,3*N
        HIEW(I) = HONS(I)
      ENDDO
C
      CALL MPI_IRECV(
     +        HOEW(  1),  N,MPI_REAL,MYPEE, 9903,
     +        MPI_COMM_WORLD, MPIREQ(1), MPIERR)
      CALL MPI_IRECV(
     +        HOEW(N+1),2*N,MPI_REAL,MYPEW, 9904,
     +        MPI_COMM_WORLD, MPIREQ(2), MPIERR)
      CALL MPI_ISEND(
     +        HIEW(N+1),2*N,MPI_REAL,MYPEE, 9904,
     +        MPI_COMM_WORLD, MPIREQ(3), MPIERR)
      CALL MPI_ISEND(
     +        HIEW(  1),  N,MPI_REAL,MYPEW, 9903,
     +        MPI_COMM_WORLD, MPIREQ(4), MPIERR)
      CALL MPI_WAITALL(4, MPIREQ, MPISTAT, MPIERR)
      RETURN
C     END OF HALO2E.
      END
      SUBROUTINE HALO2Q(N)
      IMPLICIT NONE
      INTEGER N
C
C     SIMULATE A HALO TRANSFER
C
C     EXCHANGE N WORDS SOUTH AND 2N WORDS NORTH
C     ONCE THEY HAVE ARRIVED
C     EXCHANGE N WORDS WEST  AND 2N WORDS EAST
C
C     THIS VERSION USES IRECV THEN ISEND,
C     AND ESTABLISHES PERSISTENT REQUESTS.
C
      INCLUDE 'mpif.h'
C
      INTEGER        MPIERR,MPIREQ,MPISTAT
      COMMON/XCMPII/ MPIERR,MPIREQ(4),
     +               MPISTAT(MPI_STATUS_SIZE,4)
C
      INTEGER    NMAX
      PARAMETER (NMAX=1024)
C
      INTEGER     MYPE,NPES1,NPES2,MYPEN,MYPES,MYPEE,MYPEW
      COMMON/G2D/ MYPE,NPES1,NPES2,MYPEN,MYPES,MYPEE,MYPEW
      SAVE  /G2D/
C
      REAL        HINS,HIEW
      COMMON/G2I/ HINS(NMAX*3),HIEW(NMAX*3)
      SAVE  /G2I/
      REAL        HONS,HOEW
      COMMON/G2O/ HONS(NMAX*3),HOEW(NMAX*3)
      SAVE  /G2O/
C
      INTEGER MPIREQA(4),MPIREQB(4),NSAVE
      SAVE    MPIREQA,MPIREQB,NSAVE
C
      INTEGER I
C
      DATA NSAVE / 0 /
C
      DO I= 1,3*N
        HINS(I) = HOEW(I)
      ENDDO
C
      IF     (N.NE.NSAVE) THEN
        CALL MPI_RECV_INIT(
     +          HONS(  1),  N,MPI_REAL,MYPEN, 9901,
     +          MPI_COMM_WORLD, MPIREQA(1), MPIERR)
        CALL MPI_RECV_INIT(
     +          HONS(N+1),2*N,MPI_REAL,MYPES, 9902,
     +          MPI_COMM_WORLD, MPIREQA(2), MPIERR)
        CALL MPI_SEND_INIT(
     +          HINS(  1),  N,MPI_REAL,MYPES, 9901,
     +          MPI_COMM_WORLD, MPIREQA(3), MPIERR)
        CALL MPI_SEND_INIT(
     +          HINS(N+1),2*N,MPI_REAL,MYPEN, 9902,
     +          MPI_COMM_WORLD, MPIREQA(4), MPIERR)
      ENDIF
      CALL MPI_STARTALL(4, MPIREQA,          MPIERR)
      CALL MPI_WAITALL( 4, MPIREQA, MPISTAT, MPIERR)
C
      DO I= 1,3*N
        HIEW(I) = HONS(I)
      ENDDO
C
      IF     (N.NE.NSAVE) THEN
        NSAVE = N
        CALL MPI_RECV_INIT(
     +          HOEW(  1),  N,MPI_REAL,MYPEE, 9903,
     +          MPI_COMM_WORLD, MPIREQB(1), MPIERR)
        CALL MPI_RECV_INIT(
     +          HOEW(N+1),2*N,MPI_REAL,MYPEW, 9904,
     +          MPI_COMM_WORLD, MPIREQB(2), MPIERR)
        CALL MPI_SEND_INIT(
     +          HIEW(  1),  N,MPI_REAL,MYPEW, 9903,
     +          MPI_COMM_WORLD, MPIREQB(3), MPIERR)
        CALL MPI_SEND_INIT(
     +          HIEW(N+1),2*N,MPI_REAL,MYPEE, 9904,
     +          MPI_COMM_WORLD, MPIREQB(4), MPIERR)
      ENDIF
      CALL MPI_STARTALL(4, MPIREQB,          MPIERR)
      CALL MPI_WAITALL( 4, MPIREQB, MPISTAT, MPIERR)
      RETURN
C     END OF HALO2Q.
      END