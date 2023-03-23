%% Section 1
readPath = ('C:\School\Smith Lab\Lab 6');
fnames = dir(fullfile(readPath,'*mat'));

%for loop to load in the path of the files into structure
for i = 1:length(fnames)
    BIOPAC_Data(i) = load(fullfile(readPath,fnames(i).name));
end

%for loop to load in the files from the path into structure
for i = 1:length(fnames)
    BIOPAC_Data(i).fname = fnames(i).name;
    BIOPAC_Data(i).path = fnames(i).folder;
end

% conditions for design filt
sampleRate = 1000;
N = 4; 
f1 = 0.1;
f2 = 50;

%bandpass filter
filterObj = designfilt('bandpassiir', 'FilterOrder', N,'HalfpowerFrequency1',...
    f1, 'HalfPowerFrequency2', f2, 'SampleRate', sampleRate);

%% Section 2
% one giant for loop to do all the calculations and graphing at once
for i = 1:length(BIOPAC_Data)
    %Splicing data and creating time vector
    BIOPAC_Data(i).V = BIOPAC_Data(i).data (: , 1);
    BIOPAC_Data(i).HR = BIOPAC_Data(i).data(: , 2);
    BIOPAC_Data(i).Time = (1/sampleRate)*(1:(length(BIOPAC_Data(i).V)));

    figure()
    subplot(3,1,1) 
    plot(BIOPAC_Data(i).Time,BIOPAC_Data(i).V)  
    xlabel('Time (Sec)'); ylabel('Voltage (mV)');
    title(['File name is: ' fnames(i).name]);

    subplot(3,1,2)
    plot(BIOPAC_Data(i).Time,BIOPAC_Data(i).HR)
    xlabel('Time (Sec)'); ylabel('Heart Rate (BPM)');

%% Section 3
    %call the function that was created
    [VFilt, vInt, locs] = HR_Detect(BIOPAC_Data(i).V, sampleRate, filterObj);

    %Creates new fields in the structure
    BIOPAC_Data(i).VFilt = VFilt;
    BIOPAC_Data(i).vInt = vInt;
    BIOPAC_Data(i).locs = locs;

    % creates the period that is used in HR and HR_Time
    period = (BIOPAC_Data(i).Time(locs(2:end)) - BIOPAC_Data(i).Time...
        (locs(1:end-1)));
    BIOPAC_Data(i).HR = 60./period;
    BIOPAC_Data(i).HR_Time = BIOPAC_Data(i).Time(locs(2:end));


HR1 = 60;%resting heart rate
maxHR = max(BIOPAC_Data(i).HR) - HR1;%maxium heart rate - resting heart rate
T = 25;%decay constant
fitEq = fittype('HR1 + maxHR*exp(-x/T)');%fit equation
[cf,gof] = fit(BIOPAC_Data(i).HR_Time', BIOPAC_Data(i).HR', fitEq, 'Startpoint',...
    [HR1 maxHR T]);
%this calculates the fit and goodness of fit with given initial conditions

subplot(3,1,3)
plot(BIOPAC_Data(i).Time,cf(BIOPAC_Data(i).Time), 'black')
hold on
plot(BIOPAC_Data(i).HR_Time,BIOPAC_Data(i).HR, 'r.')

xlabel('Time (Sec)')
ylabel('Signal')
title("Signal vs Time")
legend('Signal','Calculated Fit')

hold off
pause(0.5)

BIOPAC_Data(i).T = cf.T;
BIOPAC_Data(i).HR2 = cf.HR1;
BIOPAC_Data(i).maxHR = cf.maxHR;

end

%% Section 4

%calculating Max Heart Rate
MHR = [BIOPAC_Data.HR2] + [BIOPAC_Data.maxHR];

%creating boxplot
figure()
subplot(1,3,1)
boxplot([BIOPAC_Data.HR2])
xlabel('Resting Heart Rate')
hold on

subplot(1,3,2)
boxplot(MHR)
xlabel('Max Heart Rate')

subplot(1,3,3)
boxplot([BIOPAC_Data.T])
xlabel('Rate of Decay (T)') 
hold off