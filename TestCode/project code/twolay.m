%%%% GOAL IS TO FIND OPTIMAL refN2
close all; 
clc; 
clear all; 
 
% UNITS 
degrees = pi/180; 
j = 1j;  %sets immaginary number 

%paramaters
lambdaC = 650;%nm
refAIR = 1 ;%refractive index of air
nSolar = 3.5; % refractive index of solar cell
lambdaSTART = 200 ;% first value to intergrate from
lambdaEnd = 2200 ;% last value to ingrate to
numberLayers = 2;% 
refN1 = 1.4; % refractive index layer 1
refN2 = 0; %  ''             layer 2
%refN3 = 3.15; % not neededf for this computation
c = 3e8;
rn2=[]
refrac = []
STOREMIN = [refN2]
while refN2 < 3.5
    
    %reflection and transmission coeffs
    r0to1 = (refAIR - refN1)/(refAIR + refN1);
    r1to2 = (refN1 - refN2)/(refN1 + refN2);
    %r2to3 = (refN2 - refN3)/(refN2 + refN3)
    t0to1 = 2*(refAIR)/(refAIR +refN1);
    t1to2 = 2*(refN1)/(refN1 +refN2);
    %t2to3 = 2*(refN2)/(refN2 +refN3)

    %Layer thicknesses
    QLC = lambdaC/4; %nm Quarter of LambdaC
    d1 = QLC; %thicknesses
    d2 =  d1;
    %d3 = d1; % not needed yet

    %%Deltam %%%%% THIS IS ONLY AT LAMBDAC = 650nm - > gotta change this when
    %%varying wavelengts. 


    Delta1= pi/2;
    Delta2 = pi/2;
    % Delta3 = 


    %%%%% DYNAMIC MATRIX%% Pm
    P1 = [ exp((j)*(Delta1)) 0 ; 0 exp(-(j)*(Delta1))];
    P2 = [ exp((j)*(Delta2)) 0 ; 0 exp(-(j)*(Delta2))];
    % P3 = [ exp((j)*(Delta3)) 0 ; 0 exp(-(j)*(Delta3))]


    %%Q Matrix.

    Q01 = (1/t0to1)*([1 r0to1; r0to1 1]);
    Q12 = (1/t1to2)*([1 r1to2; r1to2 1]);
    %Q23 = (1/t1to2)*([1 r1to2; r1to2 1])


    %%transfer matrix
    T = (Q01)*(P1)*Q01*P2*Q12;

    sysREF = T(2,1)/T(1,1);
    sysTRANS = 1/T(1,1);
    R = abs(sysREF)^2;
    refrac = [refrac R];
    rn2=[rn2 refN2]
    [xM,yM] = min(refrac) % -> minimum refractive index value
    STOREMIN = [STOREMIN refN2+0.01]
    refN2=refN2+0.01;
    
end

plot(rn2, refrac)
title('optimal N2 at lambdaC  = 650')
xlabel('N2 Value') % x-axis label
ylabel('Refractivity') % y-axis label
minN2 = STOREMIN(yM)
a = num2str(minN2);
b= 'Minimum Reflectance found at N2 =' ;
h = msgbox(strcat(b,a) ,'DONE!')




