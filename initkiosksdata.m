% each kiosk is a struct and contains:
% `serviceTimes` which is a struct that contains:
%   `value` which is time in minutes
%   `range` which is the range of random number that should be matched with the `value`
% `customersNos` which is an array of indices of customers that are served by this kiosk
% example of kiosks: [
%   struct {
%     'serviceTimes': [
%       struct {
%         'value': 1,
%         'range': [1, 3],
%       },
%       struct {
%         'value': 2,
%         'range': [4, 20],
%       },
%       ...
%     ],
%     'customersNos': [],
%   },
%   ...
% ]
function kiosks = initkiosksdata(nKiosks, nServiceTimes)
	global randfn;
	global RN_MULTIPLIER;

	% initialize 2 kiosks
	for (iKiosk = 1:nKiosks)
		Kiosk = struct(...
			'serviceTimes', [],...
			'customersNos', [],...
		);

		% this should be `nServiceTimes` random numbers that sum to 1
		serviceTimesProbabilities = [];
		% generate `nServiceTimes` random numbers
		% example: [0.2 0.6]
		for (iServiceTime = 1:nServiceTimes)
			serviceTimesProbabilities(iServiceTime) = randfn();
		end
		% normalize the random numbers to sum to 1 by dividing by the sum
		% example: [0.2 0.6] -> [0.2 0.6] / 0.8 = [0.25 0.75]
		serviceTimesProbabilities = serviceTimesProbabilities / sum(serviceTimesProbabilities);

		% this should be the cumulative sum of the probabilities
		serviceTimesCdfs = [];
		% example: [0.25 0.75] -> [0.25 1.00]
		for (iServiceTime = 1:nServiceTimes)
			serviceTimesCdfs(iServiceTime) = sum(serviceTimesProbabilities(1:iServiceTime));
		end

		% generate the kiosk's service times values with random number ranges
		% assume the time is from 1 + ((`iKiosk` - 1) mod 4) to `nServiceTimes` + ((`iKiosk` - 1) mod 4) minutes
		% we use mod 4 to make sure kiosks times do not differ too much from each other (max difference is 4 minutes)
		for (iServiceTime = 1:nServiceTimes)
			ServiceTime = struct(...
				'value', mod(iKiosk - 1, 4) + iServiceTime,...
				'range', [...
					round(((serviceTimesCdfs(iServiceTime) - serviceTimesProbabilities(iServiceTime)) + 0.01) * RN_MULTIPLIER),...
					round(serviceTimesCdfs(iServiceTime) * RN_MULTIPLIER),...
				],...
			);

			Kiosk.serviceTimes(iServiceTime) = ServiceTime;
		end
	
		kiosks(iKiosk) = Kiosk;
	
		printf('\n\n');
		printf('            Kiosk %d Service Times Table             \n', iKiosk);
		printf('-----------------------------------------------------\n');
		printf('| Service Time | Probability | CDF    | Range       |\n');
		printf('-----------------------------------------------------\n');
		for (iServiceTime = 1:nServiceTimes)
			printf(...
				'|      %2d      | %11.2f | %6.2f | %11s |\n',...
				Kiosk.serviceTimes(iServiceTime).value,... % Service Time
				serviceTimesProbabilities(iServiceTime),... % Probability
				serviceTimesCdfs(iServiceTime),... % CDF
				sprintf('%3d - %3d', Kiosk.serviceTimes(iServiceTime).range(1), Kiosk.serviceTimes(iServiceTime).range(2))... % Range
			);
		end
		printf('-----------------------------------------------------\n');
	end
end
