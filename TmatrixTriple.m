syms nAIR N1 N2 N3 nSolar Lambda LambdaC


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



pT1= [1 -r01; r01 -1]*[1 -r12; r12 -1]*[1 -r23; r23 -1]*[1 r3S; r3S 1];

eqn = pT1(2,1) == 0;
sol = solve(eqn, N2);

