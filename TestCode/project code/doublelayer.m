close all; 
clc; 
clear all; 
 
% UNITS 
degrees = pi/180; 

%paramaters
lambdaC = 650 %nm
refAIR = 1 %refractive index of air
nSolar = 3.5 % refractive index of solar cell
lambdaSTART = 200 % first value to intergrate from
lambdaEnd = 2200 % last value to ingrate to
numberLayers = 2
refN1 = 1.4
refN2 = 0
refN3 = 3.15
c = 3e8
j = 1j  %sets immaginary number 
LambdaZero = 
%%%% GOAL IS TO FIND OPTIMAL refN2 

 %%Arrays%%
Reflect = []
Transm = []
Irrad = []
Pwr = []
k = 1
X = zeros(80,6);

% [r0to1 , r1to2, r2to3, t0to1, t1to2, t2to3]%

ref = []
trans = []

while refN2 < 4 %%vary N2
    %%creating blank array


    %%%%Finding reflective and transmitive coefs    
    r0to1 = (refAIR - refN1)/(refAIR + refN1)
    r1to2 = (refN1 - refN2)/(refN1 + refN2)
    r2to3 = (refN2 - refN3)/(refN2 + refN3)
    t0to1 = 2*(refAIR)/(refAIR +refN1)
    t1to2 = 2*(refN1)/(refN1 +refN2)
    t2to3 = 2*(refN2)/(refN2 +refN3)
    
    X(k,1) = r0to1;
    X(k,2) = r1to2;
    X(k,3) = r2to3;
    
    X(k,4) = t0to1;
    X(k,5) = t1to2;
    X(k,6) = t2to3;
    
    k =k +1
    refN2 = refN2+0.05

    %dynamic matrix
    Q01 = (1/t0to1)*([1 r0to1; r0to1 1])
    Q12 = (1/t1to2)*([1 r1to2; r1to2 1])
    Q23 = (1/t2to3)*([1 r2to3; r2to3 1])

    %%Phase Thickness%% deltaM
    
    delta1 = (2)*(pi)/Lambda;
end





