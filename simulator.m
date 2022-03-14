% Random function to be picked by the user
global randfn;

printf('Welcome to the simulator!\n\n');

nPatients = str2num(getinput('Number of patients in this simulation: ', @(str) str2num(str) > 0));
printf('\n\n');

initrandfn();

[interarrivalTimes, interarrivalTimesRanges] = initinterarrivaltimesdata(5);
