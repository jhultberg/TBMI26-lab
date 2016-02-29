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
% faces which failed to be classified correctly
figure(3)
colormap gray
imagesc(faces(:,:,49)), axis image, axis off

% non-faces which failed to be classified correctly
figure(4)
colormap gray
subplot(2,2,1), imagesc(nonfaces(:,:,72)), axis image, axis off
subplot(2,2,2), imagesc(nonfaces(:,:,82)), axis image, axis off
subplot(2,2,3), imagesc(nonfaces(:,:,106)), axis image, axis off
subplot(2,2,4), imagesc(nonfaces(:,:,139)), axis image, axis off

figure(2)
colormap gray
for k=1:25
    subplot(5,5,k), imagesc(nonfaces(:,:,10*k)), axis image, axis off
end
% Generate Haar feature masks
%%

    nbrHaarFeatures = 300;
    haarFeatureMasks = GenerateHaarFeatureMasks(nbrHaarFeatures);
    nbrTrainExamples = 1000;
    
    % Create a training data set with a number of training data examples
    % from each class. Non-faces = class label y=-1, faces = class label y=1
    
    trainImages = cat(3,faces(:,:,1:nbrTrainExamples),nonfaces(:,:,1:nbrTrainExamples));
    xTrain = ExtractHaarFeatures(trainImages,haarFeatureMasks);
    yTrain = [ones(1,nbrTrainExamples), -ones(1,nbrTrainExamples)];
    
    d = 1/(2*nbrTrainExamples)*ones(1,2*nbrTrainExamples);
    T = 25; % # number of base classifiers
    ht = [ones(2,T);zeros(size(xTrain,1),T)];
    alpha = zeros(T,1);
    
    % loop for all classifiers
    for class = 1:T
        e_min = inf;
        p_tmp = 1;
        % loop for all features comp
        for feat = 1:size(xTrain,1)
            % loop for all thresholds
            for tres = 1:nbrTrainExamples
                e_tmp = sum(d.*(yTrain ~= sign(p_tmp*(xTrain(feat,:) - xTrain(feat,tres))))); 
                % find the error of the
                % treshold - the current sample
                if e_tmp >0.5
                    p_tmp = -p_tmp;
                    e_tmp = 1- e_tmp;
                end
                if e_tmp < e_min
                    e_min = e_tmp;
                    ht(1,class) = -xTrain(feat,tres);
                    ht(2,class) = p_tmp;
                    ht(3:end,class)= 0;
                    ht(2+feat,class) = 1;
                end
            end
        end
        % calculating alpha
        alpha(class) = 1/2*log((1-e_min)/e_min);
        
        % update the weights
        d = d.*exp(-alpha(class)*yTrain.*sign(ht(2,class)*(ht(:,class)'*[ones(1,size(xTrain,2)); zeros(1,size(xTrain,2));xTrain])));
        d = d./sum(d);
 
    testImages = cat(3,faces(:,:,1+nbrTrainExamples:2*nbrTrainExamples),nonfaces(:,:,1+nbrTrainExamples:2*nbrTrainExamples));
    xTest = ExtractHaarFeatures(trainImages,haarFeatureMasks);
    yTest = [ones(1,nbrTrainExamples), -ones(1,nbrTrainExamples)]';
    test = strong_classifier(alpha,ht,xTest);
    
    % making a correct classified vector
    correct_classified_percent(class) = sum(yTest == test')/(2*nbrTrainExamples)*100;
end
%%
figure(100)
plot(1:size(correct_classified_percent,2),correct_classified_percent);
title ('Ratio of correct classified samples','FontSize', 14)
xlabel ('Number of weak classifiers','FontSize',16), ylabel ('Percentage','FontSize' , 16)