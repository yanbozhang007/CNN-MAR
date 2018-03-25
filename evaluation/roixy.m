function [ROIx, ROIy] = roixy(im, dataID)

% This code is to set ROI of the image
% Input:
% im:           image
% dataID:       ID of the selected sample
% Output:
% ROIx:         x positions of the ROI
% ROIy:         y positions of the ROI

if dataID == 1
    % case 1: hip prostheses
    ROIx = 72:435;
    ROIy = 29:499;
    
elseif dataID == 2
    % case 2: coiling
    [sx, sy] = size(im);
    ROIx = 1:sx;
    ROIy = 1:sy;
    
elseif dataID == 3
    % case 3: dental fillings
    ROIx = 1:225;
    ROIy = 81:413;
    
else
    % for other data
    [sx, sy] = size(im);
    ROIx = 1:sx;
    ROIy = 1:sy;
    
end

