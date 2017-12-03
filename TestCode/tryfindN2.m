%%%% GOAL IS TO FIND OPTIMAL refN2

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
N2 = 0;      %  ''             layer 2
N3 = 3.15;
c = physconst('LightSpeed'); % speed of light

StoreN2 = [];
PowerStore = []
LambdaC = 650;
n2Base = 2.36;
basePower = 0;
for N2 = 1.6: +0.01: 3
    PowerSUM=0;
    disp((N2/3)*100);
            StoreN2 = [StoreN2 N2];

    for Lambda = 400: +1 : 1400
        
        
        %%%material parameters%%%
        
        %reflection coeffs - gamma
        r01 = (nAIR - N1)/(nAIR + N1);
        r12 = (N1 - N2)/(N1 + N2);
        r23 = (N2 - N3)/(N2 + N3); %
        r3S = (N3 - nSolar)/(N3 + nSolar); % to solar cell
        
        %transmission coeffs - tau
        t01 = 2*(nAIR)/(nAIR +N1);
        t12 = 2*(N1)/(N1 +N2);
        t23 = 2*(N2)/(N2 +N3);
        t3S = 2*(N3)/(N3 +nSolar);
        
        %%Q Matrix
        Q01 = (1/t01)*([1 r01; r01 1]);
        Q12 = (1/t12)*([1 r12; r12 1]);
        Q23 = (1/t23)*([1 r23; r23 1]);
        Q3S = (1/t3S)*([1 r3S; r3S 1]);
        
        %%%Design parameters%%%
        lambdaC = 650;  %nm centre wavelength
        Lthick = lambdaC/4; %
        
        %%Deltas
        Delta1 = (pi/2)*(Lambda/LambdaC);
        Delta2 = (pi/2)*(Lambda/LambdaC);
        Delta3 = (pi/2)*(Lambda/LambdaC);
        
        
        %%Transfer Matrix
        P1 = [exp(j*Delta1) 0 ; 0 exp(-j*Delta1)];
        P2 = [exp(j*Delta2) 0 ; 0 exp(-j*Delta2)];
        P3 = [exp(j*Delta3) 0 ; 0 exp(-j*Delta3)];
        
        
        T = Q01*P1*Q12*P2*Q23*P3*Q3S;
        
        
        Gamma = T(2,1)/T(1,1);
        Tau = 1/T(1,1);
        Reflectance = (abs(Gamma))^2;
        Trans = ((abs(Tau))^2)/(nAIR/nSolar);
        IRRAD = (6.16*10^15)/(((Lambda)^5)*(exp(2484/Lambda)-1));
        powerAtLambda = Trans * IRRAD;
        PowerSUM = [PowerSUM powerAtLambda];
    end
    Psum = sum(PowerSUM);
    PowerStore = [PowerStore Psum];
end

plot(StoreN2, PowerStore);
[x,y] = max(PowerStore);
hold on; % hold the plot for other curves
plot(StoreN2(y),x,'O')
title('N2 vs Power Production');
xlabel('N2 Value') ;% x-axis label
ylabel('Power') ;% y-axis label


