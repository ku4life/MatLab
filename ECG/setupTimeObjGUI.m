%% This script checks if an NI DAQ board is connected
% if there is a DAQ, it starts a live session (using the myDAQ)
% if there is not a DAQ, it starts a simulated session (a fake myDAQ)

%% this section checks for a connected DAQ if app.TryToUseRealDAQ == 1
%ONLY SET THAT FLAG TO 1 IF NI DRIVERS/DAQ TOOLBOX IS INSTALLED

if app.TryToUseRealDAQ  
    daqreset; %reset the MATLAB DAQ subsystem 
%     devices = daqlist;  %get list of devices
    devices = daq.getDevices;
    foundIt = 0;               %variable to indicate if there's a valid DAQ
    for i=1:length(devices)     %look at all connected devices
        if strcmp(devices(i).ID, 'myDAQ1')      %this == 1 if it's the myDAQ
            foundIt = 1;
        end
    end
else
    foundIt=0;      %case when you don't even look for the DAQ - give up and do simulated DAQ
end

if foundIt
%set up DAQ session if the myDAQ is found (connected)
    try
        app.sesh = daq.createSession('ni');   %create the session
        app.sesh.addAnalogInputChannel('myDAQ1', 0, 'Voltage'); %add and analog in
        app.sesh.Rate = app.sampleRate;        %set the sample rate
        app.sesh.IsContinuous = 1;      %set to continuous reading
        %add a listener that's called whenever data is availible
        app.sesh.addlistener('DataAvailable', @ (src,event) DAQ_ECG_Listener(src,event,app)); 
    catch
        %catch is here because sometimes MATLAB still thinks the device is
        %there when it's not
        app.sesh = [];  %clear the session object
        foundIt=0;          %set flag to use a simulated session
    end
end

%% set up a simulated DAQ session - this is trickey ;)
if foundIt==0 %if there is no DAQ connected
%     global simNI_DAQ %initialize global variable, this can be seen from all functions
    load('simNI_DAQ.mat') %Load data on first call
    simNI_DAQ.timeNow = 0;  %current time in sampling session
    simNI_DAQ.dtRead = 0.1;     %how big of a chunk to read at a time
    simNI_DAQ.sampleRate = app.sampleRate; %sample rate
    app.simNI_DAQ = simNI_DAQ;

    % Make a timer object that periodicially executes a function
    tmr = timer('StartDelay', 0, 'Period', simNI_DAQ.dtRead, ...
              'ExecutionMode', 'fixedDelay');  

    tmr.TimerFcn= { @timerFxnSimNI, app};  %handle to the timer start function
    app.sesh.startBackground = @() start(tmr);  %function handle to start cmd
    app.sesh.stop = @() stopFcn(tmr,app); %function handle to stop cmd      
    app.sesh.Rate = simNI_DAQ.sampleRate;       %set the sampling rate
    app.sesh.IsRunning=0;  %indicates a DAQ recording session is not running
end


