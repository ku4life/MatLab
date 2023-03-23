function timerFxnSimNI(src,event,app)
%% This function simulates the DAQ and calls the listener at 1/10 sec intervals
% data is a prerecorded ECG from Dr. Smith

%make a time vector for current samples
time = (app.simNI_DAQ.timeNow:(1/app.simNI_DAQ.sampleRate):(app.simNI_DAQ.timeNow+app.simNI_DAQ.dtRead))';
%get recorded signal from spline
data = ppval(mod(time,app.simNI_DAQ.ECG_tend),app.simNI_DAQ.ECG_pp);
%increment time so we read later on next step
app.simNI_DAQ.timeNow = app.simNI_DAQ.timeNow + app.simNI_DAQ.dtRead;

% set up arguments for dummy event and source
NIsrc.Rate = app.sesh.Rate;         %sample rate, defined in main
event.TriggerTime = datenum(clock);     %current wall time
event.Data = data;                      %simulated data vector
event.TimeStamps = time;                %simulated sample time vector
event.Source = NIsrc;                   %simulated source object (not complete)
event.EventName = 'DataAvailible';      %what's happening!

% set the DAQ session to running
app.sesh.IsRunning = 1;             %flag indicating DAQ is running

% call the listener function (students edit the listener, this is where the magic happens)
DAQ_ECG_Listener(NIsrc,event,app);
