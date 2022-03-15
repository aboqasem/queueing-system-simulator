function initrandfn()
	global randfn;

	printf('---------------------------------------------------------------\n');
	printf('               Random Number Generation Type                   \n');
	printf('---------------------------------------------------------------\n');
	printf('1. Linear Congruential Generator (LCG)\n');
	printf('2. Inversive Congruential Generator (ICG)\n');
	printf('---------------------------------------------------------------\n');
	randType = getinput('Generator type number: ', @(str) any(strcmp(str, {'1', '2'})), 'Invalid generator type number.');
	printf('\n\n');

	if (strcmp(randType, '1'))
		randfn = @randlcg;
	else
		randfn = @randicg;
	end
end
