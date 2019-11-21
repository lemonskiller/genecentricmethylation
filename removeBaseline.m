function [X1, y1] = removeBaseline(X, y)
%Function removes baseline expressed samples from expression and
%methylation data, expression data should already be discretized with
%discretizeData or your own method.

% INPUTS: X -- DNA methylation data
% y -- discretized gene expression data ( 1 down, 2 up, 0 baseline). This
% can be the result of the discretizeData function in this package or your
% own method of discretization

% OUTPUTS: X1 -- DNA methylation with baseline samples removed
% y1 -- gene expression with baseline samples removed

[numSamps, numProbes] = size(X);
[idx] = find(y == 0);
s = setxor(1:numSamps,idx); % setxor(A,B):求异或，得A-A∩B，A中B所没有的，在此为有！=0的所有样本id+
X1 = X(s,:);
y1 = y(s,1);
end
