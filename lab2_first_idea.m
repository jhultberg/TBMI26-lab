%% first idea lab2

%
% for f=1:nbrHaarFeatures %all features/rows
%     for t=1:T %all Tau
%         for c=1:2*nbrTrainExamples %all weak classifiers/col
%             if (polarity*xTrain(f,c)>= polarity*t)
%                 h(c) = 1;
%             else
%                 h(c) = -1;
%             end
%         end
%         test_vec(:,t) = yTrain.*h;               % test_vec is the vector that knows if the image has been correctly classified
%
%         bin_vec = test_vec(:,t);
%         bin_vec(bin_vec==1) = 0;          % find all values that are correct labled and set them to zeros
%         dummy=d'.*bin_vec;
%         error = -sum(dummy);                % adding upp all the erros
%
%         if (error >0.5)                     % check if error is bigger than 0.5 if yes then change polarity
%             polarity = -1;
%             error = 1-error;
%         end
%         alfa = 1/2*log((1-error)/error);
%         if (bin_vec(t) >0)                     % if bin_vec(i) > 0 then it's wrongly classfied
%             d(:,t) = d(:,t)*exp(alfa);          % what index??
%         else
%             d(:,t) = d(:,t)*exp(-alfa);
%         end
%
%     end
%     d=d/sum(d);
% end

