In this level, the ID of target patients (the patients who stayed at CCU and their waveform signal in Matching subset is available) are provided through following files based on the ClinicalDatabase (tabular data).


File 1---------------------------------------------------------------------------------------

AgeDistribution.m

Description: Age distribution of MIMIC-III

% Input (Age.mat)

% PATIENTD-> subject-ID, DOB

% ADMISSIONS -> subject-ID, ADMITIME


% Output

% Age distribution plot, Age.mat

File 2---------------------------------------------------------------------------------------
AgeDistributionMaching.m

Description: Age distribution on maching subset of MIMIC-III

% Input

% P-> subject-ID, DOB, MatchingRECORDS

% Age -> Age of patients correspond to the subject-ID order


% Output

% Age distribution plot, MatchingAge.mat

File 3---------------------------------------------------------------------------------------
Place_Death_Discharge.m

Description: Place recognition and end point of patients on maching subset of MIMIC-III

% Input

% RECORDS-numerics, TransfersTable, Death extracted from Admission table


% Output (WaveformLabels.mat)

% DeathTihsAdmission, ID, PlaceCurrent, PlaceNext, PlacePrevious, StatusCurrent, StatusNext, Time

File 4---------------------------------------------------------------------------------------
FinalSegrigation.m

Description: Finding the records of people in CCU

% Input

WaveformLabels.mat


% Output (CCUMortality.xlsx)

% RowRECORDS_numerics, ID, Mortality, AdmissionType, Age, Gender,LengthOfStay, PlaceCurrent, PlaceNext, PlacePrevious, StatusCurrent, StatusNext
