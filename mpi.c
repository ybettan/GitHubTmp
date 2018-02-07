#include <mpi.h>

#define N 10


int p_strcmp(const char *str1, const char *str2) {

    int numProc, rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &numProc);

    int chunkSize = (N-1) / (numProc-1);
    int localRes, *resArr;

    if (rank == 0)
        resArr = malloc(numProc * sizeof(int));

    /* on all process stri will now point to the relevant part of original strs */
    MPI_Scatter(str1, MPI_CHAR, chunkSize, str1, MPI_CHAR, chunkSize, /*root*/0,
            MPI_COMM_WORLD);
    MPI_Scatter(str2, MPI_CHAR, chunkSize, str2, MPI_CHAR, chunkSize, /*root*/0,
            MPI_COMM_WORLD);

    str1[chunkSize] = '\0';
    str2[chunkSize] = '\0';
    localRes = str_cmp(str1, str2);

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
