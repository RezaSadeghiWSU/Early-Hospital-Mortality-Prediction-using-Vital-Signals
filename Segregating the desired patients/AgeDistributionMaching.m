%In God We Trust
%Designed and Implimented by: Reza Sadegh
%My emails:                                   Sadeghi.2@wright.edu; Reza@knoesis.org
%Date:                                            8/1/2017
%(C) Copyright Reza Sadeghi

% Age distribution on maching subset of MIMIC-III

% Input
% P-> subject-ID, DOB
% Age -> Age of patients correspond to the subject-ID order

% Output
% Age distribution plot

clc
clear
close all

[filename, pathname]=uigetfile({'*.*'},'Log file selector');
Path=[pathname filename];

Nrows = numel(textread(Path,'%1c%*[^\n]'));
fileID = fopen(Path,'r');
ID=zeros(1,Nrows);

i=0;
while ~feof(fileID)
    i=i+1;
    line = fgets(fileID);
    P=find(line=='p');
    Temp=line(P(2)+1:end-2);
    ID(i)=str2num(Temp);
end
fclose(fileID);

load('AgeResult.mat')


AgeMaching=zeros(1,Nrows);
for i=1:Nrows
    AgeMaching(i)=Age(find(P(:,1)==num2str(ID(i))));
end

Temp=zeros(1,91);
for i=1:91
    Temp(i)=numel(find(AgeMaching==(i-1)));
end

bar(0:90,Temp)