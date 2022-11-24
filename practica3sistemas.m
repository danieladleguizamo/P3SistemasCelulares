clc
clear all
close all

LOS=[-27.86 -21.41 -21.65 -21.78 -22.9 -23.5];
distanciaLOS=[33 66 99 132 165 198];
%LOSlineal=10.^(LOS./10);
LDOS=[-21.11 -24.70 -25.59 -20.63 -18.26 -30.98 -37.94 -42.73 -45.8];
distanciaLDOS=[22 45 66 88 111 157 188 219 247];
%LDOSlineal=10.^(LDOS./10);

figure (1)
plot(distanciaLOS,LOS,'r--o')
figure (2)
plot(distanciaLDOS,LDOS,'r--*')