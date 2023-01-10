%Initial conditions are in the order of : V,n,m,h
%n is potassium channel and m describing opening for sodium and h describes
%closing
vars=[-65 0.6 0.00 0.1];

%Solve the model HHModelV3
[time,vals]=ode23s(@HHModelV3,[0 200],vars); %membrane potential

%This is the current used in HH Model. note this is hard coded here and in
%the model
Iinj=0.35*(time>65); %change in the model change it here Injected current
%Vclamp=-35*(time<65)-30;

gL = 0.0025;
EL = -50;
kl = gL*(vals(:,1)-EL);

ENa=55;
gNa=1.21;
currentna = gNa*(vals(:,3).^3).*(vals(:,4)).*(vals(:,1)-ENa);

EK=-75;
gK=0.4;
currentk = gK*(vals(:,2).^4).*(vals(:,1)-EK);

%Plot model outputs (current clamp and measured voltage)vs time
figure
subplot(2,1,1)
plot(time,vals(:,1));
xlabel('Time')
ylabel('Membrane Potential (mV)')
%subplot(3,1,3)
%plot3(vals(:,1),vals(:,2),time);
%xlabel('Vm')
%ylabel('n')
%zlabel('Time')
subplot(2,1,2)
plot(time,Iinj);
xlabel('Time')
ylabel('Injected Current (uA)')


figure
plot(time, currentk); %potassium channel plotted against time
xlabel ('Time')
ylabel ('K(V)')

figure
plot(time, currentna); %sodium channels opening against time
xlabel('Time')
ylabel ('Na(V)')

figure
plot(time,kl); %potassium leak
xlabel ('Time')
ylabel ('K(leak)')

%% Question 2

%2a
gK=0.4;
gNa=1.21;
EK=-75;
ENa=55;
V = (-100:2:100)';

%Six gating variable rate constants, fit of empirical data
%n (K Channel, opening)
An=(0.01*(V+50))./(1-exp(-(V+50)/10));
Bn=0.125*exp(-(V+60)/80);
%m (Na Channel, opening)
Am=(0.1*(V+35))./(1-exp(-(V+35)/10));
Bm=4*exp(-0.05*(V+60));
%h (Na Channel, de-inactivaiton)
Ah=0.07*exp(-0.05*(V+60));
Bh=1./(1+exp(-(0.1)*(V+30)));

Ninf = An./(An+Bn);
Minf = Am./(Am+Bm);
Hinf = Ah./(Ah+Bh);

SSk = gK.*Ninf.^4.*(V-EK);
SSNa = gNa.*Minf.^3.*Hinf.*(V-ENa);

figure
plot(V,SSk);
xlabel('Voltage')
ylabel('IK')

figure
plot(V,SSNa);
xlabel ('Voltage')
ylabel ('INa')


%% 2b

vars=[-65 0.6 0.00 0.1];

%Solve the model HHModelV3
[time1,vals1]=ode23s(@HHModelV3_vclamp,[0 200],vars); %membrane potential -80mv
[time2,vals2]=ode23s(@HHModelV3_vclamp1,[0 200],vars); %membrane potential -50mv
[time3,vals3]=ode23s(@HHModelV3_vclamp2,[0 200],vars); %membrane potential -20mv
[time4,vals4]=ode23s(@HHModelV3_vclamp3,[0 200],vars); %membrane potential 5mv
[time5,vals5]=ode23s(@HHModelV3_vclamp4,[0 200],vars); %membrane potential 20mv

vclamp11 = zeros(length(time1),1);
for i = 1:1:length(time1)
    if time1(i) > 65
        vclamp11(i) = -80;
    else
        vclamp11(i) = -65; 
    end
end 

vclamp12 = zeros(length(time2),1);
for i = 1:1:length(time2)
    if time1(i) > 65
        vclamp12(i) = -55;
    else 
        vclamp12(i) = -65;
    end
end 

vclamp13 = zeros(length(time3),1);
for i = 1:1:length(time3)
    if time3(i) > 65
        vclamp13(i) = -20;
    else
        vclamp13(i) = -65;
    end 
end

