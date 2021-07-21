function [start,stop] = dateLength(data,datadir)
    dates = NaN(1,length(data));
    for i = 1:length(data)
        try
            file = load([datadir data(m).name]);
            dates(m) = datenum(file.start_year, file.start_month,file.start_day);
        catch
            fprintf('Could not load %s, moving on...\n',data(m).name);
        end
    end
    start = min(dates,[],'omitnan');
    stop = max(dates,[], 'omitnan');
end
