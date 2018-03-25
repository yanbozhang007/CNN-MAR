% This code is used to train the network for MAR


%% Prepare the training data

preData = 1;    % 0: generate training data from sample images; 1: load a prepared sample training data

% The expected input size (a single 64 x 64 x 3 image patch)

% network
if preData == 1   
    
    % NOTE: Here we give a sample training data to show the training
    % process. In our real trainig process, the size of training data was 
    % remarkably larger than this sample. Please contact author to ask for
    % a larger training data
    load([basePath,'\data\imdb-500.mat']) % imdb
    
elseif preData == 0
    
    % NOTE: Here we give only three sample images to show how to generate 
    % the training data. In our real experiment, samples in the database 
    % were remarkably more than this.    
    dataFolder = [basePath,'\data\'];               % folder of training images
    dataName = 'sample_';                           % pre-name of training images
    dataNum = 1000;                                 % number of patches for training
    imdb = dataGen(dataFolder, dataName, dataNum, miuWater);    % generate training data
    
else
    error('Please specify a correct preData index.')
end


%% Create a network architecture

% architecture of the network
[nPatch,~,nMC,~] = size(imdb.images.data);
nKernel = 3;    % [3], 5, 7 % must be odd and no less than 3
nFeature = 32;  % 16, [32], 48, 64
nConv = 5;      % 3,[5],7,9 % num of conv layers, no less than 2

net = initializeCNNMAR(nPatch, nMC, nKernel, nFeature, nConv);

% Display network
vl_simplenn_display(net) ;


%% learn the model

% Add a loss (using a custom layer)
net = addCustomLossLayer(net, @l2LossForward, @l2LossBackward) ;

% training parameters
trainOpts.expDir = [basePath,'\model\MAR_net'];     % the folder to save networks at each epoch
trainOpts.gpus = useGPU;

trainOpts.batchSize = 16 ;
trainOpts.learningRate = 0.02;
trainOpts.plotDiagnostics = false ;
% trainOpts.plotDiagnostics = true ;
trainOpts.numEpochs = 2000;
trainOpts.errorFunction = 'none' ;

net = cnn_train(net, imdb, @getBatch, trainOpts) ;

