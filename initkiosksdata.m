function kiosks = initkiosksdata(nKiosks, nServiceTimes)
	global randfn;

  for (iKiosk = 1:nKiosks)
      Kiosk = struct(...
          'serviceTimes', iKiosk:(nServiceTimes + iKiosk - 1),...
          'serviceTimesRanges', [],...
      );
      serviceTimesProbabilities = [];
      serviceTimesCdfs = [];

      for (i = 1:nServiceTimes)
          % 1 ≤ probability ≤ 100
          serviceTimesProbabilities(i) = (randfn() + 0.01) * 100;
      end
      sumServiceTimesProbabilities = sum(serviceTimesProbabilities);
      for (i = 1:nServiceTimes)
          serviceTimesProbabilities(i) = serviceTimesProbabilities(i) / sumServiceTimesProbabilities;
          serviceTimesCdfs(i) = sum(serviceTimesProbabilities(1:i));
          Kiosk.serviceTimesRanges(i, 1) = round(((serviceTimesCdfs(i) - serviceTimesProbabilities(i)) + 0.01) * 100);
          Kiosk.serviceTimesRanges(i, 2) = round(serviceTimesCdfs(i) * 100);
      end

      kiosks(iKiosk) = Kiosk;

      printf('\n\n');
      printf('            Kiosk %d Service Times Table             \n', iKiosk);
      printf('-----------------------------------------------------\n');
      printf('| Service Time | Probability | CDF    | Range       |\n');
      printf('-----------------------------------------------------\n');
      for (iServiceTime = 1:nServiceTimes)
          printf(...
              '|      %d       | %11.2f | %6.2f | %11s |\n',...
              Kiosk.serviceTimes(iServiceTime),... % Serice Time
              serviceTimesProbabilities(iServiceTime),... % Probability
              serviceTimesCdfs(iServiceTime),... % CDF
              sprintf('%3d - %3d', Kiosk.serviceTimesRanges(iServiceTime, 1), Kiosk.serviceTimesRanges(iServiceTime, 2))... % Range
          );
      end
      printf('-----------------------------------------------------\n');
  end
end
