clc;clear;close all %�ĤG���ഫ����k

cd /home/linlab/Documents/Jess/振揚ecg轉換程式/data_2
files = dir('*H*xlsx');
% cd C:\Users\����\Desktop\ECG�e�B�z\Lessyellow\

tic
for n2=1:length(files)
    sig=[];
    cd /home/linlab/Documents/Jess/振揚ecg轉換程式/data_2
    sig=xlsread(files(n2).name);
    cd /home/linlab/Documents/Jess/振揚ecg轉換程式/data_2_output
    n2
    
    ECG_CWT(files(n2).name,sig);
    
end
toc