vclamp14 = zeros(length(time4),1);
for i = 1:1:length(time4)
    if time4(i) > 65
        vclamp14(i) = 5;
    else
        vclamp14(i) = -65;
    end
end

vclamp15 = zeros(length(time5),1);
for i = 1:1:length(time5)
    if time5(i) > 65
        vclamp15(i) = 20;
    else
        vclamp15(i) = -65;
    end
end

figure()
hold on
plot(time1,vclamp11)
plot(time2,vclamp12)
plot(time3,vclamp13)
plot(time4,vclamp14)
plot(time5,vclamp15)
xlabel('Time')
ylabel('Voltage')
legend('Membrane Potential -80', 'Membrane Potential -50', 'Membrane Potential -20', 'Membrane Potential 5', 'Membrane Potential 20')
hold off

EK=-75;
ENa=55;
gK=0.4;
gNa=1.21;

K1 = gK*vals1(:,2).^4.*(-80-EK);
Na1 = gNa*vals1(:,3).^3.*vals1(:,4).*(-80-ENa);

K2 = gK*vals2(:,2).^4.*(-50-EK);
Na2 = gNa*vals2(:,3).^3.*vals2(:,4).*(-55-ENa);

K3 = gK*vals3(:,2).^4.*(-20-EK);
Na3 = gNa*vals3(:,3).^3.*vals3(:,4).*(-20-ENa);

K4 = gK*vals4(:,2).^4.*(5-EK);
Na4 = gNa*vals4(:,3).^3.*vals4(:,4).*(5-ENa);

K5 = gK*vals5(:,2).^4.*(20-EK);
Na5 = gNa*vals5(:,3).^3.*vals5(:,4).*(20-ENa);

figure()
hold on
plot(time1,K1)
plot(time2,K2)
plot(time3,K3)
plot(time4,K4)
plot(time5,K5)
xlabel('Time')
ylabel('Potassium Current')
legend('Membrane Potential -80', 'Membrane Potential -50', 'Membrane Potential -20', 'Membrane Potential 5', 'Membrane Potential 20')
hold off

figure()
hold on
plot(time1,Na1)
plot(time2,Na2)
plot(time3,Na3)
plot(time4,Na4)
plot(time5,Na5)
xlabel('Time')
ylabel('Sodium Current')
legend('Membrane Potential -80', 'Membrane Potential -50', 'Membrane Potential -20', 'Membrane Potential 5', 'Membrane Potential 20')
hold off

Kpeak = zeros(1,5);
Npeak = zeros(1,5);

Npeak(:,1) = min(Na1);
Npeak(:,2) = min(Na2);
Npeak(:,3) = min(Na3);
Npeak(:,4) = min(Na4);
Npeak(:,5) = min(Na5);

Kpeak(:,1) = max(K1);
Kpeak(:,2) = max(K2);
Kpeak(:,3) = max(K3);
Kpeak(:,4) = max(K4);
Kpeak(:,5) = max(K5);

Kss = zeros (1,5);
Nss = zeros (1,5);

Nss(:,1) = Na1(end);
Nss(:,2) = Na2(end);
Nss(:,3) = Na3(end);
Nss(:,4) = Na4(end);
Nss(:,5) = Na5(end);

Kss(:,1) = K1(end);
Kss(:,2) = K2(end);
Kss(:,3) = K3(end);
Kss(:,4) = K4(end);
Kss(:,5) = K5(end);

Volts = linspace(-65,30,5);

figure()
subplot(2,1,1)
plot(Volts,Kss)
xlabel('Voltage')
ylabel('K Steady State Current')
subplot(2,1,2)
plot(Volts,Kpeak)
xlabel('Voltage')
ylabel('K peak current')

figure()
subplot(2,1,1)
plot(Volts,Npeak)
xlabel('Voltage')
ylabel('Na Steady State Current')
subplot(2,1,2)
plot(Volts,Nss)
xlabel('Voltage')
ylabel('Na peak current')

%% 3

[time,vals]=ode23s(@HHModelV33,[0 200],vars);

figure()
plot(time,vals(:,1));
xlabel('Time')
ylabel('Membrane Potential')
