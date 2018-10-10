clc
clear

load('HRRepository_OneHour.mat')
%load('HRRepository_OneHour_OlderPatients.mat')

X = FirstHour(:,1:end-1);
Y = FirstHour(:,end);
Y(find(Y==0))=-1;

[N D] = size(X);

%% Standardize the feature sapce
for i = 1:D
    X_scaled(:,i) = 2*((X(:,i) - min(X(:,i))) / ( max(X(:,i)) - min(X(:,i)) ))-1;
end
X_scaled = X_scaled + normrnd(0,0.01,size(X_scaled));

%% Oversampling using ASUWO (Adaptive Semi-Unsupervised Weighted Oversampling) -> http://www.sciencedirect.com/science/article/pii/S0957417415007356
disp ('ASUWO')
CThresh = 1;
K = 3;
NN = 5;
NS = 5;
[DatanewASUWO, LabelnewASUWO] = ASUWO(X_scaled,Y, CThresh , K, NN, NS);
Data=[DatanewASUWO, LabelnewASUWO];

%% Classifiers
disp('*****Descriptive classifiers*****')
disp('Decision Tree')
[DTAccuracy, DTAUC,DTX,DTY,DTDOR,DTSensitivity,DTSpecificity,DTF1,DTPrecision] = DecisionTree(Data);
disp('Linear Discriminant')
[LDAccuracy, LDAUC,LDX,LDY,LDDOR,LDSensitivity,LDSpecificity,LDF1,LDPrecision] =  LinearDiscriminant(Data);
disp('LogisticRegression')
[LRAccuracy, LRAUC,LRX,LRY,LRDOR,LRSensitivity,LRSpecificity,LRF1,LRPrecision] =  LogisticRegression(Data);
disp('Linear SVM')
[LSAccuracy, LSAUC,LSX,LSY, LSDOR,LSSensitivity,LSSpecificity,LSF1,LSPrecision] =  SVM(Data,'linear');

disp('*****Non-descriptive classifiers*****')
disp('Gaussian SVM')
[GSAccuracy, GSAUC,GSX,GSY,GSDOR,GSSensitivity,GSSpecificity,GSF1,GSPrecision] =  SVM(Data,'gaussian');
disp('KNN')
[KNNAccuracy, KNNAUC,KNNX,KNNY,KNNDOR,KNNSensitivity,KNNSpecificity,KNNF1,KNNPrecision] = KNN(Data);
disp('Random Forest')
[RFAccuracy, RFAUC,RFX,RFY,RFDOR,RFSensitivity,RFSpecificity,RFF1,RFPrecision] =  RandomForest(Data);
disp('AdaBoost decision tree')
[ADTAccuracy, ADTAUC,ADTX,ADTY,ADTDOR,ADTSensitivity,ADTSpecificity,ADTF1,ADTPrecision] =  AdaBoostDT(Data);


%% Results
%>>Accuracy
disp('Accuracy of transparent classifiers')
%disp(['Decision Tree, ' 'Linear Discriminant, ' 'Logistic Regression, ' 'LinearSVM, ' 'KNN'])
disp(['Decision Tree, ' 'Linear Discriminant, ' 'Logistic Regression, ' 'LinearSVM'])
%disp([DTAccuracy LDAccuracy LRAccuracy LSAccuracy KNNAccuracy])
disp([DTAccuracy LDAccuracy LRAccuracy LSAccuracy])

disp('Accuracy of Non-descriptive classifiers')
disp(['Gaussian SVM, ' 'KNN, ' 'Random Forest, ' 'AdaBoost decision tree'])
disp([GSAccuracy KNNAccuracy RFAccuracy ADTAccuracy])

