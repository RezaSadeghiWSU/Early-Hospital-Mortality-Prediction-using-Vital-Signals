function [Accuracy, AUC,X,Y,DOR,Sensitivity,Specificity,F1,Precision] = DecisionTree(Data)

% Convert input to table
inputTable = array2table(Data, 'VariableNames', {'Maximum', 'Minimum', 'Mean', 'Median', 'Mode', 'Standard_deviation', 'Variance', 'Range', 'Kurtosis', 'Skewness', 'Averaged_power', 'Energy_spectral_density', 'Mortality'});

predictorNames = {'Maximum', 'Minimum', 'Mean', 'Median', 'Mode', 'Standard_deviation', 'Variance', 'Range', 'Kurtosis', 'Skewness', 'Averaged_power', 'Energy_spectral_density'};
predictors = inputTable(:, predictorNames);
response = inputTable.Mortality;
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false, false];

% Train a classifier
% This code specifies all the classifier options and trains the classifier.
classificationTree = fitctree(...
    predictors, ...
    response, ...
    'SplitCriterion', 'gdi', ...
    'MaxNumSplits', 100, ...
    'Surrogate', 'off', ...
    'ClassNames', [-1; 1]);

% Create the result struct with predict function
predictorExtractionFcn = @(x) array2table(x, 'VariableNames', predictorNames);
treePredictFcn = @(x) predict(classificationTree, x);
trainedClassifier.predictFcn = @(x) treePredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
trainedClassifier.ClassificationTree = classificationTree;
trainedClassifier.About = 'This struct is a trained model exported from Classification Learner R2017a.';
trainedClassifier.HowToPredict = sprintf('To make predictions on a new predictor column matrix, X, use: \n  yfit = c.predictFcn(X) \nreplacing ''c'' with the name of the variable that is this struct, e.g. ''trainedModel''. \n \nX must contain exactly 12 columns because this model was trained using 12 predictors. \nX must contain only predictor columns in exactly the same order and format as your training \ndata. Do not include the response column or any columns you did not import into the app. \n \nFor more information, see <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appclassification_exportmodeltoworkspace'')">How to predict using an exported model</a>.');

% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
% Convert input to table
inputTable = array2table(Data, 'VariableNames', {'Maximum', 'Minimum', 'Mean', 'Median', 'Mode', 'Standard_deviation', 'Variance', 'Range', 'Kurtosis', 'Skewness', 'Averaged_power', 'Energy_spectral_density', 'Mortality'});

predictorNames = {'Maximum', 'Minimum', 'Mean', 'Median', 'Mode', 'Standard_deviation', 'Variance', 'Range', 'Kurtosis', 'Skewness', 'Averaged_power', 'Energy_spectral_density'};
predictors = inputTable(:, predictorNames);
response = inputTable.Mortality;
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false, false];

% Perform cross-validation
partitionedModel = crossval(trainedClassifier.ClassificationTree, 'KFold', 10);

% Compute validation predictions
[validationPredictions, validationScores] = kfoldPredict(partitionedModel);

% Compute validation accuracy
Accuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');

view(trainedClassifier.ClassificationTree,'Mode','graph') 

[X,Y,~,AUC] = perfcurve(response,validationScores(:,2),1);

C = confusionmat(response,validationPredictions);

TP=C(1,1);
FN=C(1,2);
FP=C(2,1);
TN=C(2,2);

DOR=(TP*TN)/(FP*FN);
Sensitivity=TP/(TP+FN);
Specificity=TN/(TN+FP);
F1=2*TP/(2*TP+FP+FN);
Precision=TP/(TP+FP);

imp = predictorImportance(trainedClassifier.ClassificationTree);

figure;
bar(imp);
title('Predictor Importance Estimates');
ylabel('Estimates');
xlabel('Predictors');
h = gca;
h.XTickLabel = trainedClassifier.ClassificationTree.PredictorNames;
h.XTickLabelRotation = 45;
h.TickLabelInterpreter = 'none';
