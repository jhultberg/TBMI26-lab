function [ cM ] = calcConfusionMatrix( Lclass, Ltrue )
classes = unique(Ltrue);
numClasses = length(classes);
cM = zeros(numClasses);

cM=confusionmat(Ltrue,Lclass);

% for i = 1:length(Lclass)
%     for j = 1:length(Ltrue)
%         if (Ltrue(j) == Ltrue(j))
%             cM(Ltrue(j),Ltrue(j))=cM(Ltrue(j),Ltrue(j))+1;
%         elseif (Ltrue(j)==1)
%             cM(1,2)=cM(1,2)+1;
%         else 
%             cM(2,1)=cM(2,1)+1;
%         end
%     end
% end

end

