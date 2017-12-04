%%%% GOAL IS TO find power production across every lambda given N2 from
%%%% previous "ThreeLayerN2WithReflectivity

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
N2 = 2.36;      %  computed layer 2
N3 = 3.15;  % refractive index of layer 3


StoreN2 = []; % Storing values of N2
StoreReflectance = []; %Storing reflectances
LambdaC = 650; %centre wavelength
StorePWR = []; %array to store power.



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
defaultans = {'2.36'};
options.Interpreter = 'tex';
answer = inputdlg(prompt,name,[1 40],defaultans,options);

N2 = str2double(cell2mat(answer))

prompt={'Enter a value for N3'};
name = 'N3 Value';
defaultans = {'3.15'};
options.Interpreter = 'tex';
answer = inputdlg(prompt,name,[1 40],defaultans,options);

N3 = str2double(cell2mat(answer))

for Lambda = LambdaStart: +1 : LambdaEnd %goes through TMM at each lambda between start and end
      
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

        
    P1 = [exp(j*Delta1) 0 ; 0 exp(-j*Delta1)];
    P2 = [exp(j*Delta2) 0 ; 0 exp(-j*Delta2)];
    P3 = [exp(j*Delta3) 0 ; 0 exp(-j*Delta3)];

    %%Transfer Matrix

    T = Q01*P1*Q12*P2*Q23*P3*Q3S;
    
    
    Gamma = T(2,1)/T(1,1);
    Tau = 1/T(1,1);
    Reflectance = (abs(Gamma))^2;
    
 
    StoreReflectance = [StoreReflectance Reflectance]; %array that stores all the reflectance values
    Trans = ((abs(Tau))^2)/(nAIR/nSolar); %compute transmitance
    IRRAD = (6.16*10^15)/(((Lambda)^5)*(exp(2484/Lambda)-1)); %computate irradiance
    Power = Trans * IRRAD; %compute power
    StorePWR = [StorePWR Power]; %storage array of total powers
end

plot(LambdaStart:LambdaEnd, StoreReflectance*100); %%plot relectance vs Wavelength
title('Reflectivity vs Wavelength');
xlabel('Wavelength') ;% x-axis label
ylabel('Reflectance, %') ;% y-axis label

a = num2str(sum(StorePWR));
b= 'Total Power in Watts = ' ;
h = msgbox({strcat(b,a) strcat('N1 = ', num2str(N1)) strcat('N2 =', num2str(N2)) strcat('N3 =', num2str(N3))} ,'DONE!');