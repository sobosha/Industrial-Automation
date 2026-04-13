
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



%% local search — improve by swapping
currentA = bestA;
currentB = bestB;
currentCmax = bestCmax;
improved = true;
iteration = 0;
while improved
    improved = false;
    iteration = iteration + 1;
    % type 1: swap two jobs within path A
    for i = 1:length(currentA)-1
        for j = i+1:length(currentA)
            newA = currentA;
            newA(i) = currentA(j);
            newA(j) = currentA(i);
            newCmax = computeCMAX(newA, currentB, P);
            if newCmax < currentCmax
                fprintf('  Swap in A: J%d <-> J%d, Cmax: %d -> %d\n', ...
                    currentA(i), currentA(j), currentCmax, newCmax);
                currentA = newA;
                currentCmax = newCmax;
                improved = true;
            end
        end
    end
    % type 2: swap two jobs within path B
    for i = 1:length(currentB)-1
        for j = i+1:length(currentB)
            newB = currentB;
            newB(i) = currentB(j);
            newB(j) = currentB(i);
            newCmax = computeCMAX(currentA, newB, P);
            if newCmax < currentCmax
                fprintf('  Swap in B: J%d <-> J%d, Cmax: %d -> %d\n', ...
                    currentB(i), currentB(j), currentCmax, newCmax);
                currentB = newB;
                currentCmax = newCmax;
                improved = true;
            end
        end
    end
    % type 3: move a job from path A to path B
    for i = 1:length(currentA)
        newA = currentA;
        newA(i) = [];
        newB = [currentB, currentA(i)];
        [~, idx] = sort(pathB_time(newB));
        newB = newB(idx);
        if ~isempty(newA)
            newCmax = computeCMAX(newA, newB, P);
            if newCmax < currentCmax
                fprintf('  Move J%d: A -> B, Cmax: %d -> %d\n', ...
                    currentA(i), currentCmax, newCmax);
                currentA = newA;
                currentB = newB;
                currentCmax = newCmax;
                improved = true;
            end
        end
    end
    % type 4: move a job from path B to path A
    for i = 1:length(currentB)
        newB = currentB;
        newB(i) = [];
        newA = [currentA, currentB(i)];
        [~, idx] = sort(pathA_time(newA));
        newA = newA(idx);
        if ~isempty(newB)
            newCmax = computeCMAX(newA, newB, P);
            if newCmax < currentCmax
                fprintf('  Move J%d: B -> A, Cmax: %d -> %d\n', ...
                    currentB(i), currentCmax, newCmax);
                currentA = newA;
                currentB = newB;
                currentCmax = newCmax;
                improved = true;
            end
        end
    end
end
fprintf('\n>>>local search: Cmax = %d\n', currentCmax);
fprintf('>>> Path A: '); fprintf('J%d ', currentA); fprintf('\n');
fprintf('>>> Path B: '); fprintf('J%d ', currentB); fprintf('\n');
finalA = currentA;
finalB = currentB;
finalCmax = currentCmax;



%% verification — try all permutations for best assignment
fprintf('\n trying all permutations for the best assignment\n');
fprintf('Path A has %d jobs: %d! = %d permutations\n', ...
    length(finalA), length(finalA), factorial(length(finalA)));
fprintf('Path B has %d jobs: %d! = %d permutations\n', ...
    length(finalB), length(finalB), factorial(length(finalB)));
fprintf('Total combinations: %d\n\n', ...
    factorial(length(finalA)) * factorial(length(finalB)));

[optCmax, optA, optB] = verifyOptimal(finalA, finalB, P);

fprintf('\n verified optimal Cmax = %d\n', optCmax);
fprintf('>>> Optimal Path A order: '); fprintf('J%d ', optA); fprintf('\n');
fprintf('>>> Optimal Path B order: '); fprintf('J%d ', optB); fprintf('\n');

if optCmax == finalCmax
    fprintf('\n***CONFIRMED***\n');
else
    fprintf('\n*** exist a better solution! ***\n');
    fprintf('*** Improvement: %d -> %d ***\n', finalCmax, optCmax);
end


