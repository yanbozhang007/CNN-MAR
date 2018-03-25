function [imNMAR1, imNMAR2]= nmar(proj, imRaw, imLI, metalTrace, metalBW, miuWater)

% This code is to reproduce normalized metal artifact reduction (NMAR) method
% using prior images generated from uncorrected and LI corrected images, respectively.
%
% Meyer, Esther, et al. "Normalized metal artifact reduction (NMAR) in computed 
% tomography." Medical physics 37.10 (2010): 5482-5493.
%
% Input:
% proj:         uncorrected projection
% imRaw:        uncorrected image (1/cm)
% imLI:         linear interpolation corrected image (1/cm)
% metalTrace:   metal trace in projection domain (binary image)
% metalBW:      binary metal image
% miuWater:     linear attenuation coefficient of water (1/cm)
% Output:
% imNMAR1:      NMAR corrected image using the prior from uncorrected image (1/cm)
% imNMAR2:      NMAR corrected image using the prior from LI image (1/cm)


miuAir = 0;
CTpara = CTscanpara();      
smFilter = fspecial('gaussian',[5 5],1);

%% NMAR method 1: Raw

imRaw(metalBW) = miuWater;  % metal
im1d = reshape(imRaw, numel(imRaw), 1);
[reconidx,~] = kmeans(im1d, 3, 'Replicates', 5, 'replicates', 1, 'start', [miuAir; miuWater; 2*miuWater]);% [miuAir; miuWater; 2*miuWater] is the center of each class
threshBone1 = min(im1d(reconidx==3));
threshBone1 = max([threshBone1, 1.2*miuWater]); % not smaller than 200 HU
threshWater1 = min(im1d(reconidx==2));
imPriorNMAR1 = nmarPrior(imRaw,threshWater1,threshBone1,miuAir,miuWater,smFilter);

projPrior1 = fanbeam(imPriorNMAR1,CTpara.SOD,...
    'FanSensorGeometry','arc',...
    'FanSensorSpacing', CTpara.angsize, ...
    'FanRotationIncrement',360/CTpara.AngNum);
projPrior1 = projPrior1*CTpara.imPixScale;
PNMAR1 = nmar_proj(proj, projPrior1, metalTrace);

imNMAR1 = ifanbeam(PNMAR1,CTpara.SOD,...
    'FanSensorGeometry','arc',...
    'FanSensorSpacing',CTpara.angsize,...
    'OutputSize',CTpara.imPixNum,... 
    'FanRotationIncrement',360/CTpara.AngNum);
imNMAR1 = imNMAR1/CTpara.imPixScale;


%% NMAR method 2: LI

imLI(metalBW) = miuWater;
im1d = reshape(imLI, numel(imLI), 1);
[reconidx,~] = kmeans(im1d, 3, 'Replicates', 5, 'replicates', 1, 'start', [miuAir; miuWater; 2*miuWater]);
threshBone2 = min(im1d(reconidx==3));
threshBone2 = max([threshBone2, 1.2*miuWater]);
threshWater2 = min(im1d(reconidx==2));
imPriorNMAR2 = nmarPrior(imLI,threshWater2,threshBone2,miuAir,miuWater,smFilter);

projPrior2 = fanbeam(imPriorNMAR2,CTpara.SOD,...
    'FanSensorGeometry','arc',...
    'FanSensorSpacing', CTpara.angsize, ...
    'FanRotationIncrement',360/CTpara.AngNum);
projPrior2 = projPrior2*CTpara.imPixScale;
PNMAR2 = nmar_proj(proj, projPrior2, metalTrace);

imNMAR2 = ifanbeam(PNMAR2,CTpara.SOD,...
    'FanSensorGeometry','arc',...
    'FanSensorSpacing',CTpara.angsize,...
    'OutputSize',CTpara.imPixNum,... 
    'FanRotationIncrement',360/CTpara.AngNum);
imNMAR2 = imNMAR2/CTpara.imPixScale;

end

%% generate a prior image

function priorimgHU = nmarPrior(im,threshWater,threshBone,miuAir,miuWater,smFilter)

imSm = imfilter(im,smFilter,'replicate');
priorimgHU = imSm;
priorimgHU(imSm<=threshWater) = miuAir;
priorimgHU(intersect(find(imSm>threshWater),find(imSm<threshBone))) = miuWater;

end

%% normalized interpolation in projection domain

function Pnmar = nmar_proj(proj,Pprior,metalTrace)
 
Pprior(Pprior<0) = 0;
eps = 10^(-6);
Pprior = Pprior + eps;
Pnorm = proj./Pprior;

Pnorminterp = projInterp(Pnorm,metalTrace);
Pnmar = Pnorminterp.*Pprior;
nonmetalpos = find(metalTrace == 0);
Pnmar(nonmetalpos) = proj(nonmetalpos);

end

