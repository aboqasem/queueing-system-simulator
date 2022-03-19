function displaysimulationresults(patients)
	nPatients = length(patients);

	for (iPatient = 1:nPatients)
		Patient = patients(iPatient);
		printf('\n\n');
		printf('Patient %d arrives at minute %d\n', iPatient, Patient.arrivalTime);
		printf('Patient %d is assigned to Kiosk#%d\n', iPatient, Patient.kioskNo);
		if (Patient.waitingTime ~= 0)
			printf('Patient %d waits in queue for %d minutes\n', iPatient, Patient.waitingTime);
		end
		printf('Patient %d gets service at minute %d\n', iPatient, Patient.serviceBeginTime);
		printf('Patient %d leaves at minute %d\n', iPatient, Patient.serviceEndTime);
	end

	printf('\n\n');
	printf('------------------------------------------------------------------------------------------------------------------------------\n');
	printf('|                                                  |          Kiosk 1        |          Kiosk 2        |                     |\n');
	printf('------------------------------------------------------------------------------------------------------------------------------\n');
	printf('| Patient No | Interarrival T | Arrival T | Srvc T | Srvc Begins | Srvc Ends | Srvc Begins | Srvc Ends | Waiting T | T Spent |\n');
	printf('------------------------------------------------------------------------------------------------------------------------------\n');
	for (iPatient = 1:nPatients)
		Patient = patients(iPatient);

		printf( '| %10d |', iPatient);

		if (iPatient == 1)
			printf(' %14s |', '');
		else
			printf(' %14d |', Patient.interarrivalTime);
		end

		printf(' %9d | %6d |', Patient.arrivalTime, Patient.serviceTime);

		if (Patient.kioskNo == 1)
			printf(' %11d | %9d | %11s | %9s |', Patient.serviceBeginTime, Patient.serviceEndTime, '', '');
		else
			printf(' %11s | %9s | %11d | %9d |', '', '', Patient.serviceBeginTime, Patient.serviceEndTime);
		end

		printf(' %9d | %7d |\n', Patient.waitingTime, Patient.timeSpent);
	end
	printf('------------------------------------------------------------------------------------------------------------------------------\n');
end
