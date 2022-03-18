function displaysimulationresults(patients)
  nPatients = length(patients);

  printf('\n\n');
  printf('--------------------------------------------------------------------------------------------------------------------\n');
  printf('|                                                  |          Kiosk 1        |          Kiosk 2        |           |\n');
  printf('--------------------------------------------------------------------------------------------------------------------\n');
  printf('| Patient No | Interarrival T | Arrival T | Srvc T | Srvc Begins | Srvc Ends | Srvc Begins | Srvc Ends | Waiting T |\n');
  printf('--------------------------------------------------------------------------------------------------------------------\n');
  for (iPatient = 1:nPatients)
    Patient = patients(iPatient);

    printf( '| %10d |', iPatient);

    if (iPatient == 1)
      printf(' %14s |', '');
    else
      printf(' %14d |', Patient.interarrivalTime);
    end

    printf(' %9d | %6d |', Patient.arrivalTime, Patient.serviceTime);

    if (Patient.kioskNo == 1)
      printf(' %11d | %9d | %11s | %9s |', Patient.serviceBeginTime, Patient.serviceEndTime, '', '');
    else
      printf(' %11s | %9s | %11d | %9d |', '', '', Patient.serviceBeginTime, Patient.serviceEndTime);
    end

    printf(' %9d |\n', Patient.waitingTime);
  end
  printf('--------------------------------------------------------------------------------------------------------------------\n');
end
