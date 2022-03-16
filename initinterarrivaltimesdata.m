% each interarrival time is a struct and contains:
% `value` which is the time in minutes
% `range` which is the range of random number that should be matched with the `value`
% example of interarrivalTimes: [
%   struct {
%     'value': 1,
%     'range': [1, 16],
%   },
%   struct {
%     'value': 2,
%     'range': [17, 48],
%   },
%   ...
% ]
function interarrivalTimes = initinterarrivaltimesdata(nInterarrivalTimes)
	global randfn;
	global RN_MULTIPLIER;

	% this should be `nInterarrivalTimes` random numbers that sum to 1
	interarrivalTimesProbabilities = [];
	% generate `nInterarrivalTimes` random numbers
	% example: [0.2 0.6]
	for (iInterarrivalTime = 1:nInterarrivalTimes)
		interarrivalTimesProbabilities(iInterarrivalTime) = randfn();
	end
	% normalize the random numbers to sum to 1 by dividing by the sum
	% example: [0.2 0.6] -> [0.2 0.6] / 0.8 = [0.25 0.75]
	interarrivalTimesProbabilities = interarrivalTimesProbabilities / sum(interarrivalTimesProbabilities);

	% this should be the cumulative sum of the probabilities
	interarrivalTimesCdfs = [];
	% example: [0.25 0.75] -> [0.25 1.00]
	for (iInterarrivalTime = 1:nInterarrivalTimes)
		interarrivalTimesCdfs(iInterarrivalTime) = sum(interarrivalTimesProbabilities(1:iInterarrivalTime));
	end

	% generate interarrival times values with random number ranges, assume the time is from 1 to `nInterarrivalTimes` minutes
	for (iInterarrivalTime = 1:nInterarrivalTimes)
		InterarrivalTime = struct(...
			'value', iInterarrivalTime,...
			'range', [...
				round(((interarrivalTimesCdfs(iInterarrivalTime) - interarrivalTimesProbabilities(iInterarrivalTime)) + 0.01) * RN_MULTIPLIER),... % from
				round(interarrivalTimesCdfs(iInterarrivalTime) * RN_MULTIPLIER),... % to
			],...
		);
		interarrivalTimes(iInterarrivalTime) = InterarrivalTime;
	end 

	printf('\n\n');
	printf('                 Inter-Arrival Times Table                 \n');
	printf('-----------------------------------------------------------\n');
	printf('| Inter-Arrival Time | Probability | CDF    | Range       |\n');
	printf('-----------------------------------------------------------\n');
	for (iInterarrivalTime = 1:nInterarrivalTimes)
		InterarrivalTime = interarrivalTimes(iInterarrivalTime);
		printf(...
			'|         %d          | %11.2f | %6.2f | %11s |\n',...
			InterarrivalTime.value,... % Inter-Arrival Time
			interarrivalTimesProbabilities(iInterarrivalTime),... % Probability
			interarrivalTimesCdfs(iInterarrivalTime),... % CDF
			sprintf('%3d - %3d', InterarrivalTime.range(1), InterarrivalTime.range(2))... % Range
		);
	end
	printf('-----------------------------------------------------------\n');
end
