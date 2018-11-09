In this level, the waveform records of target patients is downloaded from the Matching subset of MIMIC-III (https://physionet.org). Then the inital one hour of heart rates described in terms of 12 statistical and signal-based features.

Please note that you should sign in physionet.org befor running the code. Also, this code has been run with sudo command on Ubunto.


Key files:

Name:WaveformCatching.m

Description: This file will downlaod all MIMIC-III waveform subset of matching with numerical output

Inputs: RECORDS-numerics, PureCCUWave.mat (T -> RowRECORDS_numerics column of CCUMortality.xlsx) 

Outputs: all waveforms of the target patients

Details: When WaveformCatching.m is executed, it asks for selecting a file. Which is RECORDS-numerics. It contains the name of waveform you intend to download (For instance: p00/p000020/p000020-2183-04-28-17-47n). Since the whole waveform MIMIC-III has volume more than 2 TB, it is wise decision to download only a subset of them.


---------------------------------------------------------------------------------------------------------------------------------

Name:

AnalysisWavesMortalityCCU.m

Description: Doing statistical analysis over pure files downlaod from MIMIC-III waveform subset of matching with numerical output

Inputs: RECORDS-numerics, PureCCUWave.mat (T -> RowRECORDS_numerics column of CCUMortality.xlsx), Mortality.mat (1 -> alive patients 0-> passed away patients)

Outputs: describing the waveform records of the target patients in the terms of 12 statistical and signal-based features
