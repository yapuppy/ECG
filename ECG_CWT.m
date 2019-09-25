function ECG_CWT(fn,sig)
fn(end-12:end)=[];
% CWTLeadA_fn={'Lead I.jpg';'aVR.jpg';'V1.jpg';'V4.jpg'};
% CWTLeadB_fn={'Lead II.jpg';'aVL.jpg';'V2.jpg';'V5.jpg'};
% CWTLeadC_fn={'Lead III.jpg';'aVF.jpg';'V3.jpg';'V6.jpg'};
Leads={'lead1.jpg';'lead2.jpg';'lead3.jpg'};
CWTfn={'Lead I';'Lead II';'Lead III';'aVR';'aVL';'aVF';'V1';...
    'V2';'V3';'V4';'V5';'V6'};
JPGFile='.jpg';
n2=[1 2 3 1 2 3 1 2 3 1 2 3];
for n=1:12
    N=length(sig(:,n));
    t = (1:N)/1000;
    a=figure;
    CWTcoeffs = cwt(sig(:,n),1:180,'db8');  % cwt coefficients with 180 scaling
    imagesc(t,1:180,abs(CWTcoeffs)); %coeff. image is then displayed
    colormap jet
    
    saveas(a,cell2mat(Leads(n2(n))));
    close all
    img=imread(cell2mat((Leads(n2(n)))));
    %改圖座標
    ImgCWT=img(58:690,135:939,1:3);
    imshow(ImgCWT)
    
    saveas(gcf,[cell2mat(CWTfn(n)) '_' fn JPGFile ]);
    close all
end