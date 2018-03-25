function imMAR = prior2corr(proj, imPrior, metalTrace)

% This code is to obtain the corrected images from the prior image
% Input:
% proj:         uncorrected projection
% imPrior:      prior image (1/cm)
% metalTrace:   metal trace in projection domain (binary image)
% Output:
% imMAR:        corrected image


CTpara = CTscanpara();      

% projection of the prior image
projPrior = fanbeam(imPrior,CTpara.SOD,...
    'FanSensorGeometry','arc',...
    'FanSensorSpacing', CTpara.angsize, ...
    'FanRotationIncrement',360/CTpara.AngNum);
projPrior = projPrior*CTpara.imPixScale;

% keep continuity at boundaries of metal trace
pDiff = projInterp(proj-projPrior, metalTrace);
projMAR = pDiff + projPrior;

projMAR(metalTrace==0) = proj(metalTrace==0);

% reconstruction
imMAR = ifanbeam(projMAR,CTpara.SOD,...
    'FanSensorGeometry','arc',...
    'FanSensorSpacing',CTpara.angsize,...
    'OutputSize',CTpara.imPixNum,... 
    'FanRotationIncrement',360/CTpara.AngNum);
imMAR = imMAR/CTpara.imPixScale;

