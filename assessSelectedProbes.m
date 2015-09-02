function [TP, TN, FN, FP, MCC, accuracy, recall, precision, specificity] = assessSelectedProbes(P, y, flag_classify)
%LOO-CV assessment used in paper

%*** Input ****
% P output from selectProbes.m
% y, discretized data (y=1 down, y-2 up), baseline samples removed, same vector used for
% selectProbes.m
% flag_classify: '1NN', '3NN', '5NN', 'NB', 'DT', 'SVM', should be the same
% method used in selectProbes.m

%*** Output ****
% TN, TP, FN, FP, MCC (Matthew's Correlation Coeffient), accuracy, recall,
% presicion and specificity

[f,g] = size(P);
pred = nan(f,1);
method = flag_classify;
if strcmp(method, '1NN')
    %LOO-CV
    for lo=1:f
        %  remove patient
        x = P;
        x(lo,:) = [];
        y2 = y;
        y2(lo) = [];
        [W] = ClassificationKNN.fit(x, y2);
        pred(lo,1)= predict(W, P(lo,:));
    end
elseif strcmp(method, '3NN')
    %LOO-CV
    for lo=1:f
        %  remove patient
        x = P;
        x(lo,:) = [];
        y2 = y;
        y2(lo) = [];
        [W] = ClassificationKNN.fit(x, y2, 'NumNeighbors', 3);
        pred(lo,1)= predict(W, P(lo,:));
    end
elseif strcmp(method, '5NN')
    %LOO-CV
    for lo=1:f
        %  remove patient
        x = P;
        x(lo,:) = [];
        y2 = y;
        y2(lo) = [];
        [W] = ClassificationKNN.fit(x, y2, 'NumNeighbors', 5);
        pred(lo,1)= predict(W, P(lo,:));
    end
elseif strcmp(method, 'NB')
    %LOO-CV
    for lo=1:f
        %  remove patient
        x = P;
        x(lo,:) = [];
        y2 = y;
        y2(lo) = [];
        [W] = NaiveBayes.fit(x, y2);
        pred(lo,1)= predict(W, P(lo,:));
    end
elseif strcmp(method, 'DT')
    %LOO-CV
    for lo=1:f
        %  remove patient
        x = P;
        x(lo,:) = [];
        y2 = y;
        y2(lo) = [];
        [W] = ClassificationTree.fit(x, y2);
        pred(lo,1)= predict(W, P(lo,:));
    end
elseif strcmp(method, 'SVM')
    %LOO-CV
    for lo=1:f
        %  remove patient
        x = P;
        x(lo,:) = [];
        y2 = y;
        y2(lo) = [];
        [W] = svmtrain(x, y2);
        pred(lo,1)= svmclassify(W, P(lo,:));
    end
else
    'Method incorrectly specified: Choose 1NN, 3NN, 5NN, NB, DT, SVM' %#ok<NOPRT>
end

TP = 0;
TN = 0;
FP = 0;
FN = 0;
%calculate number of tn, tp, fn, fp
for j=1:f
    if pred(j,1) == 1 && y(j) == 1
        TP = TP + 1; 
    elseif pred(j,1) == 2 && y(j) == 2
        TN = TN + 1;
    elseif pred(j,1) == 1 && y(j) == 2 
        FP = FP+1;
    elseif pred(j,1) == 2 && y(j) == 1
        FN =FN+1;
    end
end

MCC = ((TP * TN)- (FP * FN)) /sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN));
recall = TP/(TP+FN);
precision = TP/(TP+FP);
specificity = TN/(TN+FP);
accuracy = (TN +TP)/(FN + FP + TN + TP);
end