function displaysimulationresults(customers, kiosks)
	nCustomers = length(customers);
	nKiosks = length(kiosks);
	maxPrintKiosks = 4;

	for (iCustomer = 1:nCustomers)
		Customer = customers(iCustomer);
		printf('\n\n');
		printf('Customer %d arrives at minute %d\n', iCustomer, Customer.arrivalTime);
		printf('Customer %d is assigned to Kiosk %2d\n', iCustomer, Customer.kioskNo);
		if (Customer.waitingTime ~= 0)
			printf('Customer %d waits in queue for %d minutes\n', iCustomer, Customer.waitingTime);
		end
		printf('Customer %d gets service at minute %d\n', iCustomer, Customer.serviceBeginTime);
		printf('Customer %d leaves at minute %d\n', iCustomer, Customer.serviceEndTime);
	end

	printf('\n\n');
	printf('Simulation Results:\n');

	seperator = '-----------------------------------------------------------------------';
	if (nKiosks <= maxPrintKiosks)
		for (iKiosk = 1:nKiosks)
			seperator = sprintf('%s--------------------------', seperator);
		end
	else
		seperator = sprintf('%s-------------------------------------', seperator);
	end
	seperator = sprintf('%s\n', seperator);

	printf(seperator);

	if (nKiosks <= maxPrintKiosks)
		printf('|                                               |');
		for (iKiosk = 1:nKiosks)
			printf('         Kiosk %2d        |', iKiosk);
		end
		printf('                     |\n');

		printf(seperator);
	end

	printf('| Cust No | Interarrival T | Arrival T | Srvc T |');
	if (nKiosks <= maxPrintKiosks)
		for (iKiosk = 1:nKiosks)
			printf(' Srvc Begins | Srvc Ends |');
		end
	else
		printf(' Kiosk No | Srvc Begins | Srvc Ends |');
	end
	printf(' Waiting T | T Spent |\n');

	printf(seperator);

	for (iCustomer = 1:nCustomers)
		Customer = customers(iCustomer);

		printf( '| %7d |', iCustomer);

		if (iCustomer == 1)
			printf(' %14s |', '');
		else
			printf(' %14d |', Customer.interarrivalTime);
		end

		printf(' %9d | %6d |', Customer.arrivalTime, Customer.serviceTime);

		if (nKiosks <= maxPrintKiosks)
			for (iKiosk = 1:nKiosks)
				Kiosk = kiosks(iKiosk);
				if (iKiosk == Customer.kioskNo)
					printf(' %11d | %9d |', Customer.serviceBeginTime, Customer.serviceEndTime);
				else
					printf(' %11s | %9s |', '', '');
				end
			end
		else
			printf(' %8d | %11d | %9d |', Customer.kioskNo, Customer.serviceBeginTime, Customer.serviceEndTime);
		end

		printf(' %9d | %7d |\n', Customer.waitingTime, Customer.timeSpent);
	end

	printf(seperator);

	printf('\n\n');
	printf('Simulation Results Evaluation:\n');
	printf('- Average waiting time                    : %5.2f minutes\n', mean([customers.waitingTime]));
	printf('- Average time spent                      : %5.2f minutes\n', mean([customers.timeSpent]));	
	for (iKiosk = 1:nKiosks)
		meanServiceTime = mean([customers(find([customers.kioskNo] == iKiosk)).serviceTime]);
		if (IsNaN(meanServiceTime))
			printf('- Average service time of Kiosk %2d        : N/A\n', iKiosk);
		else
			printf('- Average service time of Kiosk %2d        : %5.2f minutes\n', iKiosk, meanServiceTime);
		end
	end
	printf('- Probabilty of customer waiting in queue : %5.2f %%\n', (length(find([customers.waitingTime] ~= 0)) / nCustomers) * 100);
end
