function [VFilt, vInt, locs] = HR_Detect(V, sampleRate, filterObj)

VFilt = filter(filterObj,V);% applying second filter to voltage
VFilt = filter(filterObj, VFilt(end: -1: 1));
VFilt = VFilt(end: -1: 1);

%gradient command to derive the vFilt2 and time
dV = gradient(VFilt,(1/sampleRate));
dV2 = dV.^2;%square the derivative

hInt = 1/sampleRate;%rolling integration
kInt = ones(1 , round(sampleRate*0.05))*hInt;
kInt(1) = hInt*0.5; %first element is 0.5
kInt(end) = hInt*0.5;%last element is 0.5

vInt = conv(dV2,kInt,'same');%conv kInt and derivative squared 

MPH = 2*mean(vInt); %taking the mean of kernal
MPD = sampleRate*0.27;

if MPD < length(V)
    [~, locs] = findpeaks (vInt, 'MinPeakDistance', MPD,...
        'MinPeakHeight', MPH);
else 
    locs = []; 

end