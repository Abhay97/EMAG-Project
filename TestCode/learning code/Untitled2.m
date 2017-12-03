% Two layer
% Find optimum N2 where R is least, and N1 = 1.4

PI = 3.1415926;
ReflArr = [];       % Array to contain extracted reflectivity values 
TransmArr = [];     % Array to contain extracted transmissivity values
IrradArr = [];      % Array to contain irradiance values
PowerArr = [];
PowerSum = 0;

% Set material parameters 
    % Indicies
    N0 = 1;         % air
    N1 = 1.4;       % layer 1
    N2 = 0;         % layer 2
    N3 = 3.5;       % solar cell

    Delta = (PI*2);
    
    % Reflective Coefficient
    R01 = (N0-N1)/(N0+N1);
    R12 = (N1-N2)/(N1+N2);
    R23 = (N2-N3)/(N2+N3); 
    % Transmission Coefficient
    T01 = (2*N0)/(N0+N1);
    T12 = (2*N1)/(N1+N2);
    T23 = (2*N2)/(N2+N3);

    % Dynamical Matrix
    Q01 = (1/T01)*[1 R01; R01 1];
    Q12 = (1/T12)*[1 R12; R12 1];
    Q23 = (1/T23)*[1 R23; R23 1];

% Set Design Parameters
    % Center wavelength
    Wc = 650;
    
    % Layer thickness
    
% Calculate Transfer matrix
while(N2 <= 4)
    % Propagation Matrix
    P1 = [exp(j*Delta) 0; 0 exp(-j*Delta)];
    P2 = P1;            % same delta

    % Transfer Matrix
    T = Q01*(P1*Q12*P2*Q23);

    % Extract Reflectivity
        R = T(2,1)/T(1,1);      % Reflectiive coeficient from transfer matrix
        Refl = (abs(R))^2;

        % Record reflectivity value
        ReflArr = [ReflArr Refl];

    N2 = N2 + 0.1;
end;

 

   
   