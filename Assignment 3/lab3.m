%% Assignment 3
% OBS!!! DO NOT USE CORR(),COV(),ZSCORE()!
load countrydata.mat

%% Calculating mean, variance and normalizing data

%countrydata_normalized = countrydata./repmat(sum(countrydata,2),1,size(countrydata,2));
countrydata_normalized = (countrydata - repmat(min(countrydata,[],2),1,size(countrydata,2))) ...
   ./(repmat(max(countrydata,[],2),1,size(countrydata,2))-repmat(min(countrydata,[],2),1,size(countrydata,2)));
[meandata, variancedata] = mean_variance(countrydata_normalized);
%% Calculaing the Covariance matrix
% Harder to inerpreteate, one can only know the sign of the correlation

Cmatrix = covariance_matrix(countrydata_normalized, meandata);

% plotting the Cmatrix
figure(1)
imagesc(Cmatrix); title 'covariance matrix'; axis image; colorbar;
%figure(2)
%imagesc(countrydata); title 'Input data'; colorbar;

%% calculating the Correlation matrix

corr_matrix = correlation_matrix(countrydata_normalized,variancedata, meandata);

% plotting the Corrmatrix
figure(3)
imagesc(corr_matrix); title 'correlation matrix'; axis image; colorbar;

%% eigenvectors

[eigenvectors, eigenvalues] = eig(Cmatrix);


%%
figure(4);
for cou = 1:105
    hold on
    if (countryclass(cou) == 0)
        scatter(eigenvectors(:,1)'*countrydata_normalized(:,cou),eigenvectors(:,2)'*countrydata_normalized(:,cou),20,'b');
        
    elseif (countryclass(cou) == 1)
        scatter(eigenvectors(:,1)'*countrydata_normalized(:,cou),eigenvectors(:,2)'*countrydata_normalized(:,cou),20,'m');
    else
        scatter(eigenvectors(:,1)'*countrydata_normalized(:,cou),eigenvectors(:,2)'*countrydata_normalized(:,cou),20,'r');
    end
    if cou==41
        scatter(eigenvectors(:,1)'*countrydata_normalized(:,cou),eigenvectors(:,2)'*countrydata_normalized(:,cou),20,'filled');
    end
end
title ('Principal components','FontSize',16);

hold off

%% FLD

% extracting out indecies for two classes
class0_index = find(countryclass == 2);
class2_index = find(countryclass == 1);

class0_data = countrydata_normalized(:,class0_index);
class2_data = countrydata_normalized(:,class2_index);

%find the mean and variance for each classes
[mean0, var0 ] = mean_variance(class0_data);
[mean2, var2 ] = mean_variance(class2_data);

% calculating the covariance matrices
cov0 = covariance_matrix(class0_data, mean0);
cov2 = covariance_matrix(class2_data, mean2);

C_tot = cov0 + cov2;

w = C_tot\(mean0-mean2);

%% plotting 
figure(5)
class0_proj = w'*class0_data;
class2_proj = w'*class2_data;
histogram(class2_proj,10);
hold on
histogram(class0_proj,10);
hold off
title ('FLD', 'FontSize', 16)

%% 