%>>AUC
disp('AUC of transparent classifiers')
%disp(['Decision Tree, ' 'Linear Discriminant, ' 'Logistic Regression, ' 'LinearSVM, ' 'KNN'])
disp(['Decision Tree, ' 'Linear Discriminant, ' 'Logistic Regression, ' 'LinearSVM'])
%disp([DTAUC LDAUC LRAUC LSAUC KNNAUC])
disp([DTAUC LDAUC LRAUC LSAUC])

disp('AUC of Non-descriptive classifiers')
disp(['Gaussian SVM, ' 'KNN, ' 'Random Forest, ' 'AdaBoost decision tree'])
disp([GSAUC KNNAUC RFAUC ADTAUC])

%>>DOD
disp('Diagnostic odds ratio of transparent classifiers')
disp(['Decision Tree, ' 'Linear Discriminant, ' 'Logistic Regression, ' 'LinearSVM'])
disp([DTDOR LDDOR LRDOR LSDOR])

disp('Diagnostic odds ratio of Non-descriptive classifiers')
disp(['Gaussian SVM, ' 'KNN, ' 'Random Forest, ' 'AdaBoost decision tree'])
disp([GSDOR KNNDOR RFDOR ADTDOR])

%>>Sensitivity
disp('Sensitivity of transparent classifiers')
disp(['Decision Tree, ' 'Linear Discriminant, ' 'Logistic Regression, ' 'LinearSVM'])
disp([DTSensitivity LDSensitivity LRSensitivity LSSensitivity])

disp('Sensitivity of Non-descriptive classifiers')
disp(['Gaussian SVM, ' 'KNN, ' 'Random Forest, ' 'AdaBoost decision tree'])
disp([GSSensitivity KNNSensitivity RFSensitivity ADTSensitivity])

%>>Specificity
disp('Specificity of transparent classifiers')
disp(['Decision Tree, ' 'Linear Discriminant, ' 'Logistic Regression, ' 'LinearSVM'])
disp([DTSpecificity LDSpecificity LRSpecificity LSSpecificity])

disp('Specificity of Non-descriptive classifiers')
disp(['Gaussian SVM, ' 'KNN, ' 'Random Forest, ' 'AdaBoost decision tree'])
disp([GSSpecificity KNNSpecificity RFSpecificity ADTSpecificity])

%>>F1
disp('F1 of transparent classifiers')
disp(['Decision Tree, ' 'Linear Discriminant, ' 'Logistic Regression, ' 'LinearSVM'])
disp([DTF1 LDF1 LRF1 LSF1])

disp('F1 of Non-descriptive classifiers')
disp(['Gaussian SVM, ' 'KNN, ' 'Random Forest, ' 'AdaBoost decision tree'])
disp([GSF1 KNNF1 RFF1 ADTF1])

%>>Precision
disp('Precision of transparent classifiers')
disp(['Decision Tree, ' 'Linear Discriminant, ' 'Logistic Regression, ' 'LinearSVM'])
disp([DTPrecision LDPrecision LRPrecision LSPrecision])

disp('Precision of Non-descriptive classifiers')
disp(['Gaussian SVM, ' 'KNN, ' 'Random Forest, ' 'AdaBoost decision tree'])
disp([GSPrecision KNNPrecision RFPrecision ADTPrecision])

%>>
hold on
% plot(DTX,DTY,'-b')
% plot(LDX,LDY,'-r')
% plot(LRX,LRY,'-g')
% plot(LSX,LSY,'-m')
plot(RFX,RFY)
plot(GSX,GSY)
plot(DTX,DTY)
plot(ADTX,ADTY)
plot(KNNX,KNNY)
plot(LRX,LRY)
plot(LDX,LDY)
plot(LSX,LSY)

%legend('Decision Tree','Linear Discriminant','Logistic Regression','Linear Support Vector Machines')
legend('Random Forest','Gaussian SVM' ,'Decision Tree', 'Boosted trees','KNN','Logistic Regression','Linear Discriminant','Linear Support Vector Machines')
xlabel('False positive rate'); ylabel('True positive rate');
title('ROC Curves for different classifiers')
hold off