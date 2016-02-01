% Load face and non-face data and plot a few examples
close all
clear 
clc

load 'faces.mat';
load 'nonfaces.mat';


faces = double(faces); 
nonfaces = double(nonfaces);

figure(1)
colormap gray

for k=1:25
    subplot(5,5,k), imagesc(faces(:,:,10*k)), axis image, axis off
end

figure(2)
colormap gray
for k=1:25
    subplot(5,5,k), imagesc(nonfaces(:,:,10*k)), axis image, axis off
end
% Generate Haar feature masks

nbrHaarFeatures = 3; % must be over 25 or change k in the next for-loop
haarFeatureMasks = GenerateHaarFeatureMasks(nbrHaarFeatures);

figure(3)
colormap gray
for k = 1:3 %this loop!
    subplot(5,5,k),imagesc(haarFeatureMasks(:,:,k),[-1 2])
    axis image,axis off
end
% Create a training data set with a number of training data examples
% from each class. Non-faces = class label y=-1, faces = class label y=1

nbrTrainExamples = 4;
trainImages = cat(3,faces(:,:,1:nbrTrainExamples),nonfaces(:,:,1:nbrTrainExamples));
xTrain = ExtractHaarFeatures(trainImages,haarFeatureMasks);
yTrain = [ones(1,nbrTrainExamples), -ones(1,nbrTrainExamples)];


for t=1:nbrTrainExamples %all Tau
    for f=1:nbrHaarFeatures %all features
        for c=1: %all weak classifiers
            
            
            
            
            
        end
    end
end
