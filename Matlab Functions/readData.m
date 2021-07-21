function data = readData(data_struct,data_dir,start,stop)
%readData Parses a directory  of narrowband files and extracts the data.
%   To keep consistency across multiple datasets, start and stop establish
%   bounds in time. 
data = NaN*ones(86400,stop-start+1);
for m = 1:length(data_struct)
    try
        file = load([data_dir data_struct(m).name]);
        
        thisday = datenum(file.start_year,file.start_month,file.start_day);
        if thisday<=stop && thisday>=start
            dayind=thisday-start+1;
            thissec = file.start_hour*3600 + file.start_minute*60 + file.start_second;
            secind = thissec + 1;
            stopind = secind + length(file.data) -1;
            data(secind:stopind,dayind) = file.data;
        end
    catch
        fprintf('Could not load %s, moving on... \n',data_struct(m).name);
    end
end

