%% This script is created by Yashasvi Asthana for the
%% term project in CSE 510
%% uncomment different sections for results
clearvars;
data_dir = './data/';
data_iter = dir(strcat(data_dir,'/*.mat'));
% using only one subject's data
for i = 1:1%length(data_iter)
    allData = load(strcat(data_dir,data_iter(i).name));
    data = allData.data;
    info = allData.info;
    meta = allData.meta;
end

%% collect fmri snapshots in a data frame (27 trials/sec, 2 snapshots/sec)
data_mat = [];
labels = [];
for i = 1:54
    if(info(i).firstStimulus=='P' && ~isempty(info(i).sentence))
        %get the frame when picture is shown label: 1
        data_mat = [data_mat;data{i}(1:8,:)];
        labels = [labels;repmat(1,size(data{i}(1:8,:),1),1)];
        %get the frame when sentence is shown label: 2
        data_mat = [data_mat;data{i}(17:24,:)];
        labels = [labels;repmat(2,size(data{i}(17:24,:),1),1)];
    elseif(info(i).firstStimulus=='S' && ~isempty(info(i).sentence))
        %get the frame when sentence is shown
        data_mat = [data_mat;data{i}(1:8,:)];
        labels = [labels;repmat(2,size(data{i}(1:8,:),1),1)];
        %get the frame when picture is shown
        data_mat = [data_mat;data{i}(17:24,:)];
        labels = [labels;repmat(1,size(data{i}(17:24,:),1),1)];
    elseif(isempty(info(i).sentence))
        %get the frames of fixation label: 0
        data_mat = [data_mat;data{i}(:,:)];
        labels = [labels;repmat(0,size(data{i}(:,:),1),1)];
        
    end
end


%% classification with all the features
% rng(1);
% data_mat = [data_mat,labels];
% splitRatio = 0.80;
% [train_mat,test_mat] = trainTestSplit(data_mat,splitRatio);

% svmModel = fitcecoc(train_mat(:,1:end-1),train_mat(:,end));
% train_pred = predict(svmModel,train_mat(:,1:end-1));
% Create confusion matrix
% train_ConfMat = confusionmat(train_mat(:,end),train_pred);
% figure;confusionchart(train_mat(:,end),train_pred);
% % Create classification matrix (rows should sum to 1)
% train_ClassMat = train_ConfMat./(meshgrid(countcats(categorical(train_mat(:,end))))');
% % mean group accuracy and std
% train_acc = mean(diag(train_ClassMat))
% train_std = std(diag(train_ClassMat))
% test_pred = predict(svmModel,test_mat(:,1:end-1));
% % Create confusion matrix
% test_ConfMat = confusionmat(test_mat(:,end),test_pred);
% figure;confusionchart(test_mat(:,end),test_pred);
% % Create classification matrix (rows should sum to 1)
% test_ClassMat = test_ConfMat./(meshgrid(countcats(categorical(test_mat(:,end))))');
% % mean group accuracy and std
% test_acc = mean(diag(test_ClassMat))
% test_std = std(diag(test_ClassMat))

% net = patternnet(20);
% target_mat = [data_mat(:,end)==0,data_mat(:,end)==1,data_mat(:,end)==2];
% net.divideParam.trainRatio = 0.7;
% net.divideParam.valRatio   = 0.15;
% net.divideParam.testRatio  = 0.15;
% [net,tr] = train(net,data_mat(:,1:end-1)',target_mat');

%% classification with features selection
% type 1-------------------------------------------------------
rankedFeatures = rankingfeat(data_mat,categorical(labels));
temp_data_mat = zeros(size(data_mat,1),2000);
for i = 1:2000
    temp_data_mat(:,i) = data_mat(:,rankedFeatures(i,1));
end
% % rankedROI = [convertCharsToStrings(meta.colToROI(rankedFeatures(:,1))),num2str(rankedFeatures(:,2))];
% % sumVR = zeros(24,1);
% % uniqueROI = unique(rankedROI(:,1),'stable');
% % for k = 1:24
% %     sumVR(k) = sum(str2double(rankedROI(rankedROI(:,1)==uniqueROI(k),2)));
% % end
% % [sumVR,order] = sort(sumVR,'descend');
% % uniqueROI = uniqueROI(order);
% % barh(categorical(uniqueROI),sumVR);
% % yticklabels(uniqueROI);
% type 1 end---------------------------------------------------


% type 2-------------------------------------------------------
% impROI = ["CALC","LIPL","LT","LTRIA","LOPER","LIPS","LDLPFC"];
% temp_data_mat = [];
% for i = 1:length(impROI)
%     for j =1:24
%         if(meta.rois(j).name==impROI(i))
%             temp_data_mat = [temp_data_mat,data_mat(:,meta.rois(j).columns)];
%         end
%     end
% end
% type 2 end---------------------------------------------------
%% classification using top features
rng(1);
data_mat = [temp_data_mat,labels];
splitRatio = 0.80;
[train_mat,test_mat] = trainTestSplit(data_mat,splitRatio);

% svmModel = fitcecoc(train_mat(:,1:end-1),train_mat(:,end));
% train_pred = predict(svmModel,train_mat(:,1:end-1));
% % Create confusion matrix
% train_ConfMat = confusionmat(train_mat(:,end),train_pred);
% figure;confusionchart(train_mat(:,end),train_pred);
% % Create classification matrix (rows should sum to 1)
% train_ClassMat = train_ConfMat./(meshgrid(countcats(categorical(train_mat(:,end))))');
% % mean group accuracy and std
% train_acc = mean(diag(train_ClassMat))
% train_std = std(diag(train_ClassMat))
% test_pred = predict(svmModel,test_mat(:,1:end-1));
% % Create confusion matrix
% test_ConfMat = confusionmat(test_mat(:,end),test_pred);
% figure;confusionchart(test_mat(:,end),test_pred);
% % Create classification matrix (rows should sum to 1)
% test_ClassMat = test_ConfMat./(meshgrid(countcats(categorical(test_mat(:,end))))');
% % mean group accuracy and std
% test_acc = mean(diag(test_ClassMat))
% test_std = std(diag(test_ClassMat))

net = patternnet(20);
target_mat = [data_mat(:,end)==0,data_mat(:,end)==1,data_mat(:,end)==2];
net.divideParam.trainRatio = 0.7;
net.divideParam.valRatio   = 0.15;
net.divideParam.testRatio  = 0.15;
[net,tr] = train(net,data_mat(:,1:end-1)',target_mat');


