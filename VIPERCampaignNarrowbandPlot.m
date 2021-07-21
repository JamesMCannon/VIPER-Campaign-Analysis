%Work with VIPER recievers UMM and WI

clear all; close all;

datadirWI = 'D:\LAIR Data\Wallops Island\Narrowband\';
dA_WI = dir([datadirWI '*NAA*000A.mat']);
dB_WI = dir([datadirWI '*NAA*000B.mat']);


datadirUM = 'D:\LAIR Data\UMM\UMM Narrowband\';
dA_UM = dir([datadirUM '*NAA*000A.mat']);
dB_UM = dir([datadirUM '*NAA*000B.mat']);


%% initialize dates

[startday,stopday] = dateLength(dA_UM, datadirUM);

startday = datenum(2021,04,10);
stopday = datenum(2021,04,20);

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
%% read Amplitude data into array

dataAmp_WI = readData(dA_WI, datadirWI, startday, stopday);
dataAmp_UM = readData(dA_UM, datadirUM, startday, stopday);

%% read Phase data into array
dataPhase_WI = readData(dB_WI, datadirWI, startday, stopday);
dataPhase_UM = readData(dB_UM, datadirUM, startday, stopday);

%% Filter Amplitude Data - New
WI_Cutoff = -.5;
UM_Cutoff = 67.5;
tic
dataFilAmp_WI_New = filterAmp_mex(dataAmp_WI,WI_Cutoff);
dataFilAmp_UM_New = filterAmp_mex(dataAmp_UM,UM_Cutoff);
toc
%% Amplitude-based Phase Filter
dataFilPhase_WI = unwrap(dataPhase_WI);
dataFilPhase_UM = unwrap(dataPhase_UM);
for dayind=1:numdays
    for thissec=1:86400
        if isnan(dataFilAmp_WI_New(thissec,dayind))
            dataFilPhase_WI(thissec,dayind)=NaN;
        end
        if isnan(dataFilAmp_UM_New(thissec,dayind))
            dataFilPhase_UM(thissec,dayind)=NaN;
        end
        if dataFilPhase_WI(thissec,dayind)>500
            dataFilPhase_WI(thissec,dayind)=NaN;
        end
        if dataFilPhase_UM(thissec,dayind)>500
            dataFilPhase_UM(thissec,dayind)=NaN;
        end
    end
end

%% Detrend Phase - New
[night_slopes_WI, day_slopes_WI] = phaseDrift(dataFilPhase_WI);
[night_slopes_UM, day_slopes_UM] = phaseDrift(dataFilPhase_UM);

slopes = [night_slopes_WI day_slopes_WI night_slopes_UM day_slopes_UM];
avg_slope = mean(slopes,'omitnan');
trend = avg_slope/86400 * tvec;

detrend_UM = detrendPhase(dataFilPhase_UM,avg_slope);
detrend_WI = detrendPhase(dataFilPhase_WI,avg_slope);

fig1 = figure(1);

h0 = tiledlayout(4,1,'TileSpacing','Compact');
colors = colormap(jet(numdays));
ax3 = nexttile;
set(ax3,'ColorOrder', colors, 'NextPlot', 'replacechildren');
p3 = plot(ax3,tvec/3600,dataFilPhase_UM);
title(ax3,'Unrwaped Data');
ylabel(ax3, 'Phase (deg)');

ax2 = nexttile;
set(ax2,'ColorOrder',colors, 'NextPlot', 'replacechildren');
p2 = plot(ax2, tvec/3600,detrend_UM);
title(ax2,'Detrended Data');
ylabel(ax2, 'Phase (deg)');

ax1 = nexttile;
p1=plot(ax1, tvec/3600, trend);
title(ax1,'Trend Removed');
ylabel(ax1,'Phase (deg)');
xlabel(ax1,'Time (UT hours)');

ax4 = nexttile;
set(ax4, 'ColorOrder', colors, 'NextPlot', 'replacechildren');
p4 = plot(ax4,tvec/3600,20*log10(dataFilAmp_UM_New));
title(ax4,"Machias Filtered");
ylabel(ax4,'Amplitude (dB)');

linkaxes([ax1 ax2 ax3 ax4],'x');
xlim([0 24]);

cb = colorbar('Ticks', ticks, 'TickLabels', ticklabel);
cb.Layout.Tile = 'east';
cb.Label.String = 'Date';

%% Explore trends removed

% edges = [-1200:25:-300];
% edges_UM = [-1000:10:-300];
% 
% hist = figure(2);
% histogram(day_slopes_WI,edges);
% mn_WI = string(round(mean(day_slopes_WI,'omitnan'),0));
% xline(mean(day_slopes_WI,'omitnan'),'-',{'Mean',mn_WI},'Color',[0 0.4470 0.7410]);
% 
% title('Slopes of Removed Trends - W.I. Day');
% ylabel('Counts');
% xlabel('Phase Drift (deg/day)');
% 
% hist2 = figure(3);
% histogram(day_slopes_UM,edges_UM,'FaceColor',[0.8500 0.3250 0.0980]);
% mn_UM = string(round(mean(day_slopes_UM,'omitnan'),0));
% m = mean(day_slopes_UM,'omitnan');
% xline(m,'-',{'Mean',mn_UM},'Color',[0.8500 0.3250 0.0980]);
% 
% title('Slopes of Removed Trends - U.M. Day');
% ylabel('Counts');
% xlabel('Phase Drift (deg/day)');
% 
% hist3 = figure(4);
% slopes = [night_slopes_UM night_slopes_WI day_slopes_UM day_slopes_WI];
% histogram(slopes,edges,'FaceColor',[0.4940 0.1840 0.5560]);
% mn_all = string(round(mean(slopes,'omitnan'),0));
% m = mean(slopes,'omitnan');
% xline(m,'-',{'Mean',mn_all},'Color',[0.4940 0.1840 0.5560]);
% 
% title('All Slopes');
% ylabel('Counts');
% xlabel('Phase Drift (deg/day)');


