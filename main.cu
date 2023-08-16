#include "femKern.cuh"
#include <cuda.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <iostream>

int main(int argc, char const *argv[])
{
    // Define data with only 2 elements
    int numElem = 2;
    int numNodes = 64;
    int numPts = numNodes * numElem;
    int* connec = new int[numElem * numNodes];
    for (int iElem = 0; iElem < numElem; iElem++)
    {
        for (int iNode = 0; iNode < numNodes; iNode++)
        {
            connec[iElem * numNodes + iNode] = iElem * numNodes + iNode;
        }
    }
    float* f = new float[3*numPts];
    std::cout << "f = " << std::endl;
    for (int iPt = 0; iPt < numPts; iPt++)
    {
        std::cout << "[ ";
        for (int iDim = 0; iDim < 3; iDim++)
        {
            f[iDim * numPts + iPt] = 10.0f*(iDim + iPt);
            std::cout << f[iDim * numPts + iPt] << " ";
        }
        std::cout << "]" << std::endl;
    }

    // Device data
    int* d_connec;
    float* d_f;
    float* d_R;
    cudaMalloc((void**)&d_connec, numElem * numNodes * sizeof(int));
    cudaMalloc((void**)&d_f, 3 * numPts * sizeof(float));
    cudaMalloc((void**)&d_R, numPts * sizeof(float));
    cudaMemcpy(d_connec, connec, numElem * numNodes * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_f, f, 3 * numPts * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemset(d_R, 0, numPts * sizeof(float));

    // Call the convective kernel
    fem_kern::convective<<<numElem,numNodes>>>(numPts, d_connec, d_f, d_R);
    return 0;
}