%In God We Trust
%Designed and Implimented by: Reza Sadegh
%My emails:                                   Sadeghi.2@wright.edu; Reza@knoesis.org
%Date:                                            10/07/2017
%(C) Copyright Reza Sadeghi

% Place recognition and end point of patients on maching subset of MIMIC-III

% Input
% RECORDS-numerics, TransfersTable, Death extracted from Admission table

% Output
% DeathTihsAdmission, ID, PlaceCurrent, PlaceNext, PlacePrevious,
% StatusCurrent, StatusNext, Time

clc
clear
close all

[filename, pathname]=uigetfile({'*.*'},'RECORDS-numerics');
Path=[pathname filename];

Nrows = numel(textread(Path,'%1c%*[^\n]'));
fileID = fopen(Path,'r');
ID=zeros(1,Nrows);
%Time=zeros(1,Nrows);

i=0;
while ~feof(fileID)
    i=i+1;
    line = fgets(fileID);
    P=find(line=='p');
    Hyphen=find(line=='-');
    n=find(line=='n');
    Temp=line(P(3)+1:Hyphen(1)-1);
    ID(i)=str2num(Temp);% the ID of certain patient
    Temp=line(Hyphen(1)+1:n-1);
    Time(i)=datetime(Temp,'InputFormat','yyyy-MM-dd-HH-mm');% The time of recorded signal for that patient
end
fclose(fileID);

load TransfersTable.mat
load Death.mat
load PatientsTable.mat
ID=int32(ID); % converting double to integer

for i=1:length(ID)
    Rows=find(TRANSFERS.SUBJECT_ID==ID(i));% finding all records of certain patients
    [EventTime, Order]=sort(TRANSFERS.INTIME(Rows));% order them based on time
    Temp=find((Time(i)>=datetime(EventTime,'InputFormat','yyyy-MM-dd HH:mm:ss'))+(Time(i)<=datetime(TRANSFERS.OUTTIME(Rows(Order)),'InputFormat','yyyy-MM-dd HH:mm:ss'))+(etime((datevec(datetime(TRANSFERS.OUTTIME(Rows(Order))))),datevec(Time(i)))>0)==3);% find the record associated with the waveform: 1-> be between starting and ending point 2-> have lenght more than 0 second
    if (isempty(Temp))
        PlacePrevious(i)='Noise';
        PlaceCurrent(i)='Noise';
        PlaceNext(i)='Noise';
        StatusCurrent(i)='Noise';
        StatusNext(i)='Noise';
        LengthOfStay(i)=-1;%-1 length means noise file
        AdmissionType(i)='Noise';
        Gender(i)='Noise';
        DeathThisAdmission(i)=2;%2 means noise file
        continue;
    end
    if (length(Temp)>1)
        disp('Duplicate item in transfer table')
        disp(TRANSFERS(Rows(Temp),:))
        Temp=Temp(1);
    end
    PlacePrevious(i)=TRANSFERS.PREV_CAREUNIT(Rows(Order(Temp)));%finding the privous place of patients
    
    PlaceCurrent(i)=TRANSFERS.CURR_CAREUNIT(Rows(Order(Temp)));% finding the current place
    
    PlaceNext(i)=TRANSFERS.CURR_CAREUNIT(Rows(Order(Temp+1)));% finding the next place
    
    StatusCurrent(i)=TRANSFERS.EVENTTYPE(Rows(Order(Temp)));% finding the current status
    
    StatusNext(i)=TRANSFERS.EVENTTYPE(Rows(Order(Temp+1)));% finding the next status
    
    LengthOfStay(i)=TRANSFERS.LOS(Rows(Temp));% finding the duration of stay in this section

    Rows=find(Death.SUBJECT_ID==ID(i));%Death time if it has been occured
    Temp=find((datetime(Death.ADMITTIME(Rows),'InputFormat','yyyy-MM-dd HH:mm:ss')<=Time(i))+(datetime(Death.DISCHTIME(Rows),'InputFormat','yyyy-MM-dd HH:mm:ss')>=Time(i))==2);
    if (isempty(Temp))% The starting time of waveform for this patient is not in the range of defined ranges in the Admit table for this patient
        PlacePrevious(i)='Noise';
        PlaceCurrent(i)='Noise';
        PlaceNext(i)='Noise';
        StatusCurrent(i)='Noise';
        StatusNext(i)='Noise';
        LengthOfStay(i)=-1;%-1 length means noise file
        AdmissionType(i)='Noise';
        Gender(i)='Noise';
        DeathThisAdmission(i)=2;%2 means noise file
        continue;
    end
    
    DeathTime=datetime(Death.DEATHTIME(Rows(Temp)),'InputFormat','yyyy-MM-dd HH:mm:ss');
    if (isnat(DeathTime))
        DeathThisAdmission(i)=0;% 1-> death, 0-> no death, 2-> noise
    else
        DeathThisAdmission(i)=1;% 1-> death, 0-> no death, 2-> noise
    end
    
    AdmissionType(i)=Death.ADMISSION_TYPE(Rows(Temp));
        
    Gender(i)=PATIENTS.GENDER(find(PATIENTS.SUBJECT_ID==ID(i)));
end

save('WaveformLabels.mat','DeathThisAdmission','AdmissionType','Gender','ID','LengthOfStay','PlaceCurrent','PlaceNext','PlacePrevious','StatusCurrent','StatusNext','Time');