function [output] = EMGProcess_new(M, filter_coff_b, filter_coff_a, rmsRate)
  
    col_size = max(size(M))-rmsRate+1;
    
    temp_output = zeros(col_size,6);
    
    for i=1:6
        
        x = M(:,i);
        y = filter(filter_coff_b,filter_coff_a,x);
        
        for j=1:col_size
            
            t = 0;
            rms_range = 0;
            
            while rms_range < rmsRate
                t = t+y(j+rms_range)^2;
                rms_range = rms_range + 1;
            end
            
            z(j,1) = (t/rmsRate)^(0.5);
        end
        
       temp_output(:,i) = z;
       
    end
    
    output = temp_output;

end