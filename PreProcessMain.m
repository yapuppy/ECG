clc;clear;close all
%base種類
BaseData=imread('base1.jpg');
cd /home/linlab/Documents/Jess/振揚ecg轉換程式/data
%cd C:\Users\USER\Desktop\ECG�e�B�z\Lessyellow\PatientData\Yellow\
files = dir('*H*.jpg');

tic
for n2=1:1%length(files)
    img=[];
    cd /home/linlab/Documents/Jess/振揚ecg轉換程式/data
    %cd C:\Users\USER\Desktop\ECG�e�B�z\Lessyellow\PatientData\Yellow\
    img=imread(files(n2).name);
    cd /home/linlab/Documents/Jess/振揚ecg轉換程式/data_output
    %cd C:\Users\USER\Desktop\ECG�e�B�z\Lessyellow\PatientResults
    n2
    Img2Sig2CWT(files(n2).name,img,BaseData,'Pink');%Yellow,Pink,Less
    
end
toc