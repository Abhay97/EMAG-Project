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

LambdaC = 650; % centre wavelength

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
LambdaStart = 200;
LambdaEnd = 2200;

count = 0;

% user prompt to select lambda range%
prompt={'Enter a value of begining Lambda'};
name = 'LambdaStart Value';
defaultans = {'200'};
options.Interpreter = 'tex';
answer = inputdlg(prompt,name,[1 40],defaultans,options);

LambdaStart = str2double(cell2mat(answer))

prompt={'Enter a value of ending Lambda'};
name = 'LambdaEnd Value';
defaultans = {'2200'};
options.Interpreter = 'tex';
answer = inputdlg(prompt,name,[1 40],defaultans,options);
LambdaEnd = str2double(cell2mat(answer))

for Iteration  = 0:+1:MaxIteration %loop structure for for multiple iterations
    
    for N1 = n1Start: +StepSize: n1End %loop structure for changing N1 values
        for N2 = n2Start: +StepSize: n2End %loop structure for changing N1 values
            StorePWR = []; %storage array for power
            StoreN1 = [StoreN1  N1]; %adding N1 to array
            StoreN2 = [StoreN2 N2]; %adding N1 to array
            BestReflec = []; %storage array for holding reflectance values
            
            
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
                Lthick = lambdaC/4; %quarter wavelength.
                
                %%Deltas
                Delta1 = (pi/2)*(Lambda/LambdaC);
                Delta2 = (pi/2)*(Lambda/LambdaC);
                
                
                P1 = [exp(j*Delta1) 0 ; 0 exp(-j*Delta1)];
                P2 = [exp(j*Delta2) 0 ; 0 exp(-j*Delta2)];
                %%Transfer Matrix
                
                T = Q01*P1*Q12*P2*Q2S;
                
                % calculating values from the transfer matrix
                
                Gamma = T(2,1)/T(1,1);
                Tau = 1/T(1,1);
                Trans = ((abs(Tau))^2)/(nAIR/nSolar);
                
                Reflectance = (abs(Gamma))^2;
                IRRAD = (6.16*10^15)/(((Lambda)^5)*(exp(2484/Lambda)-1));
                
                Power = Trans * IRRAD; %calculating power
                StorePWR = [StorePWR Power]; %storing this power in the storage array to be extracted later. 
                BestReflec = [BestReflec Reflectance];%storing reflectance in the storage array to be extracted later
            end %next wavelength
            PowerSum = sum(StorePWR); %total power
            StoreTotalPower = [StoreTotalPower PowerSum]; %storing total power in array to look at later. 
        end %next N2
    end %NEXT N1
    
    %%Extract power and N1,N2 from this iteration
    [lowResPower, Pos] = max(StoreTotalPower);
    LowResN1 = StoreN1(Pos);%best n1 in this range
    LowResN2 = StoreN2(Pos); %best n2 in this range
    [highresPower, Pos] = max(StoreTotalPower);
    bN1 = StoreN1(Pos); %value of best N1
    bN2 = StoreN2(Pos); %value for best N2
    BESTPower = StoreTotalPower(Pos);
    
    %reset arrays for next iteration
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

plot(LambdaStart:LambdaEnd,BestReflec*100); %plotting reflectance vs wavelengths
title('Reflectivity vs Wavelength, Two Layer');
xlabel('Wavelength') ;% x-axis label
ylabel('Reflectivity %') ;% y-axis label


FoundN1 =strcat('N1 = ',num2str(bN1));
FoundN2 =strcat('N2 = ',num2str(bN2));
FoundPWR = strcat('Total Power in Watts = ' ,num2str(sum(StorePWR)));

a = num2str(sum(StorePWR));
b= 'Total Power in Watts = ' ;

msg = msgbox({FoundN1 FoundN2 FoundPWR},'DONE!');
