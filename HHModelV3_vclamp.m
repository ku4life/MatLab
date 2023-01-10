function [ dydt ] = HHModelV3_vclamp( t,vars )

%HHMODEL
%Author: Matthew Westacott, Richard Benninger

%Simulates a Hogkin Huxley neuron - includes sodium,potassium, and leak
%currents with injectable current

%Run using ode23s solver, initial conditions: 
%V=-65
%n=0.6
%m=0
%n=0.1

%Example [time,vals]=ode23s(@HHModel,[0 200],vars)
%vars=[-65 0.6 0 0.1]


%Dispaly the time
display(t);
%Collect potential, gate populations (0<n,m,h,<1)
V=vars(1);
n=vars(2);
m=vars(3);
h=vars(4);

%Injectable current - hard code these here
%I=(1/300)*t+0.05; %current ramp
%I=0.25; %constant
%if t>50 && t<75 %current pulse
%if t>50
%Iinj=0.35;
%else
%Iinj=0;
%end
Iinj=0;

if t>65
Vclamp=-80;
else
Vclamp=-65;
end

%For Qu2b.
%Remove solving for V (vars(1-3), n,m,h only). Remove Iinj and replace with a V clamp that is an aergument for An, Bn etc.  



%Capacitance (uF/cm^2)
C=0.01;

%Nernst Potentials (mV)
EK=-75;
ENa=55;
EL=-50;

%Conductances (mS/cm^2)
gK=0.4;
gNa=1.21;
gL=0.0025;


%Six gating variable rate constants, fit of empirical data
%n (K Channel, opening)
An=(0.01*(Vclamp+50))./(1-exp(-(Vclamp+50)/10));
Bn=0.125*exp(-(Vclamp+60)/80);
%m (Na Channel, opening)
Am=(0.1*(Vclamp+35))./(1-exp(-(Vclamp+35)/10));
Bm=4*exp(-0.05*(Vclamp+60));
%h (Na Channel, de-inactivaiton)
Ah=0.07*exp(-0.05*(Vclamp+60));
Bh=1./(1+exp(-(0.1)*(Vclamp+30)));

%Reterm variables into equillibrium values and time constants in case TauX
%or Xinf need to be modified
Ninf = An./(An+Bn);
Minf = Am./(Am+Bm);
Hinf = Ah./(Ah+Bh);
TauN = 1./(An+Bn);
TauM = 1./(Am+Bm);
TauH = 1./(Ah+Bh);
AlphaN = Ninf./TauN;
BetaN = (1-Ninf)./TauN;
AlphaM = Minf./TauM;
BetaM = (1-Minf)./TauM;
AlphaH = Hinf./TauH;
BetaH = (1-Hinf)./TauH;

%HH Equation ODE
dVdt=(Iinj-gK*n^4*(V-EK)-gNa*m^3*h*(V-ENa)-gL*(V-EL))/C; %we need to use this in order to find what K(leak)

%Gating variable ODE (replaced by below)
%dndt=An*(1-n)-Bn*n;
%dmdt=Am*(1-m)-Bm*m;
%dhdt=Ah*(1-h)-Bh*h;

%Gating variable derivatives ODE
dndt=AlphaN*(1-n)-BetaN*n;
dmdt=AlphaM*(1-m)-BetaM*m;
dhdt=AlphaH*(1-h)-BetaH*h;

%Output ODE solution
dydt(1)=dVdt;
dydt(2)=dndt;
dydt(3)=dmdt;
dydt(4)=dhdt;

dydt=dydt';

end

