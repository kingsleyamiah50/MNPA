clearvars
clearvars -GLOBAL
close all
set(0,'DefaultFigureWindowStyle', 'docked')

sizex = 6;
sizey = 6;

% Components
Cap = 0.25;
R1 = 1;
R2 = 2;
L = 0.2;
R3 = 10;
alpha = 100;
R4 = 0.1;
Ro = 1000;
omega = 10;

% C Matrix
C = zeros(sizex,sizey);
C(2,1) = -Cap;
C(2,2) = Cap;
C(6,6) = -L;

% G Matrix
G = zeros (sizex, sizey);
G(1,1) = 1;
G(2,1) = -1/R1;
G(2,2) = (1/R1) + (1/R2);
G(2,6) = -1;
G(3,3) = 1/R3;
G(3,6) = 1;
G(4,3) = -alpha/R3;
G(4,4) = 1;
G(5,4) = -R4;
G(5,5) = R4 - (1/Ro);
G(6,2) = 1;
G(6,3) = -1;

% F Vector
F = zeros(1,sizey);
stepsize = 21;

VoutVect = zeros(1,stepsize);
V3Vect = zeros(1,stepsize);

% DC Sweep

for i = -10:10
    F(1) = i;
    
    % V vector
    V = (G + omega.*C)\F';
    VoutVect(i+11) = V(5);
    V3Vect(i+11) = V(3);
end
subplot(3,2,1);

plot (linspace(-10,10,stepsize),VoutVect);
title('-10V to 10V');
hold on
plot (linspace(-10,10,stepsize), V3Vect);
legend('Vo', 'V3');
xlabel('Vin');
ylabel('V');



% AC Sweep 

F = zeros(1,sizey);
F(1) = 1;
stepsize = 100;

VoutVect = zeros(1,stepsize);
V3Vect = zeros(1,stepsize);

omega = linspace(1,100,stepsize);

for i = 1:stepsize
    V = (G + 1j*omega(i).*C)\F';
    VoutVect(i) = V(5);
    V3Vect(i) = V(3);
end    

subplot(3,2,2);

plot (omega,abs(VoutVect));
title(' 0 to 100Hz');
hold on
plot (omega, abs(V3Vect));
legend('Vo', 'V3');
xlabel('w');
ylabel('V');

gain = 20 * log(abs(VoutVect./F(1)));

subplot(3,2,3);
plot(omega, gain);
title('Gain Vo/V1 in dB');
xlabel('w');
ylabel('Vo/V1 in dB');


% Histogram Cap and gain
omega = pi;
Crand = 0.05*randn(1,stepsize) + Cap;
for i = 1:stepsize
    V = (G + 1j*omega.*Crand(i))\F';
    VoutVect(i) = V(5);
end    

gain = 20 * log(abs(VoutVect./F(1)));

subplot(3,2,4);
histogram(Crand);
xlabel('C');
ylabel('Number');

subplot(3,2,5);
histogram(gain);
xlabel('Gain (dB)');
ylabel('Number');




