function setupCNN(varargin)
%SETUPCNN()  Initialize the practical
%   SETUPCNN() initializes the practical. SETUPCNN('useGpu', true) does
%   the same, but compiles the GPU supprot as well.

run('vl_setupnn');

opts.useGpu = false ;
opts.verbose = false ;
opts = vl_argparse(opts, varargin) ;


try
  vl_nnconv(single(1),single(1),[]) ;
catch
  warning('VL_NNCONV() does not seem to be compiled. Trying to compile it now.') ;
  vl_compilenn('enableGpu', opts.useGpu, 'verbose', opts.verbose, ...
               'enableImreadJpeg', false) ;
end

if opts.useGpu
  try
    vl_nnconv(gpuArray(single(1)),gpuArray(single(1)),[]) ;
  catch
    warning('GPU support does not seem to be compiled in MatConvNet. Trying to compile it now.') ;
    vl_compilenn('enableGpu', opts.useGpu, 'verbose', opts.verbose, ...
                 'enableImreadJpeg', false) ;
  end
end

if verLessThan('matlab','7.12')
  % MATLAB R2010b did not have rng()
  randn('state',0) ;
  rand('state',0) ;
else
  rng(0)  ;
end

% The EC2 has incorrect screen size which
% leads to a tiny font in figures

[~, hostname] = system('hostname') ;
if strcmp(hostname(1:3), 'ip-')
  set(0, 'DefaultAxesFontSize', 30) ;
end


