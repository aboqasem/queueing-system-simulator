% Inversive Congruential Generator (ICG)
% ICGs have the form: Xₙ = (a(Xₙ₋₁)⁻¹ + c) mod m
% Where X₀ is the seed (starting value), 0 ≤ X₀ < m
% m is the modulus, 0 < m
% a is the multiplier, 0 < a < m
% c is the increment, 0 ≤ c < m
% Xₙ is the positive remainder when we divide (a(Xₙ₋₁)⁻¹ + c) by m, thus; 0 ≤ Xₙ < m.

function x = randicg()
	% the starting value (X₀)
	persistent seed;
	% Xₙ₋₁
	persistent prevX;

	% no seed means n is currently 0
	if (~isset('seed'))
		% random starting value
		seed = rand();
		% X₀ is the seed
		x = seed;

		prevX = x;
		return;
	end

	% randomly generated multiplier and increment
	a = rand(); c = rand();
	% modulus is 1 to make sure 0 ≤ Xₙ < 1
	m = 1;

	% Xₙ = (a(Xₙ₋₁)⁻¹ + c) mod m
	x = mod(a * (prevX ^ -1) + c, m);

	prevX = x;
end
