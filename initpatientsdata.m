% each patient is a struct that contains:
% `interarrivalTimeRn`: random number generated for interarrival time
% `serviceTimeRn`: random number generated for service time
% `interarrivalTime`: interarrival time that is determined by the random number
% `arrivalTime`: arrival time of the patient, computed from the currept patient's interarrival time and previous patient's arrival time
% `kioskNo`: kiosk number that the patient is assigned to
% `serviceTime`: service time that is determined by the random number when the patient is assigned to a kiosk
% `serviceBeginTime`: service begin time, computed when the patient is assigned to a kiosk
% `serviceEndTime`: service end time, computed when the patient is assigned to a kiosk
% `waitingTime`: time in queue, computed when the patient is assigned to a kiosk
% example of patients: [
%   struct {
%     'interarrivalTimeRn': NaN,
%     'serviceTimeRn': 78,
%     'interarrivalTime': NaN,
%     'arrivalTime': 0,
%     'kioskNo': NaN
%     'serviceTime': NaN,
%     'serviceBeginTime': NaN,
%     'serviceEndTime': NaN
%     'waitingTime': NaN
%   },
%   struct {
%     'interarrivalTimeRn': 13,
%     'serviceTimeRn': 95,
%     'interarrivalTime': 1,
%     'arrivalTime': 1,
%     'kioskNo': NaN
%     'serviceTime': NaN,
%     'serviceBeginTime': NaN,
%     'serviceEndTime': NaN
%     'waitingTime': NaN
%   },
%   ...
% ]
function patients = initpatientsdata(nPatients, interarrivalTimes)
	global randfn;
	global RN_MULTIPLIER;

	for (iPatient = 1:nPatients)
		Patient = struct(...
			'interarrivalTimeRn', NaN,... % first patient does not have interarrival time, for other patients to be genrated below
			'serviceTimeRn', randint(1, RN_MULTIPLIER),...
			'interarrivalTime', NaN,... % to be determined below from the interarrival time random number
			'arrivalTime', 0,... % first patient arrives at time 0, for other patients to be computed below
			'kioskNo', NaN,... % to be determined when the patient is assigned to a kiosk later in the simulator
			'serviceTime', NaN,... % to be determined when the patient is assigned to a kiosk later in the simulator
			'serviceBeginTime', NaN,... % to be determined when the patient is assigned to a kiosk later in the simulator
			'serviceEndTime', NaN,... % to be determined when the patient is assigned to a kiosk later in the simulator
			'waitingTime', NaN,... % to be determined when the patient is assigned to a kiosk later in the simulator
		);
		% generate random number for interarrival time only if it is not the first patient
		if (iPatient ~= 1)
			Patient.interarrivalTimeRn = randint(1, RN_MULTIPLIER);
		end

		patients(iPatient) = Patient;
	end

	% determine interarrival and arrival times for patients
	for (iPatient = 2:nPatients) 
		for (iInterarrivalTime = 1:length(interarrivalTimes))
			InterarrivalTime = interarrivalTimes(iInterarrivalTime);
			% if the random number is in the range of the current interarrival time's range then match it
			if (patients(iPatient).interarrivalTimeRn >= InterarrivalTime.range(1) && patients(iPatient).interarrivalTimeRn <= InterarrivalTime.range(2))
				patients(iPatient).interarrivalTime = InterarrivalTime.value;
				% compute arrival time from interarrival time and previous patient's arrival time
				patients(iPatient).arrivalTime = patients(iPatient - 1).arrivalTime + patients(iPatient).interarrivalTime;
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
