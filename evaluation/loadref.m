function imRef = loadref(dataID)

% This code is to load a sample data
% Input:
% dataID:       ID of the selected sample
% Output:
% imRef:        metal-free image (1/cm)

load(['sample_', num2str(dataID), '.mat'])
imRef = imData.imRef;