%% This script will help you test out your single layer neural network code

%% Select which data to use:

% 1 = dot cloud 1
% 2 = dot cloud 2
% 3 = dot cloud 3
% 4 = OCR data

dataSetNr = 3; % Change this to load new data 

[X, D, L] = loadDataSet( dataSetNr );

%% Select a subset of the training features

numBins = 2; % Number of Bins you want to devide your data into
numSamplesPerLabelPerBin = inf;%inf; % Number of samples per label per bin, set to inf for max number (total number is numLabels*numSamplesPerBin)
selectAtRandom = true; % true = select features at random, false = select the first features

[ Xt, Dt, Lt ] = selectTrainingSamples(X, D, L, numSamplesPerLabelPerBin, numBins, selectAtRandom );

% Note: Xt, Dt, Lt will be cell arrays, to extract a bin from them use i.e.
% XBin1 = Xt{1};
%% Modify the X Matrices so that a bias is added

% The Training Data
Xtraining = [];
Xtraining  = [ones(1,size(Xt{1},2));Xt{1}]; % Remove this line

% The Test Data
Xtest = [];
Xtest  = [ones(1,size(Xt{2},2));Xt{2}]; % Remove this line


%% Train your single layer network
% Note: You nned to modify trainSingleLayer() in order to train the network

numHidden = 50 ; % Change this, Number of hidde neurons 
numIterations = 14000; % Change this, Numner of iterations (Epochs)
learningRate = 0.1; % Change this, Your learningrate
classes=length(unique(Lt{1}));
W0 = 0.01*randn(numHidden+1,size(Xtest,1));% Change this, Initiate your weight matrix W
V0 = 0.01*randn(classes,numHidden+1); % Change this, Initiate your weight matrix V

% W0 = 0.05*(rand(numHidden+1,size(Xtraining,1))-0.5); % Remove this line
% V0 = 0.05*(rand(length(unique(L)),numHidden+1)-0.5); % Remove this line

%


%% non-generable
 Xtraining = Xtraining(:,1:30:end);
Dtraining = Dt{1};
Dtraining = Dtraining(:,1:30:end);
%%
tic
[W,V, trainingError, testError ] = trainMultiLayer(Xtraining,Dtraining,Xtest,Dt{2}, W0,V0,numIterations, learningRate );
trainingTime = toc;
%% Plot errors
figure(1101)
clf
[mErr, mErrInd] = min(testError);
plot(trainingError,'k','linewidth',1.5)
hold on
plot(testError,'r','linewidth',1.5)
plot(mErrInd,mErr,'bo','linewidth',1.5)
hold off
title('Training and Test Errors, Multi-Layer')
legend('Training Error','Test Error','Min Test Error')

%% Calculate The Confusion Matrix and the Accuracy of the Evaluation Data
% Note: you have to modify the calcConfusionMatrix() function yourselfs.

[ Y, LMultiLayerTraining ] = runMultiLayer(Xtraining, W, V);
tic
[ Y, LMultiLayerTest ] = runMultiLayer(Xtest, W,V);
classificationTime = toc/length(Xtest);
% The confucionMatrix
cM = calcConfusionMatrix( LMultiLayerTest, Lt{2});

% The accuracy
acc = calcAccuracy(cM);

display(['Time spent training: ' num2str(trainingTime) ' sec'])
display(['Time spent calssifying 1 feature vector: ' num2str(classificationTime) ' sec'])
display(['Accuracy: ' num2str(acc)])

%% Plot classifications
% Note: You do not need to change this code.
Ltraining=Lt{1};
Ltraining = Ltraining(1:30:end,:);

if dataSetNr < 4
    plotResultMultiLayer(W,V,Xtraining,Ltraining,LMultiLayerTraining,Xtest,Lt{2},LMultiLayerTest)
else
    plotResultsOCR( Xtest, Lt{2}, LMultiLayerTest )
end
