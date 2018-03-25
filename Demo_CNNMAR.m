% This is the testing demo for CNN based MAR.
%
% 
% 
% Yanbo Zhang
% yanbozhang007@gmail.com
% University of Massachusetts Lowell
% 2018-02-06


useGPU = 1;     % 0: cpu; 1: gpu
preTrain = 0;   % 0: train a network; 1: load a pretrained network
dataID = 2;     % the id of testing data sample in "..\data" folder, set to {0,1,2,3}. "0" means a new data not given in the data folder
miuWater = 0.19;% the linear attenuation coefficient of water [1/cm], this may change for different scans, please adjust it
% metalThreshHU = 4000; % the threshold to segment metal, users need to mannully tune this parameter to be adaptive to different metal cases [HU]

% add related folders into the path
basePath = fileparts(mfilename('fullpath'));
addpath(genpath(basePath))

%% Obtain a CNN network

% setup
setupCNN('useGpu', num2str(useGPU)); 

% obtain a network
if preTrain == 1    
    % load a pretrained network used in our work
    load([basePath '\model\net-epoch-2000.mat'])
    
elseif preTrain == 0
    
    % NOTE: Here we only apply very limited sample data to show the training
    % process. In our real trainig process, the training samples were much
    % more than this, and were different from the testing cases.    
    net_train;
    
else
    error('Please specify a correct preTrain index.')
end


net.layers(end) = [];   % delete the loss layer

%% CNN-MAR

% load testing data
[proj, imRaw, metalBW, metalTrace] = loadData(dataID);

% pre-correction
imLI = marLI(proj, metalTrace);
imBHC = marBHC(proj, metalBW);

% CNN processing
imInput = dataInput(imRaw, imBHC, imLI, metalBW, miuWater);
temp = vl_simplenn(net, imInput);
imCNN = temp(end).x;

% generate CNN prior image using the tissue processing
imPrior = cnnPrior(imCNN, metalBW, miuWater);

% projection replacement
imCNNMAR = prior2corr(proj, imPrior, metalTrace);


%% Evaluation

% NMAR as the competing method
[imNMAR1, imNMAR2]= nmar(proj, imRaw, imLI, metalTrace, metalBW, miuWater);

% set ROI
[ROIx, ROIy] = roixy(imRaw, dataID);

% show results
dispWin = disWinID(dataID);
imAll = [];
imAll.im = {imRaw, imBHC, imLI, imNMAR1, imNMAR2, imCNN, imCNNMAR};
imAll.name = {'imRaw', 'imBHC', 'imLI', 'imNMAR1', 'imNMAR2', 'imCNN', 'imCNNMAR'};
showResults(imRaw, imAll, metalBW, ROIx, ROIy, dispWin);

% RMSE, SSIM
imRef = loadref(dataID);
rmse_All = rmseAll(imRef, imAll, metalBW, ROIx, ROIy);
rmseHU_All = rmse_All/miuWater*1000;    % RMSE, unit:HU
ssim_All = ssimAll(imRef, imAll, metalBW, ROIx, ROIy);

