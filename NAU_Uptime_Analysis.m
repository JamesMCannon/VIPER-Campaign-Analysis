%Work with VIPER recievers UMM and WI

clear all; close all;

datadirWI = 'D:\LAIR Data\Wallops Island\Narrowband\';
dA_WI = dir([datadirWI '*NAU*000A.mat']);
dB_WI = dir([datadirWI '*NAU*000B.mat']);


datadirUM = 'D:\LAIR Data\UMM\UMM Narrowband\';
dA_UM = dir([datadirUM '*NAU*000A.mat']);
dB_UM = dir([datadirUM '*NAU*000B.mat']);


%% initialize dates

[startday,stopday] = dateLength(dA_WI, datadirWI);

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
ax3 = plot(tvec/3600,20*log10(dataAmp_WI));
colororder(colors);
title('Wallops Island NAA Raw');
ylabel('Amplitude (dB)');
xlabel('Time (UT hours)');
cb1=colorbar('Ticks', ticks, 'TickLabels', ticklabel);
cb1.Label.String = 'Date';

%% Uptime Data - NAU

oncounts = zeros(86400,1);
offcounts = zeros(86400,1);
intcounts = zeros(86400,1);

for dayind=1:numdays
    for thissec=1:86400
        if thissec>0 && thissec<0.5*3600
            if 20*log10(dataAmp_WI(thissec,dayind))>24 && 20*log10(dataAmp_WI(thissec,dayind))<38.25
                oncounts(thissec)=oncounts(thissec)+1;
            elseif 20*log10(dataAmp_WI(thissec,dayind))>38.25
                intcounts(thissec)=offcounts(thissec)+1;
            elseif 20*log10(dataAmp_WI(thissec,dayind))>0
                offcounts(thissec) = offcounts(thissec)+1;
            end
        end
        if thissec>0.5*3600 && thissec<09.25*3600
            if 20*log10(dataAmp_WI(thissec,dayind))>30 && 20*log10(dataAmp_WI(thissec,dayind))<40.6
                oncounts(thissec)=oncounts(thissec)+1;
            elseif 20*log10(dataAmp_WI(thissec,dayind))>40.6
                intcounts(thissec)=offcounts(thissec)+1;
            elseif 20*log10(dataAmp_WI(thissec,dayind))>0
                offcounts(thissec) = offcounts(thissec)+1;
            end
        end
        if thissec>09.25*3600 && thissec<12*3600
            if 20*log10(dataAmp_WI(thissec,dayind))>17 && 20*log10(dataAmp_WI(thissec,dayind))<40.1
                oncounts(thissec)=oncounts(thissec)+1;
            elseif 20*log10(dataAmp_WI(thissec,dayind))>40.1
                intcounts(thissec)=offcounts(thissec)+1;
            elseif 20*log10(dataAmp_WI(thissec,dayind))>0
                offcounts(thissec) = offcounts(thissec)+1;
            end
        end
        if thissec>12*3600 && thissec<13.5*3600
            if 20*log10(dataAmp_WI(thissec,dayind))>24.25 && 20*log10(dataAmp_WI(thissec,dayind))<31.5
                oncounts(thissec)=oncounts(thissec)+1;
            elseif 20*log10(dataAmp_WI(thissec,dayind))>31.5
                intcounts(thissec)=offcounts(thissec)+1;
            elseif 20*log10(dataAmp_WI(thissec,dayind))>0
                offcounts(thissec) = offcounts(thissec)+1;
            end
        end
        if thissec>13.5*3600 && thissec<18*3600
            if 20*log10(dataAmp_WI(thissec,dayind))>28.5 && 20*log10(dataAmp_WI(thissec,dayind))<33.5
                oncounts(thissec)=oncounts(thissec)+1;
            elseif 20*log10(dataAmp_WI(thissec,dayind))>33.5
                intcounts(thissec)=offcounts(thissec)+1;
            elseif 20*log10(dataAmp_WI(thissec,dayind))>0
                offcounts(thissec) = offcounts(thissec)+1;
            end
        end
        if thissec>18*3600 && thissec<19.5*3600
            if 20*log10(dataAmp_WI(thissec,dayind))>29.3 && 20*log10(dataAmp_WI(thissec,dayind))<36
                oncounts(thissec)=oncounts(thissec)+1;
            elseif 20*log10(dataAmp_WI(thissec,dayind))>36
                intcounts(thissec)=offcounts(thissec)+1;
            elseif 20*log10(dataAmp_WI(thissec,dayind))>0
                offcounts(thissec) = offcounts(thissec)+1;
            end
        end
        if thissec>19.5*3600 && thissec<21.5*3600
            if 20*log10(dataAmp_WI(thissec,dayind))>26.5 && 20*log10(dataAmp_WI(thissec,dayind))<34.2
                oncounts(thissec)=oncounts(thissec)+1;
            elseif 20*log10(dataAmp_WI(thissec,dayind))>34.2
                intcounts(thissec)=offcounts(thissec)+1;
            elseif 20*log10(dataAmp_WI(thissec,dayind))>0
                offcounts(thissec) = offcounts(thissec)+1;
            end
        end
        if thissec>21.5*3600 && thissec<24*3600
            if 20*log10(dataAmp_WI(thissec,dayind))>14.45 && 20*log10(dataAmp_WI(thissec,dayind))<36
                oncounts(thissec)=oncounts(thissec)+1;
            elseif 20*log10(dataAmp_WI(thissec,dayind))>36
                intcounts(thissec)=offcounts(thissec)+1;
            elseif 20*log10(dataAmp_WI(thissec,dayind))>0
                offcounts(thissec) = offcounts(thissec)+1;
            end
        end
    end
end

binwidth=15*60;
numbins = 86400/binwidth;
onvals = NaN*ones(numbins,1);
offvals = NaN*ones(numbins,1);
intvals = NaN*ones(numbins,1);
for indx =1:numbins
    ons = sum(oncounts((indx-1)*binwidth+1:indx*binwidth),'omitnan');
    offs = sum(offcounts((indx-1)*binwidth+1:indx*binwidth),'omitnan');
    ints = sum(intcounts((indx-1)*binwidth+1:indx*binwidth),'omitnan');
    onvals(indx)=ons/(ons+offs+ints);
    offvals(indx)= offs/(ons+offs+ints);
    intvals(indx) = ints/(ons+offs+ints);
end
t = datetime(2021,5,19,0,15,0);
for i=1:numbins-1
    t = [t datetime(2021,5,19,0,15,0)+minutes(i*15)];
end
d = timeofday(t);
f2=figure(4);
stack = [offvals intvals];
b=bar(d,stack,'stacked');
b(1).FaceColor = [0 0.4470 0.7410];
b(2).FaceColor = [0.8500 0.3250 0.0980];
% bar(d,binvals,'FaceColor','#D95319');

boxstart = 1/24 - .125/24;
boxwidth = 3/24 + .25/24;
dim = [boxstart 0 boxwidth .3];
col = [0.3010 0.7450 0.9330 0.4];
% annotation('rectangle',dim,'FaceColor',col);
rectangle('Position',dim,'FaceColor',col);
x = [0.33 boxstart+1.735*boxwidth];
y = [0.8 0.7];
annotation('textarrow',x,y,'String','Launch Window');

xlabel('Time of Day (UT)');
ylabel('Proportion');
legend('Transmitter Down','Local Interference');
title('NAU Downtime Measured '+string(datetime(int32(floor(startday)), 'ConvertFrom', 'datenum'))+' to '+string(datetime(int32(floor(stopday)), 'ConvertFrom', 'datenum')) );


