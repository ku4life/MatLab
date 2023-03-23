function DAQ_ECG_Listener(src,event,app)
%% This function is called whenever the DAQ has data that is ready to transfer to the PC.
% this occurs ever 1/10 second during recording; the data is processed in
% small chunks. 

%inputs:
%src: the session object (same as app.sesh in the calling GUI)

%event: struct containing that data for the most recent aquisition.
% event.TriggerTime : time that the first datapoint in this set of data was recorded
% event.Data : The data recorded in 1/10 second (a vector)
% event.TimeStamps : Time vector for the data
% event.Source : the session object used to record (same as src above)
% event.EventName : this should be a string 'DataAvailable'

% app : your app structure, which contains all the object and their properties (e.g.
% button values) and the properties (variables) you've defined (e.g.
% app.data, app. time)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% ADD YOUR CODE HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1) concatenate current readings with last readings, store in app
% properties
app.time = [app.time event.TimeStamps'];
app.data = [app.data event.Data'];
% 2) Delete out of range data (less than the end time minus app.winSize)
idx = app.time < (app.time(end) - app.winSize);
app.time(idx) = [];
app.data(idx) = [];

%3) do beat detection (call your HR_Detect script)
[VFilt, vInt, locs] = HR_Detect(app.data, app.sampleRate, app.filterObj);

period = (app.time(locs(2:end))) - app.time(locs(1:end-1));
HR = 60./period;

%4) Do plots: conditional statements for check boxes, and the plotting
% commands
hold (app.UIAxes, "off")
if app.VoltageCheckBox.Value == 1
    plot(app.UIAxes, app.time, app.data)
    hold(app.UIAxes, "on")
end 
if app.HeartBeatCheckBox.Value == 1
    plot(app.UIAxes, app.time(locs), VFilt(locs), 'ro', MarkerSize=20);
    hold(app.UIAxes,"on")
end 
if app.FilterCheckBox.Value == 1
    plot(app.UIAxes, app.time, VFilt)
    hold(app.UIAxes, "on")
end 

xlim(app.UIAxes, [app.time(1) app.time(end)]);
ylim(app.UIAxes, [-4, 4])

%5) Calculate heart rate, add to plot title

title(app.UIAxes, sprintf('ECG Signal: %0.1f bpm'), mean(HR))

end