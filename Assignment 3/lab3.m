%% Assignment 3
% OBS!!! DO NOT USE CORR(),COV(),ZSCORE()!
load countrydata.mat

%% Calculating mean, variance and normalizing data

countrydata_normalized = countrydata./repmat(sum(countrydata,2),1,size(countrydata,2));

[meandata, variancedata] = mean_variance(countrydata_normalized);
%% Calculaing the Covariance matrix

Cmatrix = covariance_matrix(countrydata_normalized, meandata);

% plotting the Cmatrix
figure(1)
imagesc(Cmatrix); title 'covariance matrix'; axis image; colorbar;
figure(2)
imagesc(countrydata); title 'Input data'; axis image; colorbar;

%% calculating the Correlation matrix

corr_matrix = correlation_matrix(countrydata_normalized,variancedata, meandata);

% plotting the Corrmatrix
figure(3)
imagesc(corr_matrix); title 'correlation matrix'; axis image; colorbar;

%% eigenvectors

[eigenvectors, eigenvalues] = eig(Cmatrix);

figure(4);
% y1 = 
% plot(eigenvectors(1,:).*countrydata(:,1), eigenvectors(2,:).*countrydata(:,2))
