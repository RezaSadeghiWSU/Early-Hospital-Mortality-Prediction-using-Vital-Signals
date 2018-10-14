%In God We Trust
%Designed and Implimented by: Reza Sadegh
%My emails:                                   Sadeghi.2@wright.edu; Reza@knoesis.org
%Date:                                            
%(C) Copyright Reza Sadeghi

clc
clear
close allt

load WaveformLabels.mat
%% finding the records of dead people in CCU
% finding records of the dead people in CCU
DeadCCU=find((DeathThisAdmission==1)+(PlaceCurrent=='CCU')==2);
% finding records of the alive people in CCU
AliveCCU=find((DeathThisAdmission==0)+(PlaceCurrent=='CCU')==2);

%% Staying only the latest signal of dead people who more than one signal are assigned to their death
Temp=ID(DeadCCU);
disp('Initial passed away people records:')
disp(length(Temp))
PureDeadCCU=DeadCCU;
for i=1:length(Temp)
    Temp2=find(Temp==Temp(i));
    if(length(Temp2)>1)
        PureDeadCCU(Temp2(find(Time(DeadCCU(Temp2))~=max(Time(DeadCCU(Temp2))))))=-1;
    end
end
PureDeadCCU(find(PureDeadCCU==-1))=[];

%% Save Final data in a table
RowRECORDS_numerics=[AliveCCU, DeadCCU]';
ID=ID(RowRECORDS_numerics)';
Mortality=[ones(length(AliveCCU),1);zeros(length(DeadCCU),1)];
%Mortality=categorical(Mortality,[0 1],{'Dead','Alive'});

AdmissionType(find(AdmissionType=='URGENT'))='EMERGENCY';
AdmissionType=AdmissionType(RowRECORDS_numerics)';

Gender=Gender(RowRECORDS_numerics)';
Temp=zeros(length(Gender),1);
for i=1:length(Gender)
    if(Gender(i)=='M')
        Temp(i)=1;
    end
end
Gender=Temp;

LengthOfStay=LengthOfStay(RowRECORDS_numerics)';
PlaceCurrent=PlaceCurrent(RowRECORDS_numerics)';
PlaceNext=PlaceNext(RowRECORDS_numerics)';
PlacePrevious=PlacePrevious(RowRECORDS_numerics)';
StatusCurrent=StatusCurrent(RowRECORDS_numerics)';
StatusNext=StatusNext(RowRECORDS_numerics)';

load MatchingAge.mat
load MatchingID.mat
Age=zeros(length(ID),1);
for i=1:length(ID)
    Age(i,1)=MatchingAge(find(MatchingID==ID(i)))';
end

T=table(RowRECORDS_numerics, ID, Mortality, AdmissionType, Age, Gender,LengthOfStay, PlaceCurrent, PlaceNext, PlacePrevious, StatusCurrent, StatusNext);
writetable(T,'CCUMortality.xlsx','Sheet',1)