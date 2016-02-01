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


%%
for i=1:size(xTrain)
    [x_sort(i,:), ind(i,:)] = sort(xTrain(i,:),2);
end

%%
d = 1/(2*nbrTrainExamples)*ones(1,2*nbrTrainExamples);
T = 9;
polarity = 1;

for f=1:nbrHaarFeatures %all features/rows
    for t=1:T %all Tau
        for c=1:2*nbrTrainExamples %all weak classifiers/col
            if (polarity*xTrain(f,c)>= polarity*t)
                h(c) = 1;
            else
                h(c) = -1;
            end
        end
        test_vec(:,t) = yTrain.*h;               % test_vec is the vector that knows if the image has been correctly classified
        
        bin_vec = test_vec(:,t);
        bin_vec(bin_vec==1) = 0;          % find all values that are correct labled and set them to zeros
        dummy=d'.*bin_vec;
        error = -sum(dummy);                % adding upp all the erros
        
        if (error >0.5)                     % check if error is bigger than 0.5 if yes then change polarity
            polarity = -1;
            error = 1-error;
        end
        alfa = 1/2*log((1-error)/error);
        if (bin_vec(t) >0)                     % if bin_vec(i) > 0 then it's wrongly classfied
            d(:,t) = d(:,t)*exp(alfa);          % what index??
        else
            d(:,t) = d(:,t)*exp(-alfa);
        end
        
    end
    d=d/sum(d);
end

