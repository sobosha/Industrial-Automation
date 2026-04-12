function [Cmax, schedule] = computeCMAX(pathA_jobs, pathB_jobs, P)

    %proccess path a
    nA = length(pathA_jobs);%jobs in a
    finishM1 = zeros(1, nA);%finish time in m1
    finishM3 = zeros(1, nA);%finish time in m3
    
    for i = 1:nA
        job = pathA_jobs(i);
            % m1 is waiting to finish previuos jobs
        if i == 1
            finishM1(i) = P(1, job);%first job
        else
            finishM1(i) = finishM1(i-1) + P(1, job);%start after previous
        end
            % m3 must waiting to m1 job finish and also m3 previuos job finish
        if i == 1
            finishM3(i) = finishM1(i) + P(3, job);
        else
            startM3 = max(finishM1(i), finishM3(i-1));%take the later time
            finishM3(i) = startM3 + P(3, job);
        end
    end

    %process path b
    nB = length(pathB_jobs);
    finishM2 = zeros(1, nB);
    finishM4 = zeros(1, nB);
    for i = 1:nB
        job = pathB_jobs(i);
        % m2 is waiting to finish previuos jobs
        if i == 1
            finishM2(i) = P(2, job);
        else
            finishM2(i) = finishM2(i-1) + P(2, job);
        end
        % m4 must waiting to m1 job finish and also m3 previuos job finish
        if i == 1
            finishM4(i) = finishM2(i) + P(4, job);
        else
            startM4 = max(finishM2(i), finishM4(i-1));
            finishM4(i) = startM4 + P(4, job);
        end
    end

    allJobs = [];
    readyTimes = [];

    for i = 1:nA
        allJobs = [allJobs, pathA_jobs(i)];
        readyTimes = [readyTimes, finishM3(i)];
    end

    for i = 1:nB
        allJobs = [allJobs, pathB_jobs(i)];
        readyTimes = [readyTimes, finishM4(i)];
    end

    %sort by ready time(first come, first served on m5)
    [readyTimes, sortIdx] = sort(readyTimes);
    allJobs = allJobs(sortIdx);
    % process jobs on m5
    totalJobs = length(allJobs);
    finishM5 = zeros(1, totalJobs);

    for i = 1:totalJobs
        job = allJobs(i);
        if i == 1
            startM5 = readyTimes(i);%first job starts when it arrives
        else
            %must wait for: this job to be ready and previous job on m5 to finish
            startM5 = max(readyTimes(i), finishM5(i-1));
        end
        finishM5(i) = startM5 + P(5, job);
    end
    %Cmax = when the very last job finishes on m5
    Cmax = finishM5(end);
    %Save the schedule details
    schedule.pathA_jobs = pathA_jobs;
    schedule.pathB_jobs = pathB_jobs;
    schedule.M5_order = allJobs;
    schedule.finishM5 = finishM5;
end
