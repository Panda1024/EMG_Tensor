clc
clearvars variables
clearvars -except keepVariables
clearvars variables -except keepVariables
clearvars -global 2
close all;

%% Subject Num

subject_num='1';


data1=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_0000.csv')); %1. 불러올 xls 파일 이름
data2=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_0045.csv')); %1. 불러올 xls 파일 이름
data3=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_0090.csv')); %1. 불러올 xls 파일 이름
data4=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_00-45.csv')); %1. 불러올 xls 파일 이름
data5=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_00-90.csv')); %1. 불러올 xls 파일 이름
data6=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_1500.csv')); %1. 불러올 xls 파일 이름
data7=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_1545.csv')); %1. 불러올 xls 파일 이름
data8=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_1590.csv')); %1. 불러올 xls 파일 이름
data9=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_15-45.csv')); %1. 불러올 xls 파일 이름
data10=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_15-90.csv')); %1. 불러올 xls 파일 이름
data11=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_-1500.csv')); %1. 불러올 xls 파일 이름
data12=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_-1545.csv')); %1. 불러올 xls 파일 이름
data13=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_-1590.csv')); %1. 불러올 xls 파일 이름
data14=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_-15-45.csv')); %1. 불러올 xls 파일 이름
data15=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_-15-90.csv')); %1. 불러올 xls 파일 이름
data16=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_3000.csv')); %1. 불러올 xls 파일 이름
data17=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_3045.csv')); %1. 불러올 xls 파일 이름
data18=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_3090.csv')); %1. 불러올 xls 파일 이름
data19=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_30-45.csv')); %1. 불러올 xls 파일 이름
data20=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_30-90.csv')); %1. 불러올 xls 파일 이름
data21=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_-3000.csv')); %1. 불러올 xls 파일 이름
data22=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_-3045.csv')); %1. 불러올 xls 파일 이름
data23=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_-3090.csv')); %1. 불러올 xls 파일 이름
data24=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_-30-45.csv')); %1. 불러올 xls 파일 이름
data25=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_-30-90.csv')); %1. 불러올 xls 파일 이름
data26=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_0000_free.csv')); %1. 불러올 xls 파일 이름
data27=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_00225_free.csv')); %1. 불러올 xls 파일 이름
data28=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_22500_free.csv')); %1. 불러올 xls 파일 이름
data29=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_225225_free.csv')); %1. 불러올 xls 파일 이름
data30=xlsread(sprintf('%s%s%s','sub',num2str(subject_num),'_-1500_t1.csv')); %1. 불러올 xls 파일 이름


[b,a] = butterWorthBandpass(500,6,10,200); %EMG filtering parameters

%% Regular Exp
for n=1:25
    eval( sprintf('emg_raw%d =  data%d(:,2:7);',n,n)); %extract EMG
    eval( sprintf('force_raw%d =  data%d(:,8);',n,n));  %extract force
    eval( sprintf('time_range_start%d =  1000;',n) );    %start time
    
    time_range_start7 = 1500;
    time_range_start10 = 1600;
    time_range_start15 = 1500;
    time_range_start22 = 1500;
    time_range_start25 = 1600;

    eval( sprintf('cutting_end%d = time_range_start%d + 2500;',n,n));    %delete useless signal from backward
    eval( sprintf('emg_processed%d = EMGProcess_new(emg_raw%d,b,a,500);',n,n));     % emg processing
    eval( sprintf('force_processed%d = FT_lowpass(500,6,10,force_raw%d);',n,n));    % force processing
    %eval( sprintf('force_processed_norm%d = force_processed%d(time_range_start%d:end) - min(force_processed%d(time_range_start%d:cutting_end%d));',n,n,n,n,n,n));
    eval( sprintf('force_processed_norm%d = force_processed%d(time_range_start%d:end) - force_processed%d(time_range_start%d) +1;',n,n,n,n,n));
    eval( sprintf('time_range_end%d = SettingForceRange(49.0, 52.0, force_processed_norm%d);',n,n));    % force processing

end

