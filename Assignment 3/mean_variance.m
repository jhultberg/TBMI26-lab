function [ mean_data, variance_data ] = mean_variance( x )
%  calculating the variance and the mea

mean_data = sum(x,2)/size(x,2);

% reshape mean_data
mean_reshape = repmat(mean_data,1,size(x,2));

variance_data = 1/size(x,2) * sum((x-mean_reshape).^2,2);

end

