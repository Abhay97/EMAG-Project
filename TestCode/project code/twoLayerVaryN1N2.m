%%%% GOAL IS TO find power production across every lambda given N2 from
%%%% previous

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
N2 = 2.62;      %  ''             layer 2
c = physconst('LightSpeed'); % speed of light

StoreT = [];
StoreN2 = [];
StoreGamma = [];
StoreTau = [];
StoreReflectance = [];
LambdaC = 650;
Lambda = 1;
StoreLambda = [];
StoreIRRAD  = [];
StoreTRANS = [];
StorePWR = [];
while Lambda <= 2500
    StoreLambda = [StoreLambda Lambda];
    
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
    Lthick = lambdaC/4; %

        %%Deltas
    Delta1 = (pi/2)*(Lambda/LambdaC);
    Delta2 = (pi/2)*(Lambda/LambdaC);


    %%Transfer Matrix
    P1 = [exp(j*Delta1) 0 ; 0 exp(-j*Delta1)];
    P2 = [exp(j*Delta2) 0 ; 0 exp(-j*Delta2)];
    
    T = Q01*P1*Q12*P2*Q2S;
    
    
    Gamma = T(2,1)/T(1,1);
    Tau = 1/T(1,1);
    Reflectance = (abs(Gamma))^2;
    
    StoreT = [StoreT T];
    StoreTau = [StoreTau Tau];
    StoreGamma  = [StoreGamma Gamma];
    StoreReflectance = [StoreReflectance Reflectance];
    Trans = ((abs(Tau))^2)/(nAIR/nSolar);
    StoreTRANS = [StoreTRANS Trans];
    IRRAD = (6.16*10^15)/(((Lambda)^5)*(exp(2484/Lambda)-1));
    StoreIRRAD = [StoreIRRAD IRRAD];
    Lambda = Lambda+1;
    Power = Trans * IRRAD;
    StorePWR = [StorePWR Power];
end



plot(StoreLambda, StoreReflectance);
title('Reflectivity vs Wavelength');
xlabel('Wavelength') ;% x-axis label
ylabel('Reflectivity') ;% y-axis label

a = num2str(sum(StorePWR));
b= 'Total Power in Watts = ' ;
h = msgbox(strcat(b,a) ,'DONE!');