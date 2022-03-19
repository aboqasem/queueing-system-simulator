function displaysimulationresults(patients, kiosks)
	nPatients = length(patients);
	nKiosks = length(kiosks);
	maxPrintKiosks = 4;

	for (iPatient = 1:nPatients)
		Patient = patients(iPatient);
		printf('\n\n');
		printf('Patient %d arrives at minute %d\n', iPatient, Patient.arrivalTime);
		printf('Patient %d is assigned to Kiosk %2d\n', iPatient, Patient.kioskNo);
		if (Patient.waitingTime ~= 0)
			printf('Patient %d waits in queue for %d minutes\n', iPatient, Patient.waitingTime);
		end
		printf('Patient %d gets service at minute %d\n', iPatient, Patient.serviceBeginTime);
		printf('Patient %d leaves at minute %d\n', iPatient, Patient.serviceEndTime);
	end

	printf('\n\n');
	printf('Simulation Results:\n');

	seperator = '--------------------------------------------------------------------------';
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
		printf('|                                                  |');
		for (iKiosk = 1:nKiosks)
			printf('         Kiosk %2d        |', iKiosk);
		end
		printf('                     |\n');

		printf(seperator);
	end

	printf('| Patient No | Interarrival T | Arrival T | Srvc T |');
	if (nKiosks <= maxPrintKiosks)
		for (iKiosk = 1:nKiosks)
			printf(' Srvc Begins | Srvc Ends |');
		end
	else
		printf(' Kiosk No | Srvc Begins | Srvc Ends |');
	end
	printf(' Waiting T | T Spent |\n');

	printf(seperator);

	for (iPatient = 1:nPatients)
		Patient = patients(iPatient);

		printf( '| %10d |', iPatient);

		if (iPatient == 1)
			printf(' %14s |', '');
		else
			printf(' %14d |', Patient.interarrivalTime);
		end

		printf(' %9d | %6d |', Patient.arrivalTime, Patient.serviceTime);

		if (nKiosks <= maxPrintKiosks)
			for (iKiosk = 1:nKiosks)
				Kiosk = kiosks(iKiosk);
				if (iKiosk == Patient.kioskNo)
					printf(' %11d | %9d |', Patient.serviceBeginTime, Patient.serviceEndTime);
				else
					printf(' %11s | %9s |', '', '');
				end
			end
		else
			printf(' %8d | %11d | %9d |', Patient.kioskNo, Patient.serviceBeginTime, Patient.serviceEndTime);
		end

		printf(' %9d | %7d |\n', Patient.waitingTime, Patient.timeSpent);
	end

	printf(seperator);

	printf('\n\n');
	printf('Simulation Results Evaluation:\n');
	printf('- Average waiting time                   : %5.2f minutes\n', mean([patients.waitingTime]));
	printf('- Average time spent                     : %5.2f minutes\n', mean([patients.timeSpent]));	
	for (iKiosk = 1:nKiosks)
		printf('- Average service time of Kiosk %2d       : %5.2f minutes\n', iKiosk, mean([patients(find([patients.kioskNo] == iKiosk)).serviceTime]));
	end
	printf('- Probabilty of patient waiting in queue : %5.2f %%\n', (length(find([patients.waitingTime] ~= 0)) / nPatients) * 100);
end
