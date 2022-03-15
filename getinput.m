% Get user input and valdiate it with the validation predicate.
function str = getinput(message, validationPredicate, errorMessage)
	if (~isset('validationPredicate'))
		% accept any input by default
		validationPredicate = @(x) true;
	end
	if (~isset('errorMessage'))
		% default error message
		errorMessage = 'Invalid input.';
	end

	str = input(message, 's');
	while (~validationPredicate(str))
		printf('%s\n', errorMessage);
		str = input(message, 's');
	end
end
