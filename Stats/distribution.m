%% Question 1
% Frequency distribution is to see the possible value within a dataset. It
% is a visualization of the distribution of the data and able to see the
% bell curve or any other patterns. This shows how many values in each data
% set. 

%Probability distribution is the possible value in random variables. It
%gives a probability of each value within in the table. This shows the 
% probability of each value in a random value. 

%% Question 2

x = [0 , 1, 2, 3, 4]; %part of the table
prx = [1/16, 1/4, 3/8, 1/4, 1/16];%part of the table

ex = sum(x .* prx); %expected value of X 2a
variancex = sum((x - ex).^2 .*prx);
stdx = sqrt(variancex);%standard deviation of X 2b
cumulativedis = cumsum(prx);%cumulative-distribution X 2c
%% Question 4.80
% Draw 100 random samples from a binomial distribution, each based on 10
% trials with probability of success = 0.5 on each trial. Obtain a
% frequency distribution of the number of successes over the 100 random
% samples, and plot the stribution. How does it compare with figure 4.5(a)?

n = 10;
p = 0.05;
samples = binornd(n,p,1,100);
binedge = 0:11;
figure
h = histogram(samples,'BinMethod','integers','BinEdges',binedge);
h.BinCounts
freq = h.BinCounts/100;

figure(1)
bar(0:10,freq)

% compare with the probability distribution
prob = binopdf(0:10,6,p);
y = [freq;prob];
bar(0:10,y')
legend('Frequency Distribution','Probability Distribution')


%% Question 4.81
%Answer problem 4.80 for a binomail distribution with parameters n = 10 and
%p = .95. Compare your results with figure 4.5(b)

n1 = 10;
p1 = 0.95;
samples1 = binornd(n1,p1,1,100);
binedge1 = 0:11;
figure
h1 = histogram(samples1,'BinMethod', 'integers', 'BinEdges', binedge1);
h1.BinCounts
freq1 = h1.BinCounts/100;

figure(2)
bar(0:10,freq1)

prob1 = binopdf(0:10,10,p1);
y1 = [freq1;prob1];
bar(0:10,y1')
legend('Frequency Distribution', 'Probability Distribution')
%% question 4.82
%Answer problem 4.80 for a binomial distribution with parameters n = 10 and
%p = .5. Compare your results with figure 4.5(c).

n2 = 10;
p2 = .5;
samples2 = binornd(n2,p2,1,100);
binedge2 = 0:11;
figure
h2 = histogram(samples2, 'BinMethod', 'integers', 'BinEdges', binedge2);
h2.BinCounts
freq2 = h2.BinCounts/100;

figure(3)
bar(0:10,freq2)

prob2 = binopdf(0:10,10,p2);
y2 = [freq2;prob2];
bar(0:10,y2')
legend('Frequency Distribution', 'Probability Distribution')

%% Background for 4.64 - 4.66
% An article was published [13] concerning the incidence of cardiac death
% attributable to the earthquake in Los Angeles Count on Jan 17 1994. In
% the week before the earthquake there were an average of 15.6 cardiac
% deaths per day in Los Angeles County. On the day of the earthquake, there
% were 51 caridac deaths.

%% Question 4.64
% what is the exact probablity of 51 deaths occuring on one day if the
% cardiac death rate in the previous week continued to hold on the day of
% the earthquake?

lambda = 15.6; %cardiac deaths
time = 1; %day
mu = lambda * time;
k = 51;%deaths
pxx = (15.6.^k * exp(-lambda))/(factorial(k));

x = poisspdf(0:51, mu);
figure(4)
bar(0:51,x)
xlabel('# deaths')
ylabel('Probability')

%% question 4.65
%Is the occurence of 51 deaths unusual? (Hint: use the same methodology as
%in example 4.32) 
labda1 = 15.6;
time1 = 1;
mu1 = labda1*time1;

prob3 = 1-poisscdf(51,mu1);

%Yes it is unusual because its smaller thatn 0.5 which would make it
%unusual. 
%% question 4.66
%What is the maximum number of cardiac deaths that could have occured on
%the day of the earthquake to be consistent with the rate of cardiac deaths
%in the past week? (Hint: Use a cutoff probability of .05 to determine the
%maximum number.)

p_value = 1 - poisscdf(50, 15.6);
maximum_deaths = poissinv(0.95, 15.6);
