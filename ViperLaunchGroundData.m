%Work with VIPER recievers UMM and WI

clear all; close all;

datadirWI = 'D:\LAIR Data\Wallops Island\Narrowband\';
dA_WI0 = dir([datadirWI '*NAA*000A.mat']);
dB_WI0 = dir([datadirWI '*NAA*000B.mat']);
dA_WI1 = dir([datadirWI '*NAA*001A.mat']);
dB_WI1 = dir([datadirWI '*NAA*001B.mat']);

datadirUM = 'D:\LAIR Data\UMM\UMM Narrowband\';
dA_UM0 = dir([datadirUM '*NAA*000A.mat']);
dB_UM0 = dir([datadirUM '*NAA*000B.mat']);
dA_UM1 = dir([datadirUM '*NAA*001A.mat']);
dB_UM1 = dir([datadirUM '*NAA*001B.mat']);

datadirTM = 'D:\LAIR Data\VIPER\Table Mountain\Narrowband\';
dA_TM0 = dir([datadirTM '*NAA*000A.mat']);
dB_TM0 = dir([datadirTM '*NAA*000B.mat']);
dA_TM1 = dir([datadirTM '*NAA*001A.mat']);
dB_TM1 = dir([datadirTM '*NAA*001B.mat']);

%% initialize dates

Launch_day  = datenum(2021,05,27);
Launch_time = 1*3600 + 15*60 +0;
Splash_time = 1*3600 + 25*60 + 0;
flight_Time = Splash_time-Launch_time;
startday = datenum(2021,05,25);
stopday = datenum(2021,05,28);

launchidx = Launch_day - startday +1;
startidx = launchidx - 1; 
startsec = Launch_time;
stopidx = launchidx +1 ;
stopsec = Splash_time;

numdays = stopday - startday + 1;
tvec = 0:1:86399;

%% read Amplitude data into array

dataAmp_WI0 = readData(dA_WI0, datadirWI, startday, stopday);
dataAmp_UM0 = readData(dA_UM0, datadirUM, startday, stopday);
dataAmp_TM0 = readData(dA_TM0, datadirTM, startday, stopday);
dataAmp_WI1 = readData(dA_WI1, datadirWI, startday, stopday);
dataAmp_UM1 = readData(dA_UM1, datadirUM, startday, stopday);
dataAmp_TM1 = readData(dA_TM1, datadirTM, startday, stopday);


%% read Phase data into array
dataPhase_WI0 = readData(dB_WI0, datadirWI, startday, stopday);
dataPhase_UM0 = readData(dB_UM0, datadirUM, startday, stopday);
dataPhase_TM0 = readData(dB_TM0, datadirTM, startday, stopday);



%% Plot Raw Data - Launch
small_tvec = tvec(startsec:stopsec);

h1 = tiledlayout(2,3,'TileSpacing', 'Compact');
clear annotation
ax1 = nexttile;
p1 = plot(ax1,small_tvec/3600,20*log10(dataAmp_WI0(startsec:stopsec,launchidx)));
title(ax1,"Wallops Island");
ylabel(ax1,'Amplitude (dB)');

% boxstart = 1 + .25;
% boxwidth = 1/(6);
% dim = [boxstart -200 boxwidth 300];
% col = [0.3010 0.7450 0.9330 0.4];
% rectangle(ax1, 'Position',dim,'FaceColor',col);
% x = [0.25 0.215];
% y = [0.65 0.75];
% annotation('textarrow',x,y,'String','Launch');

ax2 = nexttile(4);
p2 = plot(ax2,small_tvec/3600,unwrap(dataPhase_WI0(startsec:stopsec,launchidx), [],1));
xlabel(ax2,'Time (UT hours)');
ylabel(ax2,'Phase (deg)');
yline(ax2,0);
% rectangle(ax2, 'Position',dim,'FaceColor',col);

ax3 = nexttile(2);
p3 = plot(ax3,small_tvec/3600,20*log10(dataAmp_UM0(startsec:stopsec,launchidx)));
title(ax3,"Machias");
% rectangle(ax3, 'Position',dim,'FaceColor',col);

ax4 = nexttile(5);
p4 = plot(ax4,small_tvec/3600,unwrap(dataPhase_UM0(startsec:stopsec,launchidx),[],1));
yline(ax4,0);
xlabel(ax4,'Time (UT hours)');
% rectangle(ax4, 'Position',dim,'FaceColor',col);

ax5 = nexttile(3);
p5 = plot(ax5,small_tvec/3600,20*log10(dataAmp_TM0(startsec:stopsec,launchidx)));
title(ax5,'Table Mountain')
% rectangle(ax5, 'Position',dim,'FaceColor',col);

ax6 = nexttile(6);
p6 = plot(ax6,small_tvec/3600,unwrap(dataPhase_TM0(startsec:stopsec,launchidx)));
yline(ax6,0);
xlabel(ax6,'Time (UT hours)');
% rectangle(ax6, 'Position',dim,'FaceColor',col);

% linkaxes([ax1 ax3 ax5],'y');
linkaxes([ax2 ax4 ax6],'y');
linkaxes([ax1 ax2 ax3 ax4 ax5 ax6],'x');
xlim([startsec/3600 stopsec/3600]);


%% Plot Raw Data - +- day

WI_Cutoff = 30;
UM_Cutoff = 60;

