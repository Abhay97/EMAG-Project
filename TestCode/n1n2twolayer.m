%%two layer brute force%%

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
StoreRefectance = [];

for Iteration = 0: +1 :3
    disp(Iteration);
    for N1 = n1Start: + StepSize : n1End
        disp(N1/3);
        for N2 = n2Start: + StepSize : n2End
            
            StoreN1 = [StoreN1  N1];
            StoreN2 = [StoreN2 N2];
            
            StorePWR = [];
            
            for Lambda = LambdaStart: +1 :LambdaEnd
                %reflection coeffs - gamma
                r01 = (nAIR - N1)/(nAIR + N1);
                r12 = (N1 - N2)/(N1 + N2);
                r2S = (N2 - nSolar)/(N2 + nSolar); %
                
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
                    disp(6)
                    StoreRefectance = [StoreRefectance Reflectance];
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
        StepSize = 0.01;
        
    end
    
    if Iteration == 3
        
        plot(LambdaStart:LambdaEnd, StoreRefectance);
        title('Reflectivity vs Wavelength');
        xlabel('Wavelength') ;% x-axis label
        ylabel('Reflectivity') ;% y-axis label
        
        a = num2str(sum(StorePWR));
        b= 'Total Power in Watts = ' ;
        h = msgbox(strcat(b,a) ,'DONE!');
    end
    
end
