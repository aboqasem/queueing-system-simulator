% Random function to be picked by the user
global randfn;
global RN_MULTIPLIER; RN_MULTIPLIER = 100;

printf('Welcome to the simulator!\n\n\n');

nPatients = str2num(getinput('Number of patients in this simulation: ', @(str) str2num(str) > 0));

initrandfn();

[interarrivalTimes, interarrivalTimesRanges] = initinterarrivaltimesdata(5);

kiosks = initkiosksdata(2, 5);
