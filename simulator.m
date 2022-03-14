% Random function to be picked by the user
global randfn;

printf('Welcome to the simulator!\n\n');

nPatients = str2num(getinput('Number of patients in this simulation: ', @(str) str2num(str) > 0));

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

[interarrivalTimes, interarrivalTimesRanges] = initinterarrivaltimesdata(5);
