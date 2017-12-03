%%SETUP%%
%close previous windows%
close all;
clc;
clear all;
%preset paramaters
nAIR = 1 ;    %refractive index of air
nSolar = 3.5;   % refractive index of solar cell
N1 = 0;    % refractive index layer 1
N2 = 0;      %  ''             layer 2
c = physconst('LightSpeed'); % speed of light
LambdaC = 650; %centre wavelength


%%for some reason, this isnt consistant

%%Storage Arrays%%
StoreN1 = [];
StoreN2 = [];
StoreTotalPower = [];
count = 0;
BaselinePower  = 0;
TOT = 200*200*2000;

for N1 = 1: +0.01 : 3
    for N2 = 1: +0.01: 3
        StoreN1 = [StoreN1  N1];
        StoreN2 = [StoreN2 N2];
        
        StoreT = [];
        StoreTau = [];
        StoreGamma  = [];
        StoreReflectance = [];
        StoreTRANS = [];
        StoreIRRAD = [];
        StorePWR = [];
        
        for Lambda = 200: +1 :2200
            %find total power across this spectrum at this n1 n2 setting
            
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
            count = count+1;
        end %goes to next wavelength
        if N1 == 1.4 & N2 == 2.62
            BaselinePower  = sum(StorePWR);
        end
        PowerSum = sum(StorePWR);
        StoreTotalPower = [StoreTotalPower PowerSum];
        %calcuate sums of all wavelength power here
        %Now n2 changes
        disp((count/TOT)*100);
        
    end
    
    %Now n1 changes
    %                                  
end

%%%baseline power%%%


StoreN1N2TP = [StoreN1 ; StoreN2; StoreTotalPower];
[maxX,maxY] = max(StoreTotalPower);
MaxPower=StoreTotalPower(maxY);

disp(MaxPower);
disp(BaselinePower);

%Export
csvwrite('csvlist.dat',StoreN1N2TP)