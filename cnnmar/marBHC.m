function imBHC = marBHC(proj, metalBW)

% This code is to reduce metal artifacts using a first order beam hardening
% correction method
% Input:
% proj:         uncorrected projection
% metalBW:      binary metal image
% Output:
% imBHC:        beam hardening corrected image (1/cm)


[bins, views] = size(proj);
CTpara = CTscanpara();      

% projection of metal
projMetal = fanbeam(double(metalBW),CTpara.SOD,...
    'FanSensorGeometry','arc',...
    'FanSensorSpacing', CTpara.angsize, ...
    'FanRotationIncrement',360/CTpara.AngNum);
projMetal = projMetal*CTpara.imPixScale;

% LI projection
Pinterp = projInterp(proj,projMetal>0);

projDiff = proj - Pinterp;
projDiff1 = reshape(projDiff, bins.*views, 1);
projMetal1 = reshape(projMetal, bins.*views, 1);   
projMetalbw1 = reshape(projMetal>0, bins.*views, 1); 

% first order beam hardening correction
A = zeros(bins.*views,3);
A(:,1) = projMetalbw1.*projMetal1;          % only consider projections affected by metal
A(:,2) = projMetalbw1.*projMetal1.^2;
A(:,3) = projMetalbw1.*projMetal1.^3;
X0 = A\(projMetalbw1.*projDiff1);           % coefficients of the polynomial

projFit1 = zeros(bins.*views,1);
for icoe = 1:size(A,2)
    projFit1 = projFit1 + X0(icoe)*A(:,icoe);
end

% difference between projections of piece-wise constant image and its hardened one
projDelta1 = projMetalbw1.*(X0(1)*projMetal1 - projFit1);
projBHC = proj + reshape(projDelta1, bins, views);   

% reconstruction
imBHC = ifanbeam(projBHC,CTpara.SOD,...
    'FanSensorGeometry','arc',...
    'FanSensorSpacing',CTpara.angsize,...
    'OutputSize',CTpara.imPixNum,... 
    'FanRotationIncrement',360/CTpara.AngNum);
imBHC = imBHC/CTpara.imPixScale;

