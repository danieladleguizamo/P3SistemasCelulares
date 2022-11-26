clc
clear all
close all

f = 900; %900MHz
P_rx_medida_LOS=[-27.86 -21.41 -21.65 -23.88 -27.38 -29.5];
distanciaLOS=[33 66 99 132 165 198];
contador0=1;


for k1_LOS=190:0.01:210
contador=1;

for alphaLOS=2:0.01:4
L_LOS = 10*alphaLOS*log10(distanciaLOS) + 10*alphaLOS*log10(f*1000000); % Modelo espacio libre
P_rx_calculada_LOS=k1_LOS - L_LOS;
restadeerror= P_rx_medida_LOS - P_rx_calculada_LOS;
e(contador,1)=(sum((abs(restadeerror)).^2))./length(restadeerror);
e(contador,2)=alphaLOS;
contador=contador+1;
end

[valor_de_e_minimo index_e]=min(e(:,1));
valores_optimizados(contador0,1)=valor_de_e_minimo;
valores_optimizados(contador0,2)=e(index_e,2);
valores_optimizados(contador0,3)=k1_LOS;
contador0=contador0 + 1;
end

[valor_de_k_optimizado index_k]=min(valores_optimizados(:,1));

valor_de_k_optimizado=valores_optimizados(index_k,3)
valor_de_alpha_optimizado=valores_optimizados(index_k,2)
valor_de_e_optimizado=valores_optimizados(index_k,1)

k1_LOS=valor_de_k_optimizado;
alphaLOS=valor_de_alpha_optimizado;

L_LOS = 10*alphaLOS*log10(distanciaLOS) + 10*alphaLOS*log10(f*1000000); % Modelo espacio libre
P_rx_calculada_LOS=k1_LOS - L_LOS;


figure (1)
plot(distanciaLOS,P_rx_medida_LOS,'r--o')
title({'Comparación Potencia recibida medida vs Potencia recibida analitica';'Modelo analitico propagación en espacio libre'});
xlabel('d [m]');
ylabel('P{rx} [dBm]');
grid on;
hold on
plot(distanciaLOS,P_rx_calculada_LOS,'b--o')
legend('P{rx} medida','P{rx} analitica')
 