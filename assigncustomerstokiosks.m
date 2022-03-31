function assigncustomerstokiosks(&customers, &kiosks)
	global randfn;
	nCustomers = length(customers);
	nKiosks = length(kiosks);

	printf('\n\n');
	printf('---------------------------------------------------------------\n');
	printf('                      Waiting Line Rule                        \n');
	printf('---------------------------------------------------------------\n');
	printf('1. Round Robin\n');
	printf('2. Idle kiosk, otherwise first kiosk\n');
	printf('3. Random\n');
	printf('---------------------------------------------------------------\n');
	wlr = getinput('Waiting line rule number: ', @(str) any(strcmp(str, {'1', '2', '3'})), 'Invalid waiting line rule number.');

	for (iCustomer = 1:nCustomers)
		% Round robin
		if (strcmp(wlr, '1'))
			customers(iCustomer).kioskNo = mod(iCustomer - 1, nKiosks) + 1;

		% Idle kiosk, otherwise first kiosk
		elseif (strcmp(wlr, '2'))
			% default to first kiosk
			customers(iCustomer).kioskNo = 1;
			for (iKiosk = 1:nKiosks)
				% if there are no customers in the kiosk OR the last customer in the kiosk is served before the current customer arrives, the kiosk will be idle
				if (isempty(kiosks(iKiosk).customersNos) || customers(iCustomer).arrivalTime > customers(kiosks(iKiosk).customersNos(end)).serviceEndTime)
					customers(iCustomer).kioskNo = iKiosk;
					break;
				end
			end

		% Random
		else
			customers(iCustomer).kioskNo = randint(1, nKiosks);
		end

		% add customer number to the kiosk's list of customer numbers
		kiosks(customers(iCustomer).kioskNo).customersNos(end + 1) = iCustomer;

		Kiosk = kiosks(customers(iCustomer).kioskNo);

		for (iServiceTime = 1:length(Kiosk.serviceTimes))
			ServiceTime = Kiosk.serviceTimes(iServiceTime);
			% if the random number is in the range of the current service time's range then match it
			if (customers(iCustomer).serviceTimeRn >= ServiceTime.range(1) && customers(iCustomer).serviceTimeRn <= ServiceTime.range(2))
				customers(iCustomer).serviceTime = ServiceTime.value;

				% if only the current customer is in the kiosk
				if (length(Kiosk.customersNos) == 1)
					% there is no previous customer from the same kiosk thus the service begins when this customer arrives
					customers(iCustomer).serviceBeginTime = customers(iCustomer).arrivalTime;
				else
					% otherwise the service begins when the previous customer from the same kiosk's service ends
					iPrevKioskCustomer = Kiosk.customersNos(end - 1);
					customers(iCustomer).serviceBeginTime = max(customers(iCustomer).arrivalTime, customers(iPrevKioskCustomer).serviceEndTime);
				end

				customers(iCustomer).serviceEndTime = customers(iCustomer).serviceBeginTime + customers(iCustomer).serviceTime;
				customers(iCustomer).waitingTime = customers(iCustomer).serviceBeginTime - customers(iCustomer).arrivalTime;
				customers(iCustomer).timeSpent = customers(iCustomer).serviceEndTime - customers(iCustomer).arrivalTime;
				break;
			end
		end
	end
end