WallopsA0 = [dataAmp_WI0(startsec:86400,startidx); dataAmp_WI0(:,launchidx); dataAmp_WI0(1:stopsec,stopidx)];
WallopsA1 = [dataAmp_WI1(startsec:86400,startidx); dataAmp_WI1(:,launchidx); dataAmp_WI1(1:stopsec,stopidx)];
WallopsB = [dataPhase_WI0(startsec:86400,startidx); dataPhase_WI0(:,launchidx); dataPhase_WI0(1:stopsec,stopidx)];
MachiasA0 = [dataAmp_UM0(startsec:86400,startidx); dataAmp_UM0(:,launchidx); dataAmp_UM0(1:stopsec,stopidx)];
MachiasA1 = [dataAmp_UM1(startsec:86400,startidx); dataAmp_UM1(:,launchidx); dataAmp_UM1(1:stopsec,stopidx)];
MachiasB = [dataPhase_UM0(startsec:86400,startidx); dataPhase_UM0(:,launchidx); dataPhase_UM0(1:stopsec,stopidx)];

WallopsA0_Fil = filterAmp(WallopsA0,WI_Cutoff);
WallopsA1_Fil= filterAmp(WallopsA1,WI_Cutoff);

MachiasA0_Fil = filterAmp(MachiasA0,UM_Cutoff);
MachiasA1_Fil = filterAmp(MachiasA1,UM_Cutoff);

WallopsA0 = 20*log10(WallopsA0);
WallopsA1 = 20*log10(WallopsA1);

dataAmp_WI = 20*log10(combineAmp(WallopsA0,WallopsA1));
dataAmp_UM = 20*log10(combineAmp(MachiasA0,MachiasA1));

dataFilAmp_WI = combineAmp(WallopsA0_Fil,WallopsA1_Fil);
dataFilAmp_UM = combineAmp(MachiasA0_Fil,MachiasA1_Fil);

% dataFilAmp_WI = filterAmp(dataAmp_WI,WI_Cutoff);
% dataFilAmp_UM = filterAmp(dataAmp_UM,UM_Cutoff);

l_tvec = -86400:1:86400+flight_Time;

h2 = tiledlayout(3,2,'TileSpacing', 'Compact');
clear annotation
ax1 = nexttile;
p1 = plot(ax1,l_tvec/3600,dataFilAmp_WI);
title(ax1,"Wallops Island Filtered and Combined");
ylabel(ax1,'Amplitude (dB)');

ax2 = nexttile();
p2 = plot(ax2,l_tvec/3600,(dataAmp_WI));
% xlabel(ax2,'Time Relative to Launch (hours)');
title(ax2,'Combined Channels');
ylabel(ax2,'Amplitude (dB)');
% yline(ax2,0);
% rectangle(ax2, 'Position',dim,'FaceColor',col);

ax3 = nexttile();
p3 = plot(ax3,l_tvec/3600,(WallopsA0_Fil));
title(ax3,"Wallops Channel 0 Filtered");
% rectangle(ax3, 'Position',dim,'FaceColor',col);

ax4 = nexttile();
p4 = plot(ax4,l_tvec/3600,(WallopsA0));
% yline(ax4,0);
title(ax4,'Wallops Channel 0 Raw');
xlabel(ax4,'Time Relative to Launch (hours)');
% rectangle(ax4, 'Position',dim,'FaceColor',col);

ax5 = nexttile();
p5 = plot(ax5,l_tvec/3600,WallopsA1_Fil);
title(ax5,"Wallops Channel 1 Filtered");
ylabel(ax5,'Amplitude (dB)');

ax6 = nexttile();
p6 = plot(ax6,l_tvec/3600,WallopsA1);
title(ax6,'Wallops Channel 1 Raw');
xlabel(ax6,'Time Relative to Launch (hours)');
ylabel(ax6,'Amplitude (dB)');
% yline(ax2,0);
% rectangle(ax2, 'Position',dim,'FaceColor',col);

linkaxes([ax1 ax2 ax3 ax4 ax5 ax6],'x');
xlim([-24 24]);

%%
l_tvec = -86400:1:86400+flight_Time;

h2 = tiledlayout(2,2,'TileSpacing', 'Compact');
clear annotation
ax1 = nexttile;
p1 = plot(ax1,l_tvec/3600,dataFilAmp_WI);
title(ax1,"Wallops Island");
ylabel(ax1,'Amplitude (dB)');
% boxstart = 1 + .25;
% boxwidth = 1/(6);
% dim = [boxstart -200 boxwidth 300];
% col = [0.3010 0.7450 0.9330 0.4];
% rectangle(ax1, 'Position',dim,'FaceColor',col);
% x = [0.25 0.215];
% y = [0.65 0.75];
% annotation('textarrow',x,y,'String','Launch');

ax2 = nexttile(3);
p2 = plot(ax2,l_tvec/3600,unwrap(WallopsB, [],1));
xlabel(ax2,'Time Relative to Launch (hours)');
ylabel(ax2,'Phase (deg)');
% yline(ax2,0);
% rectangle(ax2, 'Position',dim,'FaceColor',col);

ax3 = nexttile(2);
p3 = plot(ax3,l_tvec/3600,dataFilAmp_UM);
title(ax3,"Machias");
% rectangle(ax3, 'Position',dim,'FaceColor',col);

ax4 = nexttile(4);
p4 = plot(ax4,l_tvec/3600,unwrap(MachiasB,[],1));
% yline(ax4,0);
xlabel(ax4,'Time Relative to Launch (hours)');
% rectangle(ax4, 'Position',dim,'FaceColor',col);

%linkaxes([ax1 ax3],'y');
linkaxes([ax2 ax4],'y');
linkaxes([ax1 ax2 ax3 ax4 ax5 ax6],'x');
xlim([-24 24]);