function stopFcn(tmr,app)
%% This function is called when the timer object (NI DAQ Simulator) is stopped
app.sesh.IsRunning=0;   %Set the flag to indicate the session is not running    
stop(tmr);                  %stop the timer object

app.simNI_DAQ.timeNow = 0;      %reset the time of the current sample (for next session)
