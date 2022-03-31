% each customer is a struct that contains:
% `interarrivalTimeRn`: random number generated for interarrival time
% `serviceTimeRn`: random number generated for service time
% `interarrivalTime`: interarrival time that is determined by the random number
% `arrivalTime`: arrival time of the customer, computed from the currept customer's interarrival time and previous customer's arrival time
% `kioskNo`: kiosk number that the customer is assigned to
% `serviceTime`: service time that is determined by the random number when the customer is assigned to a kiosk
% `serviceBeginTime`: service begin time, computed when the customer is assigned to a kiosk
% `serviceEndTime`: service end time, computed when the customer is assigned to a kiosk
% `waitingTime`: time in queue, computed when the customer is assigned to a kiosk
% example of customers: [
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
function customers = initcustomersdata(nCustomers, interarrivalTimes)
	global randfn;
	global RN_MULTIPLIER;

	for (iCustomer = 1:nCustomers)
		Customer = struct(...
			'interarrivalTimeRn', NaN,... % first customer does not have interarrival time, for other customers to be genrated below
			'serviceTimeRn', randint(1, RN_MULTIPLIER),...
			'interarrivalTime', NaN,... % to be determined below from the interarrival time random number
			'arrivalTime', 0,... % first customer arrives at time 0, for other customers to be computed below
			'kioskNo', NaN,... % to be determined when the customer is assigned to a kiosk later in the simulator
			'serviceTime', NaN,... % to be determined when the customer is assigned to a kiosk later in the simulator
			'serviceBeginTime', NaN,... % to be determined when the customer is assigned to a kiosk later in the simulator
			'serviceEndTime', NaN,... % to be determined when the customer is assigned to a kiosk later in the simulator
			'waitingTime', NaN,... % to be determined when the customer is assigned to a kiosk later in the simulator
		);
		% generate random number for interarrival time only if it is not the first customer
		if (iCustomer ~= 1)
			Customer.interarrivalTimeRn = randint(1, RN_MULTIPLIER);
		end

		customers(iCustomer) = Customer;
	end

	% determine interarrival and arrival times for customers
	for (iCustomer = 2:nCustomers) 
		for (iInterarrivalTime = 1:length(interarrivalTimes))
			InterarrivalTime = interarrivalTimes(iInterarrivalTime);
			% if the random number is in the range of the current interarrival time's range then match it
			if (customers(iCustomer).interarrivalTimeRn >= InterarrivalTime.range(1) && customers(iCustomer).interarrivalTimeRn <= InterarrivalTime.range(2))
				customers(iCustomer).interarrivalTime = InterarrivalTime.value;
				% compute arrival time from interarrival time and previous customer's arrival time
				customers(iCustomer).arrivalTime = customers(iCustomer - 1).arrivalTime + customers(iCustomer).interarrivalTime;
				break;
			end
		end
	end

	printf('\n\n');
	printf('Random Numbers for Inter-Arrival Time :    ');
	for (iCustomer = 2:nCustomers)
		printf(' %3d', customers(iCustomer).interarrivalTimeRn);
	end
	printf('\n');

	printf('Random Numbers for Service Time       :');
	for (iCustomer = 1:nCustomers)
		printf(' %3d', customers(iCustomer).serviceTimeRn);
	end
	printf('\n');
end
