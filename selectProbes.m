function [ix, P] = selectProbes(X, y, flag_classify)

%train a model with 10-x validation and sequential forward selection

% ***Input (3 inputs) ****
%X, matrix of all probes associated with the gene from 450K array
%rows samples, probe samples corresponding to baseline expressed samples
%should be already removed, see instructions below
%columns are probes

%y discretized gene expression data of gene ( 1 down, 2 up), with baseline samples removed
%You can use your own method or a 1.2 fold change wrt the median 
%function is y1 = discretize_data(y0) assumes data is not yet log
%transformed then apply (X1,y2) = remove_basesline(X, y1) to remove the
%baseline expressed genes and corresponding probes


%flag_classify: flag specifying the classification method
% '1NN', '3NN', '5NN', 'NB', 'DT', 'SVM' as specified in paper


% ***Output (2 outputs) ****
% ix, index of selected probes (columns that were selected from X)
% P, a matrix of selected probes from X which can be used in other
% functions in this package

method = flag_classify;
if strcmp(method, '1NN')
    %training function
    f = @(xtrain, ytrain, xtest, ytest) sum(ytest ~= predict(ClassificationKNN.fit(xtrain,ytrain), xtest));
    %sequential fs on training function
    fs = sequentialfs(f,X,y,'cv',10);
    % get index of selected features
    ix = find(fs == 1);
    P = X(:,ix);
elseif strcmp(method, '3NN')
    %training function
    f = @(xtrain, ytrain, xtest, ytest) sum(ytest ~= predict(ClassificationKNN.fit(xtrain,ytrain, 'NumNeighbors',3), xtest));
    %sequential fs on training function
    fs = sequentialfs(f,X,y,'cv',10);
    % get index of selected features
    ix = find(fs == 1);
    P = X(:,ix);
elseif strcmp(method, '5NN')
    %training function
    f = @(xtrain, ytrain, xtest, ytest) sum(ytest ~= predict(ClassificationKNN.fit(xtrain,ytrain, 'NumNeighbors',5), xtest));
    %sequential fs on training function
    fs = sequentialfs(f,X,y,'cv',10);
    % get index of selected features
    ix = find(fs == 1);
    P = X(:,ix);
elseif strcmp(method, 'NB')
    %training function
    f = @(xtrain, ytrain, xtest, ytest) sum(ytest ~= predict(NaiveBayes.fit(xtrain,ytrain,'Distribution','kernel'), xtest));
    %sequential fs on training function
    fs = sequentialfs(f,X,y,'cv',10);
    % get index of selected features
    ix = find(fs == 1);
    P = X(:,ix);
elseif strcmp(method, 'DT')
    %training function
    f = @(xtrain, ytrain, xtest, ytest) sum(ytest ~= predict(ClassificationTree.fit(xtrain,ytrain), xtest));
    %sequential fs on training function
    fs = sequentialfs(f,X,y,'cv',10);
    % get index of selected features
    ix = find(fs == 1);
    P = X(:,ix);
elseif strcmp(method, 'SVM')
    %training function
    f = @(xtrain, ytrain, xtest, ytest) sum(ytest ~= svmclassify(svmtrain(xtrain,ytrain), xtest));
    %sequential fs on training function
    fs = sequentialfs(f,X,y,'cv',10);
    % get index of selected features
    ix = find(fs == 1);
    P = X(:,ix);
else
    'Method incorrectly specified: Choose 1NN, 3NN, 5NN, NB, DT, SVM' %#ok<NOPRT>
end


end