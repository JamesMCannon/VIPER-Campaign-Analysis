function [de_trend] = detrendPhase(Phase,slope)
%detrendPhase removes a known slope from phase data. var:Phase should
%already be unwraped. Don't detrend days which have an overall phase drift less than 75%
%less than 75% of var:slope
tvec = 0:1:86399;
trend = slope/86400 * tvec;
de_trend= NaN*ones(86400,size(Phase,2));
for i=1:size(Phase,2)
    date = Phase(:,i);
    [P0,t0] = firstVal(date);
    [Pf,tf] = lastVal(date);
    del_t = tf-t0;
    del_P = Pf-P0;
    if (del_P/del_t) < 0.25 * slope/86400
        de_trend(:,i) = Phase(:,i) - transpose(trend);
    else
        de_trend(:,i) = Phase(:,i);
    end
end
end

function [value,t] = firstVal(datePhase)
value = NaN;
t = NaN;
for i=1:86400
    if ~isnan(datePhase(i)) %If the value at i is not a NaN
        value = datePhase(i);
        t=i;
        break
    end
end
end

function [value,t] = lastVal(datePhase)
value = NaN;
t = NaN;
for i=86400:-1:1
    if ~isnan(datePhase(i)) %If the value at i is not a NaN
        value = datePhase(i);
        t=i;
        break
    end
end
end
