% Load face and non-face data and plot a few examples
close all
clear
clc
%%

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

nbrHaarFeatures = 5; % must be over 25 or change k in the next for-loop
haarFeatureMasks = GenerateHaarFeatureMasks(nbrHaarFeatures);

figure(3)
colormap gray
for k = 1:min(25,nbrHaarFeatures)%3 ,this loop!
    subplot(5,5,k),imagesc(haarFeatureMasks(:,:,k),[-1 2])
    axis image,axis off
end
% Create a training data set with a number of training data examples
% from each class. Non-faces = class label y=-1, faces = class label y=1

nbrTrainExamples = 4;
trainImages = cat(3,faces(:,:,1:nbrTrainExamples),nonfaces(:,:,1:nbrTrainExamples));
xTrain = ExtractHaarFeatures(trainImages,haarFeatureMasks);
yTrain = [ones(1,nbrTrainExamples), -ones(1,nbrTrainExamples)];


%%
for i=1:size(xTrain)
    [x_sort(i,:), ind(i,:)] = sort(xTrain(i,:),2);
end

d = 1/(2*nbrTrainExamples)*ones(1,2*nbrTrainExamples);
T = 9; % # number of base classifiers
ht = zeros(3,T); % h(x,tau,polarity
ht(3,:) = 1; % initializing the polarity to 1.
alpha = zeros(T,1);

% loop for all classifiers
for class = 1:T
    e_min = inf;
    
    % loop for all features comp
    for feat = 1:size(xTrain,1)
        p_tmp = 1;
        % loop for all thresholds
        for tres = 1:nbrTrainExamples
            e_tmp = sum(d.*(yTrain ~= sign(p_tmp*(xTrain(feat,:) - xTrain(feat,tres))))); % find the error of the
                                                                                    % treshold - the current sample
        end
        if e_tmp >0.5
            p_tmp = -1;
            e_tmp = 1- e_tmp;
        end
        if e_tmp < e_min
           e_min = e_tmp;
           ht(1,class) = feat; % classifier
           ht(2,class) = xTrain(feat,tres); % threshold
           ht(3,class) = p_tmp; % polarity
        end
        
    end
    % finding alpha
    alpha(class) = 1/2*log((1-e_min)/e_min);
    % update the weights
    d = d.*exp(-alpha(class)*yTrain.*sign(ht(3,class)*(xTrain(ht(1,class),:)-ht(2,class))));
    d = d./sum(d);
   
end

test = strong_classifier(alpha,ht,xTrain);