%% Free Exp 
for n=26:30
    eval( sprintf('emg_raw%d =  data%d(:,2:7);',n,n)); %extract EMG
    eval( sprintf('force_raw%d =  data%d(:,8);',n,n));  %extract force
    eval( sprintf('time_range_start%d =  1000;',n) );    %start time
    
    eval( sprintf('cutting_end%d = time_range_start%d + 2500;',n,n));    %delete useless signal from backward
    eval( sprintf('emg_processed%d = EMGProcess_new(emg_raw%d,b,a,500);',n,n));     % emg processing
    eval( sprintf('force_processed%d = FT_lowpass(500,6,10,force_raw%d);',n,n));    % force processing
    %eval( sprintf('force_processed_norm%d = force_processed%d(time_range_start%d:end) - min(force_processed%d(time_range_start%d:cutting_end%d));',n,n,n,n,n,n));
    eval( sprintf('force_processed_norm%d = force_processed%d(time_range_start%d:end) - force_processed%d(time_range_start%d) +1;',n,n,n,n,n));
    eval( sprintf('time_range_end%d = SettingForceRange(35.0, 41.0, force_processed_norm%d);',n,n));    % force processing

end

%% Indexing & Force AVG


for n=1:30
    
    %time_range_end10 = 5000;
    
    eval( sprintf('emg_processed_final%d = emg_processed%d(time_range_start%d:time_range_end%d, :)',n,n,n,n));
    eval( sprintf('force_processed_final%d = force_processed_norm%d(1:time_range_end%d)',n,n,n));
%    eval( sprintf('force_average = force_average + force_processed_final%d ',n));
    eval( sprintf('emg_final%d = resample(emg_processed_final%d, 4000, length(emg_processed_final%d));',n,n,n));
    eval( sprintf('force_final%d = resample(force_processed_final%d, 4000, length(force_processed_final%d));',n,n,n));
    
end

temp = 0;

for n=1:25
    eval( sprintf('temp = temp + force_final%d;',n));
end
force_average = temp /25.0;

%% Dynamic Time Warping 

for n=1:30
    eval( sprintf('[dist%d, ix%d, iy%d] = dtw(force_average, force_final%d);',n,n,n,n));
%     eval( sprintf('t%d = transpose(iy%d);',n,n));
    eval( sprintf(' FORCE%d = force_final%d(iy%d);', n,n,n));
    eval( sprintf(' EMG%d = emg_final%d(iy%d,:);',n,n,n));

     eval( sprintf('FORCE%d = resample(FORCE%d, 5800, length(FORCE%d));',n,n,n));
     eval( sprintf('EMG%d = resample(EMG%d, 5800, length(EMG%d));',n,n,n));   
end

%% Save & Plot 

figure();
subplot(2,5,1);
plot(emg_processed_final1);
subplot(2,5,2);
plot(emg_processed_final2);
subplot(2,5,3);
plot(emg_processed_final3);
subplot(2,5,4);
plot(emg_processed_final4);
subplot(2,5,5);
plot(emg_processed_final5);
subplot(2,5,6);
plot(force_processed_final1);
subplot(2,5,7);
plot(force_processed_final2);
subplot(2,5,8);
plot(force_processed_final3);
subplot(2,5,9);
plot(force_processed_final4);
subplot(2,5,10);
plot(force_processed_final5);


% time = data1(:,1);
% emg_raw = data1(:,2:7);
% force_raw = data1(:,8);
% 
% %% 시작점 지정요 
% time_range_start = 2500;
% cutting_end = time_range_start+5000;
% 
% %% EMG filtering
% [b,a] = butterWorthBandpass(500,6,10,200);
% emg_processed = EMGProcess_new(emg_raw,b,a,500);


%% FT filtering 
% Fs = 500;
% Fc = 10;
% [b2,a2] = butter(6, Fc/(Fs/2));
% force_processed  = filter(b2,a2,force_raw);

% figure();
% subplot(211);
% plot(emg_processed);
% subplot(212);
% plot(force_processed);

%% Indexing

% force_processed2 = force_processed(time_range_start:end) - min(force_processed(time_range_start:cutting_end));
% 
% for i=1:length(force_processed2)
% 
%     if (force_processed2(i,1)>=45.0 && force_processed2(i,1)<46.0)
%         time_range_end = i;
%         break;
%     end
% end
%  
% emg_processed_range = emg_processed(time_range_start:time_range_end, :);
% force_processed_range = force_processed2(time_range_start:time_range_end, :);



