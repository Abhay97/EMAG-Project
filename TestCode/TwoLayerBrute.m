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

n1Start = 1;
n1End = 3;
n2Start = 1;
n2End = 3;
LambdaStart = 400;
LambdaEnd = 1400;
StepSize = 0.2;
Iteration = 0;
StoreReflectanceBEST = [];

for Iteration = 0: +1 :3
    
    for N1 = 1: +StepSize : 3
        for N2 = 1: +StepSize: 3
            StoreN1 = [StoreN1  N1];
            StoreN2 = [StoreN2 N2];
            
            StoreT = [];
            StoreTau = [];
            StoreGamma  = [];
            StoreReflectance = [];
            StoreTRANS = [];
            StoreIRRAD = [];
            StorePWR = [];
            
            for Lambda = LambdaStart: +1 : LambdaEnd
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
                
                
                if Iteration == 3
                    StoreReflectanceBEST = [StoreReflectanceBEST Reflectance]
                end
                Trans = ((abs(Tau))^2)/(nAIR/nSolar);
                
                IRRAD = (6.16*10^15)/(((Lambda)^5)*(exp(2484/Lambda)-1));
                Lambda = Lambda+1;
                Power = Trans * IRRAD;
                StorePWR = [StorePWR Power];

                
            end %goes to next wavelength
            
            PowerSum = sum(StorePWR);
            StoreTotalPower = [StoreTotalPower PowerSum];
            

            
        end
        
        %Now n1 changes
        %
    end
    [lowResPower, Pos] = max(StoreTotalPower);
    LowResN1 = StoreN1(Pos);
    LowResN2 = StoreN2(Pos);
    [highresPower, Pos] = max(StoreTotalPower);
    
    bN1 = StoreN1(Pos)
    bN2 = StoreN2(Pos)
    BESTPower = StoreTotalPower(Pos)
    
    StoreN1 = [];
    StoreN2 = [];
    StoreTotalPower = [];
    
    n1Start = LowResN1 - StepSize*2;
    n1End = LowResN1 + StepSize*2;
    n2Start =LowResN2 - StepSize*2;
    n2End = LowResN2 + StepSize*2;
    
    
    %%change step sizes%%
    if StepSize == 0.2
        StepSize = 0.1;
    elseif StepSize == 0.1
        StepSize = 0.05;
    elseif StepSize == 0.05
        n1Start = LowResN1 - StepSize*1.5;
        n1End = LowResN1 + StepSize*1.5;
        n2Start =LowResN2 - StepSize*1.5;
        n2End = LowResN2 + StepSize*1.5;

        StepSize = 0.01;
        
    end
    
    if Iteration == 3
        
        plot(LambdaStart:LambdaEnd, StoreReflectanceBEST);
        title('Reflectivity vs Wavelength');
        xlabel('Wavelength') ;% x-axis label
        ylabel('Reflectivity') ;% y-axis label
        
        a = num2str(sum(StorePWR));
        b= 'Total Power in Watts = ' ;
        h = msgbox(strcat(b,a) ,'DONE!');
    end
end
