% Random function to be picked by the user
global randfn;
global RN_MULTIPLIER; RN_MULTIPLIER = 100;

printf('Welcome to Quik Queueing System Simulator!\n\n\n');

nCustomers = str2num(getinput('Number of customers in this simulation: ', @(str) all(isdigit(str)) && str2num(str) > 0));
nKiosks = str2num(getinput('Number of kiosks in this simulation: ', @(str) all(isdigit(str)) && str2num(str) > 0));

initrandfn();

interarrivalTimes = initinterarrivaltimesdata(5);

kiosks = initkiosksdata(nKiosks, 5);

customers = initcustomersdata(nCustomers, interarrivalTimes);

assigncustomerstokiosks(customers, kiosks);

displaysimulationresults(customers, kiosks);
