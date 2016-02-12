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

for cou = 1:105
    hold on
    
    if (countryclass(cou) == 0)
        scatter(eigenvectors(:,1)'*countrydata(:,cou),eigenvectors(:,2)'*countrydata(:,cou),20,'b');
        
    elseif (countryclass(cou) == 1)
        scatter(eigenvectors(:,1)'*countrydata(:,cou),eigenvectors(:,2)'*countrydata(:,cou),20,'m');
        
    else
        scatter(eigenvectors(:,1)'*countrydata(:,cou),eigenvectors(:,2)'*countrydata(:,cou),20,'r');
    end
    if cou==41
        scatter(eigenvectors(:,1)'*countrydata(:,cou),eigenvectors(:,2)'*countrydata(:,cou),20,'c');
    end
end
xlim( [0 1000])
hold off



%% FLD


