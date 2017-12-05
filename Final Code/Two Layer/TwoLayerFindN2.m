%%%% GOAL IS TO FIND minimal reflectance at various N2

%close previous windows%
close all;
clc;
clear all;

% UNITS
degrees = pi/180;
j = 1j;          %sets immaginary numbers as j


%paramaters
nAIR = 1 ;    %refractive index of air
nSolar = 3.5;   % refractive index of solar cell
N1 = 1.4;    % refractive index layer 1
N2 = 0.01;      %  ''             layer 2

StoreN2 = []; %storage array for N2
StoreReflectance = []; %storage array for reflectances
StorePower =[];

while N2 < 4.5 %loop structure for varying N2
    
    StoreN2 = [StoreN2 N2];
    
    %%%material parameters%%%
    
    %reflection coeffs - gamma
    r01 = (nAIR - N1)/(nAIR + N1);
    r12 = (N1 - N2)/(N1 + N2);
    r2S = (N2 - nSolar)/(N2 + nSolar); % to solar cell
    
    %transmission coeffs - tau
    t01 = 2*(nAIR)/(nAIR +N1);
    t12 = 2*(N1)/(N1 +N2);
    t2S = 2*(N2)/(N2 +nSolar);
    
    %%Q Matrix
    Q01 = (1/t01)*([1 r01; r01 1]);
    Q12 = (1/t12)*([1 r12; r12 1]);
    Q2S = (1/t2S)*([1 r2S; r2S 1]);
    
    %%%Design parameters%%%
    lambdaC = 650;  %nm centre wavelength
    Lthick = lambdaC/4; %layer thickness.
    
    %%Deltas
    Delta1 = (pi/2);
    Delta2 = (pi/2);
    
    
    P1 = [exp(j*Delta1) 0 ; 0 exp(-j*Delta1)];
    P2 = [exp(j*Delta2) 0 ; 0 exp(-j*Delta2)];
    
    %%Transfer Matrix
    T = Q01*P1*Q12*P2*Q2S;
    
    
    Gamma = T(2,1)/T(1,1);
    Tau = 1/T(1,1);
    Reflectance = (abs(Gamma))^2;
    Trans = ((abs(Tau))^2)/(nAIR/nSolar);
    
    
    StoreReflectance = [StoreReflectance Reflectance];
    
    N2 = N2+0.01; % increase N2 by 0.01
end

figure (1)
[MinX,MinY] = min(StoreReflectance);% finding the minimum reflectance, and the location of that in the array. Location of this value will match with that of the best N2 value.
plot(StoreN2, StoreReflectance);
title('optimal N2 at lambdaC  = 650');
xlabel('N2 Value') ;% x-axis label
ylabel('Reflectance') ;% y-axis label

minN2 = StoreN2(MinY);
a = num2str(minN2);
b= 'Minimum Reflectance found at N2 = ' ;

h = msgbox({strcat(b,a)  strcat('When N1 is kept at  +', num2str(N1))},'DONE!');
