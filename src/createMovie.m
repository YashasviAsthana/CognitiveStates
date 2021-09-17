%% This script is created by Yashasvi Asthana for the
%% term project in CSE 510

function status = createMovie(data_mat,colToCord)
% Use this function to plot the data in 3D and save the movie

figure(1)
xlabel('x')
ylabel('y')
zlabel('z')

for i=1:size(data_mat,1) % change the range to see different trials
    tt = colToCord;
    d = max(normalize(data_mat(i,:),'scale'),1.e-5).*10;
    scatter3(tt(:,1),tt(:,2),tt(:,3));
    hold on
    scatter3(tt(:,1),tt(:,2),tt(:,3),d,'filled')
    hold off
    M(i) = getframe(1);
    clf(1);
end
v = VideoWriter("brainMovie.avi");
v.Quality = 95; % change quality
v.FrameRate = 10; % change frame rate
open(v);
writeVideo(v,M);
close(v);
status=1;
end

