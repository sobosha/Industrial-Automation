function [optCmax, optA, optB] = verifyOptimal(jobsA, jobsB, P)
% VERIFYOPTIMAL - Try ALL permutations to find the true optimal order
%
% For the given assignment (which jobs on A, which on B),
% try every possible order and find the absolute best Cmax.

    optCmax = inf;
    optA = jobsA;
    optB = jobsB;

    % Get all permutations of Path A jobs
    permsA = perms(jobsA);   % each row is one permutation
    permsB = perms(jobsB);

    nPermsA = size(permsA, 1);  % number of permutations of A
    nPermsB = size(permsB, 1);  % number of permutations of B

    totalChecked = 0;

    for i = 1:nPermsA
        for j = 1:nPermsB
            thisA = permsA(i, :);
            thisB = permsB(j, :);
            [thisCmax, ~] = computeCMAX(thisA, thisB, P);
            totalChecked = totalChecked + 1;

            if thisCmax < optCmax
                optCmax = thisCmax;
                optA = thisA;
                optB = thisB;
            end
        end
    end

    fprintf('Checked %d permutation combinations\n', totalChecked);
end
