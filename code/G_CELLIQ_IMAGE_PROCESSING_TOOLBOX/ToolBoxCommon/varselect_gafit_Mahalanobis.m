function errorRate = varselect_gafit_Mahalanobis(variableIndices,...
    DataX,LabelY,numSamples)
%VARSELECT_GAFIT Fitness funtion for variable selection
%
%   This function uses the classify function from the statistics
%   toolbox to measure how well a dataset can be classified into groups. The
%   input argument variableIndices is a vector of column indices from the
%   dataset under investigation, contained in the second input argument,
%   data. Data are classified into groups, defined by the third input 
%   variable, groups, using linear discriminant analysis (the default method
%   of the classify function). The error rate is estimated by 10-fold
%   cross-validation.

%   Copyright 2003-2005 The MathWorks, Inc.
%   Updated by Jun Wang (jwang@bwh.harvard.edu)
%   Feb. 5, 2006
%
%   Input:  DataX is a N*D matrix, N is the number of samples, and D is the
%           number of features;
%           LabelY is the class label of the data;
%   Output: selectedVars is index of selected features;
%
% Create ten-fold cross-validation indices
crossValidationIndices = mod(1:numSamples,10);
% Initialise a count of the errors so far
errorsSoFar = 0;
% Repeat for each of the ten cross-validations
for i = 0:9
    % Create a test and training set
    testIndices = (crossValidationIndices == i); 
    trainIndices = ~testIndices;
    % Generate a classifier to discriminate groups in the data
    
    testD=DataX(testIndices,variableIndices);
    trnD=DataX(trainIndices,variableIndices);
    trnL=LabelY(trainIndices,:);
    classes = classify(testD,trnD,trnL,'mahalanobis');

    errors = sum(classes ~= LabelY(testIndices,:));
    errorsSoFar = errorsSoFar+errors;
end
% Extract the final error rate
errorRate = errorsSoFar/numSamples;




