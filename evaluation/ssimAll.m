function ssim_All = ssimAll(imRef, imAll, metalBW, ROIx, ROIy)

% This code is to compute the SSIM indices for all images in the given ROI
% We downloaded the ssim code from: http://www.cns.nyu.edu/~lcv/ssim/ssim_index.m
% Input:
% imRef:        reference image (1/cm)
% imAll.im:     a stack of images
% imAll.name:   names of all the images
% metalBW:      binary metal image
% ROIx:         x positions of the ROI
% ROIy:         y positions of the ROI
% Output:
% ssim_All:     SSIM values for all images in the given ROI (1/cm)

maxVal = 255;
maxRef = max(imRef(:));
numIm = numel(imAll.name);
ssim_All = zeros(numIm, 1);

% only compute the ROI without metal
temp = imRef;
temp(metalBW) = 0;

% map the image value range to [0 255]
imRefROI = imscale(temp(ROIx, ROIy), maxRef, maxVal);

for i = 1:numIm
    temp = imAll.im{i};
    temp(metalBW) = 0;
    tempROI = imscale(temp(ROIx, ROIy), maxRef, maxVal);
    ssim_All(i) = ssim(imRefROI, tempROI);
end


end

%% mapping the value range to [0 maxVal] 

function im = imscale(im0, maxRef, maxVal)

im = im0/maxRef*maxVal;
im(im<0) = 0;
im(im>maxVal) = maxVal;

end

