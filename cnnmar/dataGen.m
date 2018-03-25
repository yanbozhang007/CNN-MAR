function imdb = dataGen(dataFolder, dataName, dataNum, miuWater)
% This code is used to generate training data from given images
% Input:
% dataFolder:   folder of the given training images
% dataName:     pre-name of training images
% dataNum:      number of the generated image patches
% miuWater:     linear attenuation coefficient of water (1/cm)
% Output:
% imdb:         generated image patches
% imdb.images.id:       id of each image patch
% imdb.images.data:     input image patches (patch size X * patch size Y * 3 * dataNum)
% imdb.images.set:      1?training data; 2: validation data
% imdb.images.label:    target of the CNN  (patch size X * patch size Y * 1 * dataNum)


% data structure
imdb =[];
imdb.images =[];
imdb.images.id = [];
imdb.images.data = [];
imdb.images.set = [];
imdb.images.label = [];

% patch size
xsize = 64;
ysize = 64;

nMC = 3;                % number of channel
pixInterv = 8;          % pixel step of grid
maxRatio = 0.6;%0.5;	% this ratio is within [0 1], indicating this proportion of data are selected from the max difference data
trainRatio = 0.8;       % this ratio is within (0 1], indicating this proportion of data are used for training, and rest for validation
angRotate = [0 90];     % rotation degrees for image augment


tempSample = dir([dataFolder, dataName, '*.mat']);      % load training images
num_sample=length(tempSample);
nPatch = ceil(dataNum/(num_sample*length(angRotate)));  % number of selected patches in an image

id = 1;
for i=1:num_sample
    load([dataFolder,tempSample(i).name]);              % load imData
    
    metalBW = imData.metalBW;
    imData.imRaw(metalBW) = single(miuWater);
    imData.imBHC(metalBW) = single(miuWater);
    imData.imLI(metalBW) = single(miuWater);
    imData.imRef(metalBW) = single(miuWater);
    
    
    im01(:,:,1) = imData.imRaw;    % input 3-channel image
    im01(:,:,2) = imData.imBHC;
    im01(:,:,3) = imData.imLI;
    im02 = imData.imRef;
    
    % consider image rotation
    for iAng = 1:length(angRotate)
        
        im1 = imrotate(im01, angRotate(iAng), 'bicubic');
        im2 = imrotate(im02, angRotate(iAng), 'bicubic');
        [imsizex, imsizey] = size(im2);
        
        maxDiffNum = round(nPatch*maxRatio);
        
        infoPatch = [];     % positions of patchs
        infoPatchDiff = [];
        iPatch = 0;
        imDiff = im1 - repmat(im2, 1, 1, nMC);
        for ix = 1:pixInterv:(imsizex - xsize)
            for iy = 1:pixInterv:(imsizey - ysize)
                iPatch = iPatch +1;
                infoPatch(iPatch, 1) = ix;
                infoPatch(iPatch, 2) = iy;
                infoPatchDiff(iPatch, :) =  reshape(sum(sum( (imDiff(ix:ix+xsize-1, iy:iy+ysize-1, :)).^2, 1), 2), 1, nMC);
                
            end
        end
        
        maxDiffNumPart = round(maxDiffNum/nMC);
        xpos = [];
        ypos = [];
        for iMC = 1:nMC
            % for iMC th channel, select maxDiffNumPart patches
            [~, I] = sort(infoPatchDiff(:, iMC), 'descend');
            % position of patches containing max artifacts
            maxInd = I(1:maxDiffNumPart);
            xpos = [xpos; infoPatch(maxInd, 1)];
            ypos = [ypos; infoPatch(maxInd, 2)];
            infoPatchDiff(maxInd, :) = [];
            infoPatch(maxInd, :) = [];
            
        end
        
        % select rest patches randomly
        numRest = size(infoPatch, 1);
        I = randperm(numRest);
        restIndx = infoPatch(I(1:nPatch-maxDiffNumPart*nMC), 1);
        restIndy = infoPatch(I(1:nPatch-maxDiffNumPart*nMC), 2);
        xpos = [xpos; restIndx];
        ypos = [ypos; restIndy];
        
        % collect patch
        for p = 1:length(xpos)
            pim1 = im1(xpos(p):xpos(p)+xsize-1, ypos(p):ypos(p)+ysize-1, :);
            pim2 = im2(xpos(p):xpos(p)+xsize-1, ypos(p):ypos(p)+ysize-1, :);
            imdb.images.id(id) = id;
            imdb.images.data(:, :, :, id) = single(pim1);
            imdb.images.label(:, :, :, id) = single(pim2);
            id = id + 1;
        end
    end
end


imdb.images.id = 1:dataNum;
imdb.images.data = single(imdb.images.data(:,:,:,1:dataNum));
imdb.images.label = single(imdb.images.label(:,:,:,1:dataNum));
pnumtrain = round(dataNum*trainRatio);
ind = randperm(dataNum);
imdb.images.set = 2*ones(size(imdb.images.id));
imdb.images.set(ind(1:pnumtrain)) = 1;
