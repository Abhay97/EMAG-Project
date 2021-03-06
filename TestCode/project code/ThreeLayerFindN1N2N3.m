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

n1Start = 1;
n1End = 3;
n2Start = 1;
n2End = 3;
n3Start = 1;
n3End = 3;
LambdaStart = 400;
LambdaEnd = 1400;
StepSize = 0.2;
Iteration = 0;
StoreRefectanceBEST = [];

for Iteration = 0: +1 :3
    disp(Iteration);
    for N1 = n1Start: + StepSize : n1End
        disp(N1/3);
        for N2 = n2Start: + StepSize : n2End
            for N3 = n3Start: + StepSize : n3End
                StoreN1 = [StoreN1  N1];
                StoreN2 = [StoreN2 N2];
                StoreN3 = [StoreN3 N3];
                
                StorePWR = [];
                
                for Lambda = LambdaStart: +1 :LambdaEnd
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
                    if Iteration == 3
                        StoreRefectanceBEST = [StoreRefectanceBEST Reflectance]
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
    end
    [lowResPower, Pos] = max(StoreTotalPower);
    LowResN1 = StoreN1(Pos);
    LowResN2 = StoreN2(Pos);
    LowResN3 = StoreN3(Pos);
    [highresPower, Pos] = max(StoreTotalPower);
    
    bN1 = StoreN1(Pos)
    bN2 = StoreN2(Pos)
    bN3 = StoreN3(Pos)
    BESTPower = StoreTotalPower(Pos)
    
    StoreN1 = [];
    StoreN2 = [];
    StoreN3 = [];
    StoreTotalPower = [];
    
    n1Start = LowResN1 - StepSize*2;
    n1End = LowResN1 + StepSize*2;
    n2Start =LowResN2 - StepSize*2;
    n2End = LowResN2 + StepSize*2;
    n3Start = LowResN3 - StepSize*2;
    n3End = LowResN3 + StepSize*2;
    
    %%change step sizes%%
    if StepSize == 0.3
        StepSize = 0.2;
    elseif StepSize == 0.2
        StepSize = 0.05;
    elseif StepSize == 0.05
        n1Start = LowResN1 - StepSize*1.5;
        n1End = LowResN1 + StepSize*1.5;
        n2Start =LowResN2 - StepSize*1.5;
        n2End = LowResN2 + StepSize*1.5;
        n3Start = LowResN3 - StepSize*1.5;
        n3End = LowResN3 + StepSize*1.5;
        StepSize = 0.01;
        
    end
    
    if Iteration == 3
        
        plot(LambdaStart:LambdaEnd, StoreRefectanceBEST);
        title('Reflectivity vs Wavelength');
        xlabel('Wavelength') ;% x-axis label
        ylabel('Reflectivity') ;% y-axis label
        
        a = num2str(sum(StorePWR));
        b= 'Total Power in Watts = ' ;
        h = msgbox(strcat(b,a) ,'DONE!');
    end
    
end
