%In God We Trust
%Designed and Implimented by: Reza Sadegh
%My emails:                                Sadeghi.2@wright.edu; Reza@knoesis.org
%Date:                                        8/1/2017
%(C) Copyright Reza Sadeghi

% Age distribution of MIMIC-III

% Input (Age.mat)
% PATIENTD-> subject-ID, DOB
% ADMISSIONS -> subject-ID, ADMITIME

% Output
% Age distribution plot
clc
clear
close all

load Age.mat

PatientsNumber=size(PATIENTS,1);
P=table2array(PATIENTS);
A=table2array(ADMISSIONS);
Age=zeros(1,PatientsNumber);
for i=1:PatientsNumber
    disp(i)
    Temp=find(P(i)==A(:,1));
    for j=1:numel(Temp)
        Temp(j)=floor(etime(datevec(datetime(A(Temp(j),2))),datevec(datetime(P(i,2))))/(60*60*24*365));
    end
    Age(i)=min(Temp);
end

% The age of patients who more than 89 where shifted to ages more than 300
% therefore we should shift them back as follows and put them in 90 group

Temp=find(Age>89);
Age(Temp)=90;

% categorizing
Temp=zeros(1,91);
for i=1:91
    Temp(i)=numel(find(MatchingAge==(i-1)));
end

bar(0:90,Temp)