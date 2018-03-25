function imInput = dataInput(imRaw, imBHC, imLI, metalBW, miuWater)

% This code is to prepare the input images for the network
% Input:
% imRaw:        uncorrected projection (1/cm)
% imBHC:        beam hardening corrected image (1/cm)
% imLI:         linear interpolation corrected image (1/cm)
% metalBW:      binary metal image
% miuWater:     linear attenuation coefficient of water (1/cm)
% Output:
% imInput:      prepared input images

SE = [0 1 0; 1 1 1; 0 1 0];
metalBW = imdilate(metalBW,SE); % enlarge metal region
imtemp1 = imRaw;
imtemp1(metalBW) = miuWater;
imtemp2 = imBHC;
imtemp2(metalBW) = miuWater;
imtemp3 = imLI;
imtemp3(metalBW) = miuWater;

imInput = [];
imInput(:,:,1) = imtemp1;
imInput(:,:,2) = imtemp2;
imInput(:,:,3) = imtemp3;
imInput(imInput<0) = 0;
imInput = single(imInput);  % the network only processes single format data

