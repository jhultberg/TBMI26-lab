function [ cov ] = covariance_matrix( x, meanx )
% Our own covariance function

%reshaping the mean vector
meanx_reshap = repmat(meanx,1,size(x,2));

% Calculating the covariance matrix
cov = 1/size(x,2) * (x-meanx_reshap)*(x-meanx_reshap)';

end

