
P = [5  3  6  8  4  12 12 5  3  2;% m1
     12 6  1  5  6  15 3  2  8  8;% m2
     1  20 2  5  7  11 12 2  5  4;% m3
     13 10 1  15 6  12 11 4  4  13;% m4
     2  6  2  1  5  13 2  7  18 3];%m5  

n = size(P , 2); %jobs
m = size(P , 1); %machines

%path a -> m1 -> m2 -> m5
%path b -> m2 -> m4 -> m5

pathA_time = P(1,:) + P(3,:);
pathB_time = P(2,:) + P(4,:);


fprintf('Job |  path A  |  path B  |  Faster Path\n');
fprintf('----|----------|----------|-------------\n');

for j = 1:n
    if pathA_time(j) <= pathB_time(j)
        faster = 'A';
    else
        faster = 'B';
    end
    fprintf('J%-2d |   %2d     |    %2d    |   %s\n', ...
        j, pathA_time(j), pathB_time(j), faster);
end





%% assign jobs to fastest path
jobsA = [];
jobsB = [];
for j = 1:n
    if pathA_time(j) <= pathB_time(j)
        jobsA = [jobsA, j];%path A faster
    else
        jobsB = [jobsB, j];%path B faster
    end
end



% sort jobs within each path by their path processing time(shortest first)
% this is SPT (Shortest Processing Time) rule
[~, idxA] = sort(pathA_time(jobsA));
jobsA = jobsA(idxA);
[~, idxB] = sort(pathB_time(jobsB));
jobsB = jobsB(idxB);
[cmax1, ~] = computeCMAX(jobsA, jobsB, P);
fprintf('Cmax = %d\n', cmax1);
bestCmax = cmax1;
bestA = jobsA;
bestB = jobsB;

