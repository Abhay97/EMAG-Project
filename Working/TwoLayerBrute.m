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
N1 = 1;    % refractive index layer 1
N2 = 1;      %  ''             layer 2
c = physconst('LightSpeed'); % speed of light

LambdaC = 650;

%%Storage Arrays%%
StoreN1 = [];
StoreN2 = [];
StorePWR = [];
StoreTotalPower =[];

%loop params%%
n1Start = 1;
n1End = 3;
n2Start = 1;
n2End = 3;
StepSize = 0.4;
MaxIteration = 5;
LambdaStart = 400;
LambdaEnd = 1400;

count = 0;

for Iteration  = 0:+1:MaxIteration
    for N1 = n1Start: +StepSize: n1End
        for N2 = n2Start: +StepSize: n2End
            StorePWR = [];
            StoreN1 = [StoreN1  N1];
            StoreN2 = [StoreN2 N2];
            BestReflec = [];
            
            
            for Lambda = LambdaStart: +1 :LambdaEnd
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
                Trans = ((abs(Tau))^2)/(nAIR/nSolar);
                
                Reflectance = (abs(Gamma))^2;
                IRRAD = (6.16*10^15)/(((Lambda)^5)*(exp(2484/Lambda)-1));
                Power = Trans * IRRAD;
                StorePWR = [StorePWR Power];
                BestReflec = [BestReflec Reflectance];
            end %next wavelength
            PowerSum = sum(StorePWR);
            StoreTotalPower = [StoreTotalPower PowerSum];
        end
    end
    %%Extract power and N1,N2
    [lowResPower, Pos] = max(StoreTotalPower);
    LowResN1 = StoreN1(Pos);
    LowResN2 = StoreN2(Pos);
    [highresPower, Pos] = max(StoreTotalPower);
    bN1 = StoreN1(Pos);
    bN2 = StoreN2(Pos);
    BESTPower = StoreTotalPower(Pos);
    
    %reset arrays
    StoreN1 = [];
    StoreN2 = [];
    StoreTotalPower = [];
    
    %change iteration perameters
    n1Start = LowResN1 - StepSize*2;
    n1End = LowResN1 + StepSize*2;
    n2Start =LowResN2 - StepSize*2;
    n2End = LowResN2 + StepSize*2;
    
    if StepSize == 0.4
        StepSize = 0.2;
    elseif StepSize == 0.2
        StepSize = 0.1;
    elseif StepSize == 0.1
        StepSize = 0.05;
    elseif StepSize == 0.05
        StepSize = 0.03;
    elseif StepSize == 0.03
        StepSize = 0.01;
    end
    
end

plot(LambdaStart:LambdaEnd,BestReflec*100);
title('Reflectance vs Wavelength, Two Layer');
xlabel('Wavelength') ;% x-axis label
ylabel('Reflectance %') ;% y-axis label


FoundN1 =strcat('N1 = ',num2str(bN1));
FoundN2 =strcat('N2 = ',num2str(bN2));
FoundPWR = strcat('Total Power in Watts = ' ,num2str(sum(StorePWR)));


msg = msgbox({FoundN1 FoundN2 FoundPWR},'DONE!');
