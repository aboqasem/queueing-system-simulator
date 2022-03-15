function patients = initpatientsdata(nPatients)
	global randfn;
	global RN_MULTIPLIER;

	for (iPatient = 1:nPatients)
		Patient = struct(...
			'interarrivalTimeRn', NaN,...
			'serviceTimeRn', round((randfn() + 0.01) * RN_MULTIPLIER),...
		);
		if (iPatient ~= 1)
			Patient.interarrivalTimeRn = round((randfn() + 0.01) * RN_MULTIPLIER);
		end

		patients(iPatient) = Patient;
	end

	printf('\n\n');
	printf('Random Numbers for Inter-Arrival Time :    ');
	for (iPatient = 2:nPatients)
		printf(' %3d', patients(iPatient).interarrivalTimeRn);
	end
	printf('\n');

	printf('Random Numbers for Service Time       :');
	for (iPatient = 1:nPatients)
		printf(' %3d', patients(iPatient).serviceTimeRn);
	end
	printf('\n');
end
