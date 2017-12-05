%%three layer brute force%%

%start with a transition size of +0.4 per N, find N1,N2,N3 with best power.
%When have that, go +/- 0.8 from those N1N2N3 values and lower resolution.
%repeat this process until the search area is +/- 0.03 and the step size is
%0.01. This method lowers the number of computations needed to calculate
%the best power.


%%SETUP%%
%close previous windows%
close all;
clc;
clear all;


%preset paramaters
LambdaC = 650; %centre wavelength

%Setting refravtive indecies
nAIR = 1 ;    %refractive index of air
nSolar = 3.5;   % refractive index of solar cell
N1 = 0;    % refractive index layer 1
N2 = 0;      %  ''             layer 2
N3 = 0;      %  ''             layer 3



%%Storage Arrays to find values%%
StoreN1 = []; %this stores N1 for each lambda
StoreN2 = []; %N2
StoreN3 = [];%N3
StoreTotalPower =[]; %this stores the total power at the specific lambda

%%setting start conditions for looping structures%%

n1Start = 1; %search begins at N1 =1
n1End = 3; %Search parameters end at N1 = 3
n2Start = 1; %search begins at N2 =1
n2End = 3; %Search parameters end at N2 = 3
n3Start = 1;%search ends at N3 =1
n3End = 3; %search ends at N3 = 3

LambdaStart = 400; %Wavelength were looping begins
LambdaEnd = 1400; %ending wavelength for loop
StepSize = 0.4; %the amount refractive indexes are increased at each iteration
Iteration = 0;
MaxIteration = 5; %number of total iterations

% user prompt to select lambda range%
prompt={'Enter a value of begining Lambda'};
name = 'LambdaStart Value';
defaultans = {'400'};
options.Interpreter = 'tex';
answer = inputdlg(prompt,name,[1 40],defaultans,options);

LambdaStart = str2double(cell2mat(answer))

prompt={'Enter a value of ending Lambda'};
name = 'LambdaEnd Value';
defaultans = {'1400'};
options.Interpreter = 'tex';
answer = inputdlg(prompt,name,[1 40],defaultans,options);
LambdaEnd = str2double(cell2mat(answer))

for Iteration = 0:+1:MaxIteration %loop structe for iterations
    disp(Iteration); %used for my debug purposes
    for N1 = n1Start: +StepSize : n1End %loop structe for varying N1
        for N2 = n2Start: +StepSize: n2End %loop structe for varying N2
            for N3 = n3Start:+StepSize:n3End %loop structe for varying N3
                %%Reset the matrixes%%
                StorePWR = []; %Makes sure array is empty at each itteration
                StoreN1 = [StoreN1  N1]; %records which combination of N1, N2 & N3 are being used
                StoreN2 = [StoreN2 N2];
                StoreN3 = [StoreN3 N3];
                
                %%begin the testing for different lambdas - used to
                %%calculate power
                BestReflec = []; % this array holds the values of the reflectance at the best settings.
                
                for Lambda = LambdaStart: +1 :LambdaEnd %%goes through TMM at each lambda between start and end
                    
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
                    Delta1 = (pi/2)*(LambdaC/Lambda);
                    Delta2 = (pi/2)*(LambdaC/Lambda);
                    
                    Delta3 = (pi/2)*(LambdaC/Lambda);
                    
                    
                    P1 = [exp(j*Delta1) 0 ; 0 exp(-j*Delta1)];
                    P2 = [exp(j*Delta2) 0 ; 0 exp(-j*Delta2)];
                    P3 = [exp(j*Delta3) 0 ; 0 exp(-j*Delta3)];
                    
                    %%Transfer Matrix
                    
                    T = Q01*P1*Q12*P2*Q23*P3*Q3S;
                    
                    
                    %calculation of gamma, tau, reflectance, transmitance,
                    %and power
                    
                    Gamma = T(2,1)/T(1,1);
                    Tau = 1/T(1,1);
                    Reflectance = (abs(Gamma))^2;
                    Trans = ((abs(Tau))^2)/(nAIR/nSolar);
                    IRRAD = (6.16*10^15)/(((Lambda)^5)*(exp(2484/Lambda)-1));
                    Power = Trans * IRRAD;
                    
                    StorePWR = [StorePWR Power];%stores power in an array
                    
                    %%at the final iteration, it stores the reflectance
                    if Iteration == 5
                        BestReflec = [BestReflec Reflectance];
                    end
                end%goes to next wavelength
                PowerSum = sum(StorePWR); % gets a sum of power at each wavelength, used to find total power
                StoreTotalPower = [StoreTotalPower PowerSum]; % adds power to array.
            end
        end
    end
    %finding power and N1,N2,N3 from the previous computations
    %Power and Refractive indices at 'low resolution' setting
    [lowResPower, Pos] = max(StoreTotalPower);
    LowResN1 = StoreN1(Pos);
    LowResN2 = StoreN2(Pos);
    LowResN3 = StoreN3(Pos);
    [highresPower, Pos] = max(StoreTotalPower);
    
    bN1 = StoreN1(Pos); %best N1 from calculations
    bN2 = StoreN2(Pos); %best N2
    bN3 = StoreN3(Pos); %Best N3
    BESTPower = StoreTotalPower(Pos);%BEST power
    
    %reset arrays for next iteration
    StoreN1 = [];
    StoreN2 = [];
    StoreN3 = [];
    StoreTotalPower = [];
    
    %resets the max and min bounds for N1, N2 and N3.
    n1Start = LowResN1 - StepSize*2;
    n1End = LowResN1 + StepSize*2;
    n2Start =LowResN2 - StepSize*2;
    n2End = LowResN2 + StepSize*2;
    n3Start = LowResN3 - StepSize*2;
    n3End = LowResN3 + StepSize*2;
    
    %%change step sizes to be smaller after each iteration%%
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



plot(LambdaStart:LambdaEnd,BestReflec *100);
% plot(LambdaStart:LambdaEnd, StoreReflectancebaseline);

title('Reflectance vs Wavelength');
xlabel('Wavelength') ;% x-axis label
ylabel('Reflectance, %') ;% y-axis label

FoundN1 =strcat('N1 = ',num2str(bN1));
FoundN2 =strcat('N2 = ',num2str(bN2));
FoundN3 =strcat('N3 = ',num2str(bN3));

FoundPWR = strcat('Total Power in Watts = ' ,num2str(sum(StorePWR)));
h = msgbox({FoundPWR FoundN1 FoundN2 FoundN3},'DONE!');


