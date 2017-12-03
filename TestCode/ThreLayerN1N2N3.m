%%three layer brute force%%

%start with a transition size of +0.2 per N, find N1,N2,N3 with best power.
%When have that, go +/- 0.3 from those N1N2N3 values and lower resolution
%to 0.01?


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
N3 = 0;      %  ''             layer 2
c = physconst('LightSpeed'); % speed of light
LambdaC = 650; %centre wavelength


%%for some reason, this isnt consistant

%%Storage Arrays%%
StoreN1 = [];
StoreN2 = [];
StoreN3 = [];

StoreTotalPower = [];
count = 0;

for N1 = 1: +0.2 : 3
    disp(N1/3);
    for N2 = 1: +0.2: 3
        for N3 = 1:0.2 :3
            StoreN1 = [StoreN1  N1];
            StoreN2 = [StoreN2 N2];
            StoreN3 = [StoreN3 N3];
            
            StorePWR = [];
            
            for Lambda = 400: +1 :1400
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
                
                Lambda = Lambda+1;
                Power = Trans * IRRAD;
                StorePWR = [StorePWR Power];
                count = count+1;
            end %goes to next wavelength
            PowerSum = sum(StorePWR);
            StoreTotalPower = [StoreTotalPower PowerSum];
            
        end        
    end
    
    
    %Now n1 changes
    %
end


[lowResPower, Pos] = max(StoreTotalPower);
LowResN1 = StoreN1(Pos);
LowResN2 = StoreN2(Pos);
LowResN3 = StoreN3(Pos);

%%Storage Arrays%% - clearing the array
StoreN1 = [];
StoreN2 = [];
StoreN3 = [];

StoreTotalPower = [];
count = 0;

StartN1 = LowResN1 - 0.3;
StartN2 = LowResN2 - 0.3;
StartN3 = LowResN3 - 0.3;

EndN1 = LowResN1 + 0.3;
EndN2 = LowResN2 + 0.3;
EndN3 = LowResN3 + 0.3;


for N1 = StartN1: +0.05 : (EndN1)
    disp(N1/(EndN1));
    for N2 = StartN2: +0.05 : EndN2
        for N3 = StartN3: +0.05 : EndN3
            StoreN1 = [StoreN1  N1];
            StoreN2 = [StoreN2 N2];
            StoreN3 = [StoreN3 N3];
            
            StorePWR = [];
            
            for Lambda = 400: +1 :1400
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
                
                Lambda = Lambda+1;
                Power = Trans * IRRAD;
                StorePWR = [StorePWR Power];
                count = count+1;
            end %goes to next wavelength
            PowerSum = sum(StorePWR);
            StoreTotalPower = [StoreTotalPower PowerSum];
            
        end
        
    end
    
    %Now n1 changes
    %
end

[highresPower, Pos] = max(StoreTotalPower);
HighN1 = StoreN1(Pos)
HighN2 = StoreN2(Pos)
HighN3 = StoreN3(Pos)
HighPower = StoreTotalPower(Pos)
%%Storage Arrays%% - clearing the array
StoreN1 = [];
StoreN2 = [];
StoreN3 = [];

StoreTotalPower = [];
count = 0;

StartN1 = HighN1 - 0.06;
StartN2 = HighN2 - 0.06;
StartN3 = HighN3 - 0.06;

EndN1 = HighN1 + 0.06;
EndN2 = HighN2 + 0.06;
EndN3 = HighN3 + 0.06;


for N1 = StartN1: +0.01 : (EndN1)
    disp(N1/(EndN1));
    for N2 = StartN2: +0.01 : EndN2
        for N3 = StartN3: +0.01 : EndN3
            StoreN1 = [StoreN1  N1];
            StoreN2 = [StoreN2 N2];
            StoreN3 = [StoreN3 N3];
            
            StorePWR = [];
            
            for Lambda = 400: +1 :1400
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
                
                Lambda = Lambda+1;
                Power = Trans * IRRAD;
                StorePWR = [StorePWR Power];
                count = count+1;
            end %goes to next wavelength
            PowerSum = sum(StorePWR);
            StoreTotalPower = [StoreTotalPower PowerSum];
            
        end
        
    end
    
    %Now n1 changes
    %
end

[highresPower, Pos] = max(StoreTotalPower);
bN1 = StoreN1(Pos)
bN2 = StoreN2(Pos)
bN3 = StoreN3(Pos)
BESTPower = StoreTotalPower(Pos)

% UNITS 
degrees = pi/180; 
j = 1j;          %sets immaginary numbers as j 


%paramaters
nAIR = 1 ;    %refractive index of air
nSolar = 3.5;   % refractive index of solar cell
N1 = bN1;    % refractive index layer 1
N2 = bN2;      %  ''             layer 2
N3 = bN3;

c = physconst('LightSpeed'); % speed of light

StoreT = [];
StoreN2 = [];
StoreGamma = [];
StoreTau = [];
StoreReflectance = [];
LambdaC = 650;
Lambda = 400;
StoreLambda = [];
StoreIRRAD  = [];
StoreTRANS = [];
StorePWR = [];

%%this creates a reflectivity vs Wavelength graph with the best calculation


for Lambda = 400: +1 :1400
    StoreLambda = [StoreLambda Lambda];
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
    
    StoreT = [StoreT T];
    StoreTau = [StoreTau Tau];
    StoreGamma  = [StoreGamma Gamma];
    StoreReflectance = [StoreReflectance Reflectance];
    Trans = ((abs(Tau))^2)/(nAIR/nSolar);
    IRRAD = (6.16*10^15)/(((Lambda)^5)*(exp(2484/Lambda)-1));
    StoreIRRAD = [StoreIRRAD IRRAD];
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
