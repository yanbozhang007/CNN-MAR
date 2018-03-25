function showResults(imRaw, imAll, metalBW, ROIx, ROIy, dispWin)

% This code is to set ROI of the image
% Input:
% imRaw:        uncorrected image (1/cm)
% imAll.im:     a stack of images
% imAll.name:   names of all the images
% metalBW:      binary metal image
% ROIx:         x positions of the ROI
% ROIy:         y positions of the ROI
% dispWin:      display window


for i = 1:numel(imAll.name)
    figure,
    temp = imAll.im{i};
    temp(metalBW) = imRaw(metalBW);
    imshow(temp(ROIx, ROIy), dispWin)    
    title(imAll.name{i})
end
