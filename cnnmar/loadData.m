function [proj, imRaw, metalBW, metalTrace] = loadData2(dataID)

% This code is to load a sample data
% Input:
% dataID:       ID of the selected sample
% Output:
% proj:         uncorrected projection
% imRaw:        uncorrected image (1/cm)
% metalBW:      metal image (binary image)
% metalTrace:   metal trace in projection domain (binary image)

load(['sample_', num2str(dataID), '.mat'])
proj = imData.proj;
imRaw = imData.imRaw;

% Here the metal is manually segmented
metalBW = imData.metalBW>0;

CTpara = CTscanpara();
projMetal = fanbeam(metalBW,CTpara.SOD,...
    'FanSensorGeometry','arc',...
    'FanSensorSpacing', CTpara.angsize, ...
    'FanRotationIncrement',360/CTpara.AngNum);

metalTrace = projMetal>0;
