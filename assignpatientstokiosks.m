function assignpatientstokiosks(&patients, &kiosks)
	global randfn;
	nPatients = length(patients);
	nKiosks = 2;

	printf('\n\n');
	printf('---------------------------------------------------------------\n');
	printf('                      Waiting Line Rule                        \n');
	printf('---------------------------------------------------------------\n');
	printf('1. Round Robin\n');
	printf('2. Idle kiosk, otherwise first kiosk\n');
	printf('3. Random\n');
	printf('---------------------------------------------------------------\n');
	wlr = getinput('Waiting line rule number: ', @(str) any(strcmp(str, {'1', '2', '3'})), 'Invalid waiting line rule number.');

	for (iPatient = 1:nPatients)
		% Round robin
		if (strcmp(wlr, '1'))
			patients(iPatient).kioskNo = mod(iPatient + 1, nKiosks) + 1;

		% Idle kiosk, otherwise first kiosk
		elseif (strcmp(wlr, '2'))
			% default to first kiosk
			patients(iPatient).kioskNo = 1;
			for (iKiosk = 1:nKiosks)
				% if there are no patients in the kiosk OR the last patient in the kiosk is served before the current patient arrives, the kiosk will be idle
				if (isempty(kiosks(iKiosk).patientsNos) || patients(iPatient).arrivalTime > patients(kiosks(iKiosk).patientsNos(end)).serviceEndTime)
					patients(iPatient).kioskNo = iKiosk;
					break;
				end
			end

		% Random
		else
			patients(iPatient).kioskNo = randint(1, nKiosks);
		end

		% add patient number to the kiosk's list of patient numbers
		kiosks(patients(iPatient).kioskNo).patientsNos(end + 1) = iPatient;

		Kiosk = kiosks(patients(iPatient).kioskNo);

		for (iServiceTime = 1:length(Kiosk.serviceTimes))
			ServiceTime = Kiosk.serviceTimes(iServiceTime);
			% if the random number is in the range of the current service time's range then match it
			if (patients(iPatient).serviceTimeRn >= ServiceTime.range(1) && patients(iPatient).serviceTimeRn <= ServiceTime.range(2))
				patients(iPatient).serviceTime = ServiceTime.value;

				% if only the current patient is in the kiosk
				if (length(Kiosk.patientsNos) == 1)
					% there is no previous patient from the same kiosk thus the service begins when this patient arrives
					patients(iPatient).serviceBeginTime = patients(iPatient).arrivalTime;
				else
					% otherwise the service begins when the previous patient from the same kiosk's service ends
					iPrevKioskPatient = Kiosk.patientsNos(end - 1);
					patients(iPatient).serviceBeginTime = max(patients(iPatient).arrivalTime, patients(iPrevKioskPatient).serviceEndTime);
				end

				patients(iPatient).serviceEndTime = patients(iPatient).serviceBeginTime + patients(iPatient).serviceTime;
				patients(iPatient).waitingTime = patients(iPatient).serviceBeginTime - patients(iPatient).arrivalTime;
				break;
			end
		end
	end
end
