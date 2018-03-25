function rmse_All = rmseAll(imRef, imAll, metalBW, ROIx, ROIy)

% This code is to compute the roor mean squred errors (RMSEs) for all images
% in the given ROI
% Input:
% imRef:        reference image (1/cm)
% imAll.im:     a stack of images
% imAll.name:   names of all the images
% metalBW:      binary metal image
% ROIx:         x positions of the ROI
% ROIy:         y positions of the ROI
% Output:
% rmse_All:     RMSEs for all images in the given ROI (1/cm)

numIm = numel(imAll.name);
rmse_All = zeros(numIm, 1);

% only compute the ROI without metal
temp = imRef;
temp(metalBW) = 0;
imRefROI = temp(ROIx, ROIy);
pixSum = sum(sum(1-metalBW(ROIx, ROIy)));

for i = 1:numIm
    temp = imAll.im{i};
    temp(metalBW) = 0;
    tempROI = temp(ROIx, ROIy);
    rmse_All(i) = sqrt(sum((tempROI(:) - imRefROI(:)).^2)/pixSum);
end
