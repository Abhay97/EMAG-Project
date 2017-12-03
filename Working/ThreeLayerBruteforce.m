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


%%setting start conditions for looping structures%%

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
StoreReflctanceBEST = [];



for Iteration = 0:+1:4
    disp(Iteration);
    for N1 = n1Start: +StepSize : n1End
        for N2 = n2Start: +StepSize: n2End
            for N3 = n3Start:+StepSize:n3End
                StorePWR = [];
            end
        end
    end
    
end



