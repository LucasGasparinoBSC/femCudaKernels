#ifndef FEMKERN_HPP
#define FEMKERN_HPP

#include <cuda.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>


// Define a  namespace for the FEM kernels
namespace fem_kern
{
    __global__ void convective(int nPt, int* connec, float* f, float* R);
}

#endif //! FEMKERN_HPP