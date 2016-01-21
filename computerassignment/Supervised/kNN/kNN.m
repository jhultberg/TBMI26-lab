function [ labelsOut ] = kNN(X, k, Xt, Lt)
%KNN Your implementation of the kNN algorithm
%   Inputs:
%               X  - Features to be classified
%               k  - Number of neighbors
%               Xt - Training features
%               LT - Correct labels of each feature vector [1 2 ...]'
%
%   Output:
%               LabelsOut = Vector with the classified labels

labelsOut  = zeros(size(X,2),1);
% classes = unique(Lt);
% numClasses = length(classes);

N=size(X,2);
Nt=size(Xt,2);
for j= 1:N
    for i=1:Nt
       u(i)=norm(X(j)-Xt(i));
    end
     %find k smalest vakues of u
      [Val, Ind]=sort(u);
       kInd=Ind(1:k);
    
   for l=1:length(kInd)
       f=kInd(l);
       label(l)=Lt(f);
   end
    % if k = 2
   if (mod(k,2) == 0)
       labelsOut(j)=label(1);
   else
       labelsOut(j)= mode(label);
   end
end


end

