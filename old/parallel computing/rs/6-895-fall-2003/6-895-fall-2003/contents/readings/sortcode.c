#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <unistd.h>
#include <string.h>

/* Insertion sort */
void isort (int *x, int n) {
    int i,j;
    for (i=1; i<n; i++) {
	int nv=x[i];
	/* everything before x[i] is sorted. */
	for (j=0; j<i; j++) {
	    int xj=x[j];
	    if (xj>nv) {
		x[j]=nv;
		nv=xj;
	    }
	}
	x[j]=nv;
    }
}

/* A special case sorting function that sorts 5 values.
 * Load the values into variables, swap them around, and store them out */
void sort5 (int *x) {
    #define MSWAP(x,y) if (x>y) { tmp=x; x=y; y=tmp; }
    int a0=x[0];
    int a1=x[1];
    int a2=x[2];
    int a3=x[3];
    int a4=x[4];
    int tmp;
    /* This is a minimal sorting network for five values. */
    MSWAP(a1,a2);
    MSWAP(a3,a4);
    MSWAP(a1,a3);
    MSWAP(a0,a2);
    MSWAP(a2,a4);
    MSWAP(a0,a3);
    MSWAP(a0,a1);
    MSWAP(a2,a3);
    MSWAP(a1,a2);
    //assert((a0<a1) && (a1<a2) && (a2<a3) && (a3<a4));
    x[0]=a0;
    x[1]=a1;
    x[2]=a2;
    x[3]=a3;
    x[4]=a4;
}

/* The rest of this file constructs random data, and runs sorts many
 * times, and measures the time */

double rdiff (struct rusage *rstart, struct rusage *rend) {
    return rend->ru_utime.tv_sec - rstart->ru_utime.tv_sec
	+ (rend->ru_utime.tv_usec-rstart->ru_utime.tv_usec)*1e-6;
}

enum { N = 5, DR=100, TRIALS=10000000 };
int main (int argc, char *argv[]) {
    struct rusage rstart, rend;
    int V[DR*N], X[N];
    int i;
    int off=0;
    double callibrate;
    int two;
    assert(argc==1);
    for (i=0; i<DR*N; i++) V[i]=random();
    // Do the callibration twice
    for (two=0; two<2; two++) {
	getrusage(RUSAGE_SELF, &rstart);
	for (i=0; i<TRIALS; i++) {
	    memcpy(X, V+off, sizeof(int)*N);
	    off+=N; if (off>=DR*N) off=0;
	}
	getrusage(RUSAGE_SELF, &rend);
    }
    callibrate=rdiff(&rstart, &rend);

    for (two=0; two<2; two++) {
	getrusage(RUSAGE_SELF, &rstart);
	for (i=0; i<TRIALS; i++) {
	    memcpy(X, V+off, sizeof(int)*N);
	    off+=N; if (off>=DR*N) off=0;
	    isort(X,N);
	}
	getrusage(RUSAGE_SELF, &rend);
    }
    printf("%s isort(%d) time %f\n", argv[0], N, rdiff(&rstart, &rend)-callibrate);

    assert(N==5);
    for (two=0; two<2; two++) {
	getrusage(RUSAGE_SELF, &rstart);
	for (i=0; i<TRIALS; i++) {
	    memcpy(X, V+off, sizeof(int)*N);
	    off+=N; if (off>=DR*N) off=0;
	    sort5(X);
	}
	getrusage(RUSAGE_SELF, &rend);
    }
    printf("%s sort5 time %f\n", argv[0], rdiff(&rstart, &rend)-callibrate);

    return 0;
}
