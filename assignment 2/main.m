
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

testA = [1, 2, 3, 4, 5];
testB = [6, 7, 8, 9, 10];
[testCmax, ~] = computeCMAX(testA, testB, P);
fprintf('\nTest: J1-J5 on Path A, J6-J10 on Path B → Cmax = %d\n', testCmax);

