function output = SettingForceRange(low_cut, high_cut, signal)
for i=1:length(signal)
    if (signal(i,1)>=low_cut && signal(i,1)<high_cut)
        output = i;
        break;
    end
end
end