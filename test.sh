#!/bin/sh

# Sequential test.
echo "Sequential code:"
time python3 sequential_julia_set.py -0.4 0.6
echo
mv Julia.tiff Sequential.tiff

# Multiprocessing test.
echo "Multiprocessing code:"
time python3 multiprocessing_julia_set.py -0.4 0.6
echo
mv Julia.tiff Multiprocessing.tiff

# GPU test.
echo "GPU code:"
export PYOPENCL_CTX=0 # Just go with the first available context.
time python3 gpu_julia_set.py -0.4 0.6
echo
mv Julia.tiff GPU.tiff
