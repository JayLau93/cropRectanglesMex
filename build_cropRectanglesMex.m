function build_cropRectanglesMex( cudaRoot )
%build_cropRectanglesMex builds package cropResizeMex
%
% INPUT:
%   cudaRoot - path to the CUDA installation

% Anton Osokin, firstname.lastname@gmail.com, March 2015

if ~exist('cudaRoot', 'var')
    cudaRoot = '/usr/cuda-6.5' ;
end
nvccPath = fullfile(cudaRoot, 'bin', 'nvcc');
if ~exist(nvccPath, 'file')
    error('NVCC compiler was not found!');
end

root = fileparts( mfilename('fullpath') );

% compiling
compileCmd = [ '"', nvccPath, '"', ...
        ' -c cropRectanglesMex.cu', ... 
        ' -DNDEBUG -DENABLE_GPU', ...
        ' -I"', fullfile( matlabroot, 'extern', 'include'), '"', ...
        ' -I"', fullfile( matlabroot, 'toolbox', 'distcomp', 'gpu', 'extern', 'include'), '"', ...
        ' -I"', fullfile( cudaRoot, 'include'), '"', ...
        ' -I"', fullfile( cudaRoot, 'samples', '7_CUDALibraries', 'common', 'UtilNPP'), '"', ...
        ' -I"', fullfile( cudaRoot, 'samples', 'common', 'inc'), '"', ...
        ' -Xcompiler', ' -fPIC', ...
        ' -o "', fullfile(root,'cropRectanglesMex.o'), '"'];
system( compileCmd );

% linking
mopts = {'-outdir', root, ...
         '-output', 'cropRectanglesMex', ...
         ['-L', fullfile(cudaRoot, 'lib64')], ...
         '-lcudart', '-lnppi', '-lnppc', '-lmwgpu', ...
         fullfile(root,'cropRectanglesMex.o') };
mex(mopts{:}) ;

delete( fullfile(root,'cropRectanglesMex.o') );