% genrate random integer that is in [min, max] (both inclusive)
function x = randint(min, max)
  global randfn;
  if (~isset('randfn'))
    randfn = @rand;
  end

  if (~isset('min') || IsNaN(min) || IsInf(min))
    min = 0;
  end
  if (~isset('max') || IsNaN(max) || IsInf(max))
    max = 1;
  end

  min = floor(min);
  max = ceil(max);

  x = floor(randfn() * (max - min + 1)) + min;
end
