function imPrior = cnnPrior(imCNN, metalBW, miuWater)
% This code is to generate a prior image from the CNN processed image
% Input:
% imCNN:        CNN corrected image (1/cm)
% metalBW:      binary metal image
% miuWater:     linear attenuation coefficient of water (1/cm)
% Output:
% imPrior:      CNN prior image (1/cm)


%% determine the thresholds for segmentation

imCNN(metalBW) = miuWater;
reconsize = size(imCNN, 1);
imCNNHU = (imCNN - miuWater)/miuWater*1000;

imCNNHU1 = reshape(imCNNHU,reconsize^2,1);
[reconidx,~] = kmeans(imCNNHU1,3,'Replicates',5,'replicates',1,'start',[-900;0;1000]);% [-900;0;1000] are initial centers of clusters

threshBoneHighHU = min(imCNNHU1(reconidx==3));
threshBoneHighHU = max([threshBoneHighHU, 350]); % threshold should not smaller than 350 HU
threshBoneLowHU = threshBoneHighHU/2;
threshAirHU = min(imCNNHU1(reconidx==2));

threshAir = threshAirHU/1000*miuWater + miuWater;
threshBoneHigh = threshBoneHighHU/1000*miuWater + miuWater;
threshBoneLow = threshBoneLowHU/1000*miuWater + miuWater;


%% tissue processing: water

pixTrans = 5;           % transition pixels at the boundaries of water

% bone regions
segBoneMethod = 1;      % 1 or others, indicates the method for bone segmentation
if segBoneMethod == 1
    imbonebw = imCNN>threshBoneHigh;
    
else
    bonebwHigh = imCNN>threshBoneHigh;
    bonebwLow = imCNN>threshBoneLow;
    [L,~] = bwlabel(bonebwLow, 8);
    overlapInd = L(bonebwHigh);
    overlapInd = unique(overlapInd);
    
    imbonebw = zeros(size(L));
    for j = 1:length(overlapInd)
        imbonebw = imbonebw + (L == overlapInd(j));
    end
    imbonebw = im2bw(imbonebw,0);
end

% water equivalent regions
imwaterbw = imCNN >threshAir;
imwaterbw = imwaterbw - imbonebw;

% weight of water
waterWeight = bwdist(1-imwaterbw);
waterWeight(waterWeight>pixTrans) = pixTrans;
waterWeight = waterWeight/pixTrans;

% obtain prior image
waterMiuMean = sum(sum(waterWeight.*imCNN))/sum(sum(waterWeight));
imPrior = waterMiuMean*waterWeight + imCNN.*(1 - waterWeight);


%% fill metal region with its nearest pixels

metalBW2 = imdilate(metalBW,ones(3,3));
metalBW3 = imdilate(metalBW2,ones(3,3)) - metalBW2;

[D,L] = bwdist(metalBW3);
temp = imPrior(L);
imPrior = imPrior.*(1-metalBW2) + temp.*metalBW2;



