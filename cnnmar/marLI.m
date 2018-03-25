function imLI = marLI(proj, metalTrace)

% This code is to reduce metal artifacts using linear interpolation
% Input:
% proj:         uncorrected projection
% metalTrace:   metal trace in projection domain (binary image)
% Output:
% imLI:         linear interpolation corrected image (1/cm)

Pinterp = projInterp(proj,metalTrace);

CTpara = CTscanpara();        
imLI = ifanbeam(Pinterp,CTpara.SOD,...
    'FanSensorGeometry','arc',...
    'FanSensorSpacing',CTpara.angsize,...
    'OutputSize',CTpara.imPixNum,... 
    'FanRotationIncrement',360/CTpara.AngNum);
imLI = imLI/CTpara.imPixScale;

