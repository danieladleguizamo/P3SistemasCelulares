clc
clear all
close all

f = 900; %900MHz
P_rx_medida_LDOS=[-21.11 -24.70 -25.59 -20.63 -18.26 -38.98 -40.94 -42.73 -45.8];
distanciaLDOS=[22 45 66 88 111 157 188 219 247];
distanciaLDOS_con_LD=[22 45 66 88 111];
distanciaLDOS_sin_LD=[157 188 219 247];
H_estacion_base=14; 
H_estacion_movil=1.5;
Perdidas_sin_LD(4)=zeros();
angulo_de_orientacion_calle_onda= 48;
w_ancho_de_calle=[15 17 16 28];
H_promedio_edificios=9; 
b_separacion_promedio_edificios=14.66;

contador0=1;

for k_LDOS=20:0.01:30

contador=1;
for alphaLDOS=2:0.01:4

 Perdidas_con_LD=20*log10(f) + 10*alphaLDOS*log10((distanciaLDOS_con_LD).*1e-3);
 %Calculo de Lo
 Lo = 32.44 + 20*log10(f) + 10*alphaLDOS*log10((distanciaLDOS_sin_LD).*1e-3);
 %Calculo de Lrts
 %Calculo de Lori
 if (0 <= angulo_de_orientacion_calle_onda) && (angulo_de_orientacion_calle_onda < 35)
 Lori = -10 + 0.354*angulo_de_orientacion_calle_onda;
 elseif (35 <= angulo_de_orientacion_calle_onda) && (angulo_de_orientacion_calle_onda < 55)
 Lori = 2.5 + 0.075*(angulo_de_orientacion_calle_onda-35);
 elseif (55 <= angulo_de_orientacion_calle_onda) && (angulo_de_orientacion_calle_onda < 90)
 Lori = 4 -0.114*(angulo_de_orientacion_calle_onda-55);
 end
 %Calculo de Lrts
 Lrts = -16.0 - 10*log10(w_ancho_de_calle.*1e-3) + 10*log10(f) + 20*log10((H_promedio_edificios-H_estacion_movil)*1e-3) + Lori;

 %Calculo de Lmsd
 %Calculo de Lbsh y de kd
 if H_estacion_base > H_promedio_edificios 
     Lbsh = -18*log10(1+(H_estacion_base-H_promedio_edificios)*1e-3);
     kd = 18;
 elseif H_estacion_base <= H_promedio_edificios
 Lsbh = 0;
 kd= 18- 15*((H_estacion_base-H_promedio_edificios)*(1e-3)/(H_promedio_edificios)*(1-e3));
 end
%Calculo de Ka
 if H_estacion_base > H_promedio_edificios
 ka=54;
 else
 ka=54 - 0.8*(H_estacion_base-H_promedio_edificios)*1e-3;
 end
 %Calculo de kf
 kf= -4 + 1.5*((f/925)-1);
 %Calculo de Lmsd
 Lmsd = Lbsh + ka + kd*log10(distanciaLDOS_sin_LD*1e-3) + kf*log10(f) - 9*log10(b_separacion_promedio_edificios);
 Lauxiliar=Lrts + Lmsd;

for i=1:length(Lauxiliar)
if Lauxiliar(i)>0
Perdidas_sin_LD(i)=Lo(i)+Lrts(i)+Lmsd(i);
else
 Perdidas_sin_LD(i)=Lo(i);
end
end

 P_rx_calculada_LDOS=[k_LDOS-Perdidas_con_LD k_LDOS-Perdidas_sin_LD] ;


restadeerror= P_rx_medida_LDOS - P_rx_calculada_LDOS;
e(contador,1)=(sum((abs(restadeerror)).^2))./length(restadeerror);
e(contador,2)=alphaLDOS;
contador=contador+1;

end

[valor_de_e_minimo index_e]=min(e(:,1));
valores_optimizados(contador0,1)=valor_de_e_minimo;
valores_optimizados(contador0,2)=e(index_e,2);
valores_optimizados(contador0,3)=k_LDOS;
contador0=contador0 + 1;
end

[valor_de_k_optimizado index_k]=min(valores_optimizados(:,1));

valor_de_k_optimizado=valores_optimizados(index_k,3)
valor_de_alpha_optimizado=valores_optimizados(index_k,2)
valor_de_e_optimizado=valores_optimizados(index_k,1)

k_LDOS=valor_de_k_optimizado;
alphaLDOS=valor_de_alpha_optimizado;


Perdidas_con_LD=20*log10(f) + 10*alphaLDOS*log10((distanciaLDOS_con_LD).*1e-3);
 %Calculo de Lo
 Lo = 32.44 + 20*log10(f) + 10*alphaLDOS*log10((distanciaLDOS_sin_LD).*1e-3);

for i=1:length(Lauxiliar)
if Lauxiliar(i)>0
Perdidas_sin_LD(i)=Lo(i)+Lrts(i)+Lmsd(i);
else
 Perdidas_sin_LD(i)=Lo(i);
end
end

 P_rx_calculada_LDOS=[k_LDOS-Perdidas_con_LD k_LDOS-Perdidas_sin_LD] ;


figure (1)
plot(distanciaLDOS,P_rx_medida_LDOS,'r--o')
title({'Comparación Potencia recibida medida vs Potencia recibida semi-empírica';'Modelo de propagación semi-empírico COST231 Walfish-Ikegami'});
xlabel('d [m]');
ylabel('P{rx} [dBm]');
grid on;
hold on
plot(distanciaLDOS,P_rx_calculada_LDOS,'b--o')
legend('P{rx} medida','P{rx} analitica')
 