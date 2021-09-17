%% This script is created by Yashasvi Asthana

function topfeatures = rankingfeat(TrainMat, LabelTrain)
% input: TrainMat - a NxM matrix that contains the full list of features
% of training data. N is the number of training samples and M is the
% dimension of the feature. So each row of this matrix is the face
% features of a single person.
%        LabelTrain - a Nx1 vector of the class labels of training data

% output: topfeatures - a Kx2 matrix that contains the information of the
% top 1% features of the highest variance ratio. K is the number of
% selected feature (K = ceil(M*0.01)). The first column of this matrix is
% the index of the selected features in the original feature list. So the
% range of topfeatures(:,1) is between 1 and M. The second column of this
% matrix is the variance ratio of the selected features.

%% code
M = size(TrainMat,2);
N = size(TrainMat,1);
%calculating number of top 1% features
K = M;
cat_count = countcats(LabelTrain);
number_of_classes = length(countcats(LabelTrain));% number of class labels
labels = unique(LabelTrain);
%we will use variance ratio for each feature to rate the features here
globalvariance = var(TrainMat);
varianceRatio = zeros(M,2);

mu = zeros(number_of_classes,M); % the matrix is row addressable based on the class
for i = 1:number_of_classes
    for j = 1:N
        if double(LabelTrain(j)) == i
            mu(i,:) = mu(i,:) + TrainMat(j,:);
        end
    end
    mu(i,:) = mu(i,:)./cat_count(i);
end
% finding intra-class variance
%S = zeros(M,number_of_classes);
%trainMat_class = [];
for i = 1:number_of_classes
    trainMat_class(1:cat_count(i),:) = TrainMat(double(LabelTrain) == i,:);
    
    S = var(trainMat_class)./cat_count(i);
end               
%calculating variance score
for i=1:M
    %column 1 has the variance score
    varianceRatio(i,1) = globalvariance(i)/S(i);
    %varianceRatio(i,1) = globalvariance(i)/cov(TrainMat(:,i));
    %column 2 has the real index value
    varianceRatio(i,2) = i;
end

%sorting features based on their variance ratio score
varianceRatio = sortrows(varianceRatio,1,'descend');

%taking top K features
topfeatures = [varianceRatio(1:K,2) int64(varianceRatio(1:K,1))];
end