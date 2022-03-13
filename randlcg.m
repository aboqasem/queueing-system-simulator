% Linear Congruential Generator (LCG)
% LCGs have the form: Xₙ = (aXₙ₋₁ + c) mod m
% Where m is the modulus, 0 < m
% a is the multiplier, 0 < a < m
% c is the increment, 0 ≤ c < m
% X₀ is the seed (starting value), 0 ≤ X₀ < m
% Xₙ is the positive remainder when we divide (aXₙ₋₁ + c) by m, thus; 0 ≤ Xₙ < m.

function x = randlcg()
	% LCG_SEED is the starting value (X₀), LCG_PREV_X is Xₙ₋₁
	global LCG_SEED LCG_PREV_X;

	% no seed means n is currently 0
	if (~isset('LCG_SEED'))
		% random starting value
		LCG_SEED = rand();
		% X₀ is the seed
		x = LCG_SEED;

		LCG_PREV_X = x;
		return;
	end

	% Xₙ₋₁
	prevX = LCG_PREV_X;
	% randomly generated multiplier and increment
	a = rand(); c = rand();
	% modulus is 1 to make sure 0 ≤ Xₙ < 1
	m = 1;

	% Xₙ = (aXₙ₋₁ + c) mod m
	x = mod(a * prevX + c, m);

	LCG_PREV_X = x;
end
