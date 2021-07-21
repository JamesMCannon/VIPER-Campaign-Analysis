%Work with VIPER recievers UMM and WI

clear all; close all;

datadirWI = 'C:\Users\james\Documents\MATLAB\LAIR\Wallops Island\Narrowband\';
dA_WI = dir([datadirWI '*NAA*000A.mat']);
dB_WI = dir([datadirWI '*NAA*000B.mat']);


datadirUM = 'C:\Users\james\Documents\MATLAB\LAIR\UMM\UMM Narrowband\';
dA_UM = dir([datadirUM '*NAA*000A.mat']);
dB_UM = dir([datadirUM '*NAA*000B.mat']);


%% initialize dates

[startday,stopday] = dateLength(dA_UM, datadirUM);

% startday = datenum(2021,03,18);
% stopday = datenum(2021,04,18);

numdays = stopday - startday + 1;

colors = colormap(jet(numdays));
ticklabel= [datetime(int32(floor(startday)), 'ConvertFrom', 'datenum'), ...
    datetime(int32(floor(startday+0.25*numdays)), 'ConvertFrom', 'datenum'), ...
    datetime(int32(floor(startday+0.5*numdays)),'ConvertFrom', 'datenum'), ...
    datetime(int32(floor(startday+0.75*numdays)),'ConvertFrom', 'datenum'),...
    datetime(int32(floor(stopday)),'ConvertFrom', 'datenum')];
ticklabel=string(ticklabel);
ticks = [0, 0.25, 0.5, 0.75, 1];

tvec = 0:1:86399;
%% Read Amplitude Data into array

dataAmp_WI = readData(dA_WI, datadirWI, startday, stopday);
dataAmp_UM = readData(dA_UM, datadirUM, startday, stopday);
%% Plot Single-Site Amplitude 

h1 = figure(1);
colors = colormap(jet(numdays));
ax3 = plot(tvec/3600,20*log10(dataAmp_UM));
colororder(colors);
title('Wallops Island NAA Raw');
ylabel('Amplitude (dB)');
xlabel('Time (UT hours)');
cb1=colorbar('Ticks', ticks, 'TickLabels', ticklabel);
cb1.Label.String = 'Date';

%% Uptime Data - NAA
oncounts = zeros(86400,1);
offcounts = zeros(86400,1);
percenton = NaN*ones(86400,1);
for dayind=1:numdays
    for thissec=1:86400
        if 20*log10(dataAmp_UM(thissec,dayind))>46
            oncounts(thissec)=oncounts(thissec)+1;
        elseif 20*log10(dataAmp_UM(thissec,dayind))>0
            offcounts(thissec)=offcounts(thissec)+1;
        end
    end
end

for thissec=1:86400
    percenton(thissec) = oncounts(thissec)/(oncounts(thissec)+offcounts(thissec));
end

binwidth=15*60;
numbins = 86400/binwidth;
onvals = NaN*ones(numbins,1);

for indx =1:numbins
    onvals(indx)=sum(oncounts((indx-1)*binwidth+1:indx*binwidth),'omitnan')/(sum(oncounts((indx-1)*binwidth+1:indx*binwidth),'omitnan')+sum(offcounts((indx-1)*binwidth+1:indx*binwidth),'omitnan'));
end

invbinvals = 1.-onvals;
t = datetime(2021,5,19,0,15,0);
for i=1:numbins-1
    t = [t datetime(2021,5,19,0,15,0)+minutes(i*15)];
end
d = timeofday(t);
f2=figure(3);
bar(d,invbinvals);
boxstart = 1/24 - .125/24;
boxwidth = 3/24 + .25/24;
dim = [boxstart 0 boxwidth .2];
col = [0.3010 0.7450 0.9330 0.4];
% annotation('rectangle',dim,'FaceColor',col);
rectangle('Position',dim,'FaceColor',col);
x = [0.33 boxstart+1.735*boxwidth];
y = [0.8 0.7];
annotation('textarrow',x,y,'String','Launch Window');
% bar(d,binvals,'FaceColor','#D95319');
xlabel('Time of Day (UT)');
ylabel('Proportion');
title('NAA Downtime Measured '+string(datetime(int32(floor(startday)), 'ConvertFrom', 'datenum'))+' to '+string(datetime(int32(floor(stopday)), 'ConvertFrom', 'datenum')) );
