function [night_slopes,day_slopes] = phaseDrift(Phase)
%detrendPhase removes a linear drift from phase data
%   To avoid spikes during day-night/night-day transitions,
%   data set is split into smooth segments which seperately have 
%   slopes identified. The average of all identified slopes is then
%   subtracted from all data. Requires var:Phase be the unwraped phase
tvec = 0:1:86399;
dawn = 9 * 3600; %Hour (UTC) * Seconds/Hour
enddawn = 13 *3600;
dusk = 20 *3600;

night = Phase(1:dawn,:);
day = Phase(enddawn:dusk,:);

night_detrend = detrend(night,'omitnan');
day_detrend = detrend(day,'omitnan');

night_trend = night-night_detrend;
day_trend = day-day_detrend;

night_slopes = getSlopes(night_trend);
day_slopes = getSlopes(day_trend);
all_slopes = [night_slopes, day_slopes];
avg_slope = mean(all_slopes,'omitnan');
trend = avg_slope/86400 * tvec;

de_trend= NaN*ones(86400,size(Phase,2));
for i=1:size(Phase,2)
    de_trend(:,i) = Phase(:,i) - transpose(trend);
end

end


function [slopes] = getSlopes(data_trend)
discard_slope = -200; %phase drift per day that is too large to be consistent with data
tvec = 0:1:length(data_trend)-1;
seconds = length(data_trend);

temp = data_trend;
temp(:, sum(isnan(temp), 1) >= 0.15*seconds) = []; %Percent error allowed * number of seconds
trend = fillmissing(temp, 'linear');
szdim = size(trend,2);
xmat = NaN* ones(seconds,szdim);
for i=1:szdim
    xmat(:,i)=tvec;
end
p = NaN*ones(2,szdim);
c=0; %count
for i=1:szdim
    p(:,i) = polyfit(tvec,trend(:,i),1);
    if p(1,i)*86400<discard_slope
        c=c+1;
    end
end
slopes = NaN*ones(1,szdim);
j=1;
for i=1:szdim
    p(:,i) = polyfit(tvec,trend(:,i),1);
    if p(1,i)*86400<discard_slope
       slopes(j)=p(1,i);
       j=j+1;
    end
end
slopes = 86400 * slopes; %transform from deg/sec to deg/day
end
