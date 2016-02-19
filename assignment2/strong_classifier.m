function [ H] = strong_classifier( alpha,ht,X )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    h = (ht(2,:).*alpha')*(ht(:,:)'*[ones(1,size(X,2)); zeros(1,size(X,2));X]);

H = sign(h);
%H = sign(h'*alpha);
end

