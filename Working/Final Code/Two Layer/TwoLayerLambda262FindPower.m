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

StoreN2 = [];

StoreReflectance = [];
LambdaC = 650;
Lambda = 200;
StoreLambda = [];
StorePWR = [];

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

% user prompt to different refractive indexes
prompt={'Enter a value for N1'};
name = 'N1 Value';
defaultans = {'1.4'};
options.Interpreter = 'tex';
answer = inputdlg(prompt,name,[1 40],defaultans,options);

N1 = str2double(cell2mat(answer))

prompt={'Enter a value for N2'};
name = 'N2 Value';
defaultans = {'2.62'};
options.Interpreter = 'tex';
answer = inputdlg(prompt,name,[1 40],defaultans,options);

N2 = str2double(cell2mat(answer))


%%this creates a reflectivity vs Wavelength graph with the given calculation

for Lambda = LambdaStart: +1 :LambdaEnd %loop structure for varying lambda
    
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
    Lthick = lambdaC/4; %layer thickness
    
    Delta1 = (pi/2)*(Lambda/LambdaC);
    Delta2 = (pi/2)*(Lambda/LambdaC);
    
    
    %%Transfer Matrix
    P1 = [exp(j*Delta1) 0 ; 0 exp(-j*Delta1)];
    P2 = [exp(j*Delta2) 0 ; 0 exp(-j*Delta2)];
    
    
    %%Deltas
    T = Q01*P1*Q12*P2*Q2S;
    
    %various material properties calculated from the matrix
    Gamma = T(2,1)/T(1,1);
    Tau = 1/T(1,1);
    Reflectance = (abs(Gamma))^2;
    
    StoreReflectance = [StoreReflectance Reflectance]; %storing lambda in the storage array
    Trans = ((abs(Tau))^2)/(nAIR/nSolar);
    IRRAD = (6.16*10^15)/(((Lambda)^5)*(exp(2484/Lambda)-1));
    Power = Trans * IRRAD; 
    StorePWR = [StorePWR Power]; %storing power in the storage array
    
end

plot(LambdaStart:LambdaEnd, StoreReflectance*100);
title('Reflectivity vs Wavelength');
xlabel('Wavelength') ;% x-axis label
ylabel('Reflectance %') ;% y-axis label

a = num2str(sum(StorePWR));
b= 'Total Power in Watts = ' ;
h = msgbox(strcat(b,a) ,'DONE!');