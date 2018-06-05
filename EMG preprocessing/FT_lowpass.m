function output = FT_lowpass(Fs, n, low_cut, signal)

[b,a] = butter(n, low_cut/(Fs/2));
output  = filter(b,a,signal);

end