function [combinedAmp] = combineAmp(ch0,ch1)
%CombineAmp takes two channel amplitude data and combines it into 'true'
%amplitude

L0 = length(ch0);
L1 = length(ch1);
if L0>L1
    Len = L0;
else
    Len = L1;
end
combinedAmp = NaN*ones(Len,1);

for i=1:Len
 if ~isnan(ch0(i)) && ~isnan(ch1(i))
     combinedAmp(i) = sqrt(ch0(i)^2 + ch1(i)^2);
end

end

