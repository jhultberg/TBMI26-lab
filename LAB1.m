run setupSupervisedLab.m

dataSetNr = 2; % Change this to load new data 
[X, D, L] = loadDataSet( dataSetNr );

numBins = 2; % Number of Bins you want to devide your data into
numSamplesPerLabelPerBin = 100; % Number of samples per label per bin, set to inf for max number (total number is numLabels*numSamplesPerBin)
selectAtRandom = true; % true = select features at random, false = select the first features
[ Xt, Dt, Lt ] = selectTrainingSamples(X, D, L, numSamplesPerLabelPerBin, numBins, selectAtRandom );

Xt2=Xt{2};
nlen = size(Xt2,2);
xtsplit{1}=Xt2(:,(1:floor(nlen/3)));
xtsplit{2}=Xt2(:,ceil(nlen/3):floor(2*nlen/3));
xtsplit{3}=Xt2(:,ceil(2*nlen/3):end);

Lt2=Lt{2}';
Llen = size(Lt2,2);
Ltsplit{1}=Lt2(:,(1:floor(Llen/3)));
Ltsplit{2}=Lt2(:,ceil(Llen/3):floor(2*Llen/3));
Ltsplit{3}=Lt2(:,ceil(2*Llen/3):end);

for k=1:20
    LkNN = kNN(xtsplit{2}, k, [xtsplit{3} xtsplit{1}], [Ltsplit{3} Ltsplit{1}]);
    cM = calcConfusionMatrix( LkNN, Ltsplit{2});
    acc(k) = calcAccuracy(cM);
end

[value indK] = max(acc)


