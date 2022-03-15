% each patient is a struct that contains:
% `interarrivalTimeRn`: random number generated for interarrival time
% `serviceTimeRn`: random number generated for service time
% `interarrivalTime`: interarrival time that is determined by the random number
% `serviceTime`: service time that is determined by the random number
% example of patients: [
%   struct {
%     'interarrivalTimeRn': NaN,
%     'serviceTimeRn': 78,
%     'interarrivalTime': NaN,
%     'serviceTime': NaN,
%   },
%   struct {
%     'interarrivalTimeRn': 13,
%     'serviceTimeRn': 95,
%     'interarrivalTime': 1,
%     'serviceTime': NaN,
%   },
%   ...
% ]
function patients = initpatientsdata(nPatients, interarrivalTimes)
	global randfn;
	global RN_MULTIPLIER;

	for (iPatient = 1:nPatients)
		Patient = struct(...
			'interarrivalTimeRn', NaN,... % first patient does not have interarrival time
			'serviceTimeRn', round((randfn() + 0.01) * RN_MULTIPLIER),...
			'interarrivalTime', NaN,... % to be determined below
			'serviceTime', NaN,... % to be determined when the patient is assigned to a kiosk
		);
		% generate random number for interarrival time only if it is not the first patient
		if (iPatient ~= 1)
			Patient.interarrivalTimeRn = round((randfn() + 0.01) * RN_MULTIPLIER);
		end

		patients(iPatient) = Patient;
	end

	% determine interarrival times for patients
	for (iPatient = 2:nPatients) 
		for (iInterarrivalTime = 1:length(interarrivalTimes))
			InterarrivalTime = interarrivalTimes(iInterarrivalTime);
			% if the random number is in the range of the current interarrival time's range then match it
			if (patients(iPatient).interarrivalTimeRn >= InterarrivalTime.range(1) && patients(iPatient).interarrivalTimeRn <= InterarrivalTime.range(2))
				patients(iPatient).interarrivalTime = InterarrivalTime.value;
				break;
			end
		end
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
