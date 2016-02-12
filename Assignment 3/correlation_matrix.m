function [ corr ] = correlation_matrix( x, variancedata, meandata)
%calculating correlation matrix
co=covariance_matrix(x, meandata);

for feat= 1:size(variancedata,1)
    for country = 1:size(variancedata,1)
        corr(feat,country) = co(feat,country)/sqrt(variancedata(feat)*variancedata(country));
    end
end
end

