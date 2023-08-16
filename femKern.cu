#include "femKern.cuh"

namespace fem_kern
{
    __global__ void convective(int nPt, int* connec, float* f, float* R)
    {
        int iElem = blockIdx.x; // Each block is an element
        int iPt = threadIdx.x;  // Each thread is a point or Gauss point

        // Zero the residual R
        R[connec[iElem*64 + iPt]] = 0.0f;

        // Local shared memory
        __shared__ int connec_s[64]; // Local connectivity table
        __shared__ float f_s[192];   // 3D  local flux iPt + iDim * 64
        __shared__ float div_s[64];  // Local divergence

        // Extract the global index from the connectivity table
        connec_s[iPt] = connec[iElem * 64 + iPt];
        __syncthreads();

        // Fill local flux with gobal values
        for (int iDim = 0; iDim < 3; iDim++)
        {
            f_s[iPt + iDim * 64] = f[connec_s[iPt] + iDim * nPt];
        }
        __syncthreads();

        // Compute divergence at an element
        div_s[iPt] = 0.0f;
        for (int iDim = 0; iDim < 3; iDim++)
        {
            div_s[iPt] += f_s[iPt + iDim * 64]; //! Miissinng operators, to be added later from paramms
        }
        __syncthreads();

        // Add divergence to the residual
        atomicAdd(&R[connec_s[iPt]], div_s[iPt]);
    }
}