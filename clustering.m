%% This script is created by Yashasvi Asthana for the
%% term project in CSE 510
%% uncomment different sections for results
clearvars;
data_dir = './data/';
data_iter = dir(strcat(data_dir,'/*.mat'));
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
rng('default');
% %% visualize 
% % createMovie(data_mat,meta.colToCoord);
% 
%% evaluating number of clusters based on all the features
% eva = evalclusters(data_mat(:,1:end-1),'kmeans','silhouette','KList',[2:20]);
% figure;
% hold on;
% ylabel('Silhouette Criterian Score');
% xlabel('K Value');
% plot(eva.InspectedK(2:end),eva.CriterionValues(2:end))
% hold off
%% evaluating number of clusters (hidden cognitive states) while fixation
data_mat = [data_mat,labels];
temp_idx = data_mat(:,4950)==0;
catcount = sum(temp_idx);
[a,order] = sort(temp_idx,'descend');
try_mat = data_mat(order,:);
eva = evalclusters(try_mat(1:catcount,1:end-1),'kmeans','silhouette','KList',[2:15]);
figure;
hold on;
ylabel('Silhouette Criterian Score');
xlabel('K Value');
plot(eva.InspectedK(1:end),eva.CriterionValues(1:end))
hold off
[idx,means] = kmeans(data_mat,3);
tt = meta.colToCoord;
for i=1:3
    d = max(normalize(means(i,:)),1.e-5).*20;
    figure;
    scatter3(tt(:,1),tt(:,2),tt(:,3));
    hold on
    scatter3(tt(:,1),tt(:,2),tt(:,3),d,'filled');
    hold off
end

%% evaluating number of clusters (hidden cognitive states) while seeing sentence
% data_mat = [data_mat,labels];
% temp_idx = data_mat(:,4950)==2;
% catcount = sum(temp_idx);
% [a,order] = sort(temp_idx,'descend');
% try_mat = data_mat(order,:);
% eva = evalclusters(try_mat(1:catcount,1:end-1),'kmeans','silhouette','KList',[2:15]);
% figure;
% hold on;
% ylabel('Silhouette Criterian Score');
% xlabel('K Value');
% plot(eva.InspectedK(1:end),eva.CriterionValues(1:end))
% hold off
%% evaluating number of clusters (hidden cognitive states) while seeing picture
% data_mat = [data_mat,labels];
% temp_idx = data_mat(:,4950)==1;
% catcount = sum(temp_idx);
% [a,order] = sort(temp_idx,'descend');
% try_mat = data_mat(order,:);
% eva = evalclusters(try_mat(1:catcount,1:end-1),'kmeans','silhouette','KList',[2:15]);
% figure;
% hold on;
% ylabel('Silhouette Criterian Score');
% xlabel('K Value');
% plot(eva.InspectedK(1:end),eva.CriterionValues(1:end))
% hold off
% 




%% clustering based on all the features
% %kmeans (2 clusters)
% 
% [idx,means] = kmeans(data_mat,2);
% tt = meta.colToCoord;
% d = max(normalize(means(1,:)),1.e-5).*20;
% figure;
% scatter3(tt(:,1),tt(:,2),tt(:,3));
% hold on
% scatter3(tt(:,1),tt(:,2),tt(:,3),d,'filled');
% hold off
% figure;
% d = max(normalize(means(2,:)),1.e-5).*20;
% scatter3(tt(:,1),tt(:,2),tt(:,3));
% hold on
% scatter3(tt(:,1),tt(:,2),tt(:,3),d,'filled');
% hold off
% 
%% feature ranking
%get top 1% features
%topFeatures = rankingfeat(data_mat,categorical(labels));
% 
% %% evaluating number of clusters based on top features
% new_data_mat = zeros(2800,50);
% for i = 1:size(topFeatures,1)
%     new_data_mat(:,i) = data_mat(:,topFeatures(i,1));
% end
% eva = evalclusters(new_data_mat,'kmeans','silhouette','KList',[2:30]);
% figure;
% hold on;
% ylabel('Silhouette Criterian Score');
% xlabel('K Value');
% plot(eva.InspectedK(2:end),eva.CriterionValues(2:end))
% hold off
% 
% %% clustering based on top 1% of the features
% %kmeans (2 clusters)
% 
% [idx,means] = kmeans(new_data_mat,2);
% tt = meta.colToCoord(topFeatures(:,1),:);
% tt1 = meta.colToCoord;
% d = max(normalize(means(1,:)),1.e-5).*50;
% figure;
% scatter3(tt1(:,1),tt1(:,2),tt1(:,3));
% hold on
% scatter3(tt(:,1),tt(:,2),tt(:,3),d,'filled');
% hold off
% d = max(normalize(means(2,:)),1.e-5).*50;
% figure;
% scatter3(tt1(:,1),tt1(:,2),tt1(:,3));
% hold on
% scatter3(tt(:,1),tt(:,2),tt(:,3),d,'filled');
% hold off
