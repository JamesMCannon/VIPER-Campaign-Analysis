function [dataFil] = filterAmp(data,minDB)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here Expects raw data, not 20*log10()
numdays = size(data,2);
dataFil=20*log10(data);
factor = 5; %n-sigma bound before tossing data
winSize = 300;
Window=NaN*ones(winSize,1);
secs_since_new_win = 0;
num_sec = size(data,1);
first_win = true;
for dayind = 1:numdays
    for thissec=1:num_sec
        data = dataFil(thissec,dayind);
        currentWindow=NaN*ones(winSize,1);
        if data<minDB
            dataFil(thissec,dayind) = NaN;
        else
            newWin_FLAG = false;
            if thissec>winSize
            currentWindow(:) = dataFil(thissec-winSize:thissec-1,dayind);
            elseif dayind>1
                if thissec>2
                dif = winSize-thissec+1;
                currentWindow(1:dif) = dataFil(num_sec+1-dif:num_sec,dayind-1);
                currentWindow(dif+1:winSize) = dataFil(1:thissec-1,dayind);
                elseif thissec==2
                dif = winSize - 1;
                currentWindow(1:dif) = dataFil(num_sec+1-dif:num_sec,dayind-1);
                currentWindow(winSize) = dataFil(1,dayind);
                else
                dif = winSize;
                currentWindow(1:dif) = dataFil(num_sec+1-dif:num_sec,dayind-1);
                end
            else
            currentWindow = dataFil(1:winSize,dayind);
            end
            
            currNaN = sum(isnan(currentWindow));
            winNaN = sum(isnan(Window));
            
            if (currNaN<(winSize/2) || winNaN==300)
                if ~isnan(data) && first_win
                    first_win = false;
                    currentWindow = dataFil(thissec:thissec+winSize,dayind);
                    currNaN = sum(isnan(currentWindow));
                end
                Window = currentWindow;
                secs_since_new_win = 0; 
            else
                secs_since_new_win = secs_since_new_win +1;
            end
            if secs_since_new_win == 0
                accept_range = factor*std(Window,'omitnan');
            else
                scale = 1+ secs_since_new_win/300;
                if scale > 4
                    scale=4;
                end
                accept_range = scale*factor*std(Window,'omitnan');
            end
            m = mean(Window,'omitnan');

            if (dataFil(thissec,dayind)<(m-accept_range)) || (dataFil(thissec,dayind)>(m+2*accept_range)) || dataFil(thissec,dayind)<minDB
            dataFil(thissec,dayind) = NaN;
            end
        end
    end
end
        

end

