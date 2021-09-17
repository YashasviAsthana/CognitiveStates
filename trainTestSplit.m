%% This script is created by Yashasvi Asthana
function [train_mat,test_mat] = trainTestSplit(data_mat,splitRatio)
%TRAINTESTSPLIT Summary of this function goes here
%   Detailed explanation goes here

trainSize = ceil(size(data_mat,1)*splitRatio);
train_mat = zeros(trainSize,size(data_mat,2));
test_mat = zeros(1-trainSize,size(data_mat,2));
total_train = 0;
total_test = 0;
for i=0:2
    temp_idx = data_mat(:,end)==i;
    catcount = sum(temp_idx);
    trainCount = ceil(catcount*splitRatio);
    testCount = catcount - trainCount;
    [a,order] = sort(temp_idx,'descend');
    temp_mat = data_mat(order,:);
    train_mat(total_train+1:total_train+trainCount,:) = temp_mat(1:trainCount,:);
    test_mat(total_test+1:total_test+testCount,:) = temp_mat(trainCount+1:trainCount+testCount,:);
    total_train = total_train + trainCount;
    total_test = total_test + testCount;
end


end

