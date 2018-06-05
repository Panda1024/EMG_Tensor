function [b, a] = butterWorthBandpass(Fs, n, low_cut, high_cut)
   
    Wn = [low_cut high_cut];    
    Fn=Fs/2; %Nyquist frequency
    ftype='bandpass';
         [b, a] = butter(n, Wn/Fn, ftype);

end