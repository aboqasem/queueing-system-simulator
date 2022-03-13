% Random function to be picked by the user
global randfn;

printf('Welcome to the simulator!\n\n');

nPatients = str2num(getinput('Number of patients in this simulation: '));

printf('---------------------------------------------------------------\n');
printf('               Random Number Generation Type                   \n');
printf('---------------------------------------------------------------\n');
printf('1. Linear Congruential Generator (LCG)\n');
printf('2. Inversive Congruential Generator (ICG)\n');
printf('---------------------------------------------------------------\n');
randType = getinput('Generator type number: ', @(str) any(strcmp(str, {'1', '2'})), 'Invalid generator type number.');
if (strcmp(randType, '1'))
    randfn = @randlcg;
else
    randfn = @randicg;
end

printf('\n\n');

nInterarrivalTimes = 5;
interarrivalTimes = 1:nInterarrivalTimes;
interarrivalTimesProbabilities = []; interarrivalTimesCdfs = []; interarrivalTimesRanges = [];

for (i = 1:nInterarrivalTimes)
    % 1 ≤ probability ≤ 100
    interarrivalTimesProbabilities(i) = (randfn() + 0.01) * 100;
end
sumInterarrivalTimesProbabilities = sum(interarrivalTimesProbabilities);
for (i = 1:nInterarrivalTimes)
    interarrivalTimesProbabilities(i) = interarrivalTimesProbabilities(i) / sumInterarrivalTimesProbabilities;
    interarrivalTimesCdfs(i) = sum(interarrivalTimesProbabilities(1:i));
    interarrivalTimesRanges(i, 1) = round(((interarrivalTimesCdfs(i) - interarrivalTimesProbabilities(i)) + 0.01) * 100);
    interarrivalTimesRanges(i, 2) = round(interarrivalTimesCdfs(i) * 100);
end

printf('                 Inter-Arrival Times Table                 \n');
printf('-----------------------------------------------------------\n');
printf('| Inter-Arrival Time | Probability | CDF    | Range       |\n');
printf('-----------------------------------------------------------\n');
for (iInterarrivalTime = 1:nInterarrivalTimes)
    printf(...
        '|         %d          | %11.2f | %6.2f | %11s |\n',...
        interarrivalTimes(iInterarrivalTime),... % Inter-Arrival Time
        interarrivalTimesProbabilities(iInterarrivalTime),... % Probability
        interarrivalTimesCdfs(iInterarrivalTime),... % CDF
        sprintf('%3d - %3d', interarrivalTimesRanges(iInterarrivalTime, 1), interarrivalTimesRanges(iInterarrivalTime, 2))... % Range
    );
end
printf('-----------------------------------------------------------\n');
