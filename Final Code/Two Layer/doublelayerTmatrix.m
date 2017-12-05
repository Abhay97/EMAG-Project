syms nAIR N1 N2 nSolar Lambda LambdaC


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
Delta1 = (pi/2)*(LambdaC/Lambda);
Delta2 = (pi/2)*(LambdaC/Lambda);
Delta3 = (pi/2)*(LambdaC/Lambda);



P1 = [exp(j*Delta1) 0 ; 0 exp(-j*Delta1)];
P2 = [exp(j*Delta2) 0 ; 0 exp(-j*Delta2)];



T = Q01*P1*Q12*P2*Q2S;


pT1= [1 -r01; r01 -1]*[1 -r12; r12 -1]*[1 r23; r23 1]; %partial Tmatrix

eqn = pT1(2,1) == 0;
sol = solve(eqn, N2);

disp('N2 = ');
disp(sol(1));

disp('T = ');
disp(simplify(T));
