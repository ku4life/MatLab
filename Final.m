% Question 1
%Interpolate the table
%Single Polynomial (polyfit)
%Piecewise Polynomial (spline)
%plot three points not on the table f(3.5), f(8.5), f(6)
%plot all of it comment on interpolated points

Xdata = [4 5 7 8 3 9 10];
Ydata = [8 (31/3) 15 (97/3) 5 15.5 2];
tpoints = [3.5, 6, 8.5];

%interopolation
p1 = polyfit(Xdata,Ydata, 6);
Xrange = [2.8:0.1:10.2]; %the range of the interpolation/stepsize

p11 = polyval(p1,Xrange); %evaluating from the first polyval to the range
tpointsval = polyval(p1,tpoints); %evaluating from the first datat set to the points

%interpolation piecewise
p2 = spline(Xdata,Ydata, Xrange);
tpointspline = spline(Xdata, Ydata, tpoints); 

plot(Xrange, p11,'b') %plotting the range vs equation
hold on
plot(Xrange,p2,'g') %plotting range of piecewise interpolation
plot(Xdata, Ydata, 'rx') %plotting x and y data that was given
plot(tpoints, tpointsval, 'ko') %plotting points vs evaluting points
plot(tpoints, tpointspline, 'ko')%plotting points vs interpolation
hold off


%% Question 3
%building a single interpolating polynomial
%y(0)=2
%use whatever method to find the root equation
%repeat as needed until all X values are found.
%Provide a list of all X values for which Y = 2
%Plot - The interpolating polynomial at the points of -2.2:0.2:2.2 as
%smooth red line, the points on the table above as blue dots, All reverse
%interpoalted opints for which Y = 2 as black Xs

Pdata = [0 1 -2 2 -1];
Jdata = [4 4 -6 1 0];
Prange = [-2.2:0.2:2.2];

h = polyfit(Pdata,Jdata, 4);%interpolates the data
h2 = polyval(h,Prange);% evaluates the data in the given range

syms x;
pr = @(x) 0.1250*x^4 - 0.0833*x^3 - 2.1250*x^2 + 2.0833*x + 4;
pr1 = fzero(pr,0); %this is to find the root of the euqation

fplot(h) % plots the function
plot(Prange,h2,'g');
hold on
plot(Pdata,Jdata,'bs');
plot(-0.6043,2.001, 'k*');
plot(1.7103,2,'k*');


%% Question 4
% Shooting and root finding
% Using boundary conditions for ODE 

syms T(r)
pops = [1 10 20];

for i = 1:length(pops)
popprime = diff(T,r);
popy = diff(T,r,2) + (1/r)*popprime + pops(i) == 0;
popfc = T(1) == 1;
popsc = popprime(0) == 0;
popcon = [popfc popsc];
popsolv = dsolve(popy,popcon);
popsimp = simplify(popsolv);
popin = linspace(0,1);
hold on
plot(popin,subs(popsimp,popin));
end
hold off