%% Plot Data
h1 = tiledlayout(2,2,'TileSpacing', 'Compact');
xtick = [0 4 8 12 16 20 24];
colors = colormap(jet(numdays));
ax1 = nexttile;
set(ax1, 'ColorOrder', colors, 'NextPlot', 'replacechildren');
p1 = plot(ax1,tvec/3600,dataFilAmp_WI_New);
title(ax1,"Wallops Island");
ylabel(ax1,'Amplitude (dB)');

ax2 = nexttile(3);
set(ax2, 'ColorOrder', colors, 'NextPlot', 'replacechildren');
p2 = plot(ax2,tvec/3600,detrend_WI);
xlabel(ax2,'Time (UT hours)');
ylabel(ax2,'Phase (deg)');

ax3 = nexttile(2);
set(ax3, 'ColorOrder', colors, 'NextPlot', 'replacechildren');
p3 = plot(ax3,tvec/3600,20*log10(dataAmp_WI));
title(ax3,"Machias");
linkaxes([ax1 ax3],'y');

ax4 = nexttile(4);
set(ax4, 'ColorOrder', colors, 'NextPlot', 'replacechildren');
p4 = plot(ax4,tvec/3600,detrend_UM);
xlabel(ax4,'Time (UT hours)');
linkaxes([ax2 ax4],'y');
xticks([ax1 ax2 ax3 ax4],xtick);
linkaxes([ax1 ax2 ax3 ax4],'x');
xlim([0 24]);

cb = colorbar('Ticks', ticks, 'TickLabels', ticklabel);
cb.Layout.Tile = 'east';
cb.Label.String = 'Date';

%% Plot Amplitude Data
% close all
% h2 = figure(2);
% colors = colormap(jet(numdays));
% h2 = tiledlayout(3,2,'TileSpacing', 'Compact');
% xtick = [0 4 8 12 16 20 24];
% 
% ax1 = nexttile;
% set(ax1, 'ColorOrder', colors, 'NextPlot', 'replacechildren');
% p1 = plot(ax1,tvec/3600,20*log10(dataFilAmp_WI));
% title(ax1,"Wallops Island Filtered");
% ylabel(ax1,'Amplitude (dB)');
% ylim([10 60]);
% 
% ax2 = nexttile(3);
% set(ax2, 'ColorOrder', colors, 'NextPlot', 'replacechildren');
% p2 = plot(ax2,tvec/3600,dataFilAmp_WI_New);
% title(ax2,"Wallops Island New Filtered");
% ylabel(ax2,'Amplitude (dB)');
% 
% ax3 = nexttile(5);
% set(ax3, 'ColorOrder', colors, 'NextPlot', 'replacechildren');
% p3 = plot(ax3,tvec/3600,20*log10(dataAmp_WI));
% title(ax3,"Wallops Island Raw");
% ylabel(ax3,'Amplitude (dB)');
% xlabel(ax3,'Time (UT hours)');
% 
% ax4 = nexttile;
% set(ax4, 'ColorOrder', colors, 'NextPlot', 'replacechildren');
% p4 = plot(ax4,tvec/3600,20*log10(dataFilAmp_UM));
% title(ax4,"Machias Filtered");
% ylabel(ax4,'Amplitude (dB)');
% ylim([10 60]);
% 
% ax5 = nexttile;
% set(ax5, 'ColorOrder', colors, 'NextPlot', 'replacechildren');
% p5 = plot(ax5,tvec/3600,dataFilAmp_UM_New);
% title(ax5,"Machias New Filtered");
% ylabel(ax5,'Amplitude (dB)');
% 
% ax6 = nexttile;
% set(ax6, 'ColorOrder', colors, 'NextPlot', 'replacechildren');
% p6 = plot(ax6,tvec/3600,20*log10(dataAmp_UM));
% title(ax6,"Machias Raw");
% ylabel(ax6,'Amplitude (dB)');
% xlabel(ax6,'Time (UT hours)');
% 
% linkaxes([ax1 ax2 ax3],'y');
% linkaxes([ax4 ax5 ax6],'y');
% %xticks([ax1 ax2 ax3 ax4 ax5 ax6],xtick);
% linkaxes([ax1 ax2 ax3 ax4 ax5 ax6],'x');
% xlim([0 24]);
% 
% cb1=colorbar('Ticks', ticks, 'TickLabels', ticklabel);
% cb1.Layout.Tile = 'east';
% cb1.Label.String = 'Date';

%% Plot Single-Site Amplitude 

h5 = figure(3);
colors = colormap(jet(numdays));
ax3 = plot(tvec/3600,20*log10(dataAmp_WI));
colororder(colors);
title('Wallops Island NAA Raw');
ylabel('Amplitude (dB)');
xlabel('Time (UT hours)');
cb1=colorbar('Ticks', ticks, 'TickLabels', ticklabel);
cb1.Label.String = 'Date';

