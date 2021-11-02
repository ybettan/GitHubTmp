#include <mpi.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>

int p_strcmp(char *str1, char *str2) {

    int numProc, rank;
    MPI_Comm_size(MPI_COMM_WORLD, &numProc);

    int chunkSize = strlen(str1) / numProc;
    int localRes, *resArr;

    if (rank == 0)
        resArr = malloc(numProc * sizeof(int));

    /* on all process stri will now point to the relevant part of original strs */
    MPI_Scatter(str1, chunkSize, MPI_CHAR, str1, chunkSize, MPI_CHAR, /*root*/0,
            MPI_COMM_WORLD);
    MPI_Scatter(str2, chunkSize, MPI_CHAR, str2, chunkSize, MPI_CHAR, /*root*/0,
            MPI_COMM_WORLD);

    str1[chunkSize] = '\0';
    str2[chunkSize] = '\0';
    localRes = strcmp(str1, str2);

    if (rank == 0) {
        MPI_Gather(&localRes, 1, MPI_INT, resArr, 1, MPI_INT, /*root*/0, MPI_COMM_WORLD);
        for (int i=0 ; i<numProc ; i++) {
            if (resArr[i] != 0)
                return resArr[i];
        }
    } else
        MPI_Gather(&localRes, 1, MPI_INT, NULL, 1, MPI_INT, /*root*/0, MPI_COMM_WORLD);

    return 0;
}


int main(int argc, char **argv) {

    //char *str1 = "123456789abcdefg";
    //char *str2 = "123456789abcdefg";

    MPI_Init(&argc, &argv);

    //assert(p_strcmp(str1, str2) == 0);
    printf("hello\n");

    MPI_Finalize();
}
