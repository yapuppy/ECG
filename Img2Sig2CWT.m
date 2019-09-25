function Img2Sig2CWT(fn,Rawimg,Rawbase,Type)
fn(end-3:end)=[];

switch Type
    case 'Less'
        base=Rawbase(327:1300,68:2128); %Less
        img=Rawimg(327:1300,68:2128); %Less
    case 'Yellow'
        base=Rawbase(180:682,80:1078);%yellow
        img=Rawimg(180:682,80:1078); %yellow
    case 'Pink'
        base=Rawbase(281:626,79:991);%Pink
        img=Rawimg(281:626,79:991); %Pink
end

[x y]=size(base);
for m1=1:x
    for n1=1:y
        if (base(m1,n1)>=130) %  Pink: 130
            Base(m1,n1,1)=255;
        else
            Base(m1,n1,1)=0;
        end
    end
end
% -------------------��ƤG�Ȥ�-------------------------------
for m1=1:x
    for n1=1:y
        if (img(m1,n1)>=130) %�G�Ȥƪ���
            Img(m1,n1,1)=255;
        else
            Img(m1,n1,1)=0;
        end
    end
end
% ------------------�h���ɵ{�Ʀr-------------
Img2=Base-Img;
Img2(1:35,:)=0;
for m1=1:x
    for n1=1:y
        if (Img2(m1,n1)==0) %�G�Ȥƪ���
            Img3(m1,n1,1)=255;
        else
            Img3(m1,n1,1)=0;
        end
    end
end
%-------------------------�R���S���Qbase��������Wpixel---------------------
for m1=2:x-1
    for n1=2:y-1
        if Img3(m1,n1)==0
            [bx by]=find((Img3(m1-1:m1+1,n1-1:n1+1))==0);
            if length(bx)==1
                Img3(m1,n1)=255;
            end
        end
    end
end

%----------------------------------------------------------------------
switch Type
    case 'Less'
    LeadSegment=[157 556 657 1056 1157 1556 1631 2030]; %Less
    case 'Yellow'
    LeadSegment=[51 230 281 500 551 750 798 997]; %yellow
    case 'Pink'
    LeadSegment=[36 223 270 457 497 684 725 912]; %pink
end
for n3=1:4
    LeadA=Img3(:,LeadSegment(2*n3-1):LeadSegment(2*n3));
    [x1 y1]=size(LeadA);
    e=1;
    for n1=1:y1
        if find(LeadA(:,n1)==0)
            Px1=find(LeadA(:,n1)==0);%�i�H�令LeadA�N�n
            Px2=diff(Px1);
            dPx=find(Px2>3)+1;
            if length(dPx)>=2
                lead1(1,e)=min(Px1(1:dPx(1)-1));
                lead2(1,e)=min(Px1(dPx(1):dPx(2)-1));
                lead3(1,e)=min(Px1(dPx(2):end));
                
                lead1(2,e)=median(Px1(1:dPx(1)-1));
                lead2(2,e)=median(Px1(dPx(1):dPx(2)-1));
                lead3(2,e)=median(Px1(dPx(2):end));
                
                lead1(3,e)=max(Px1(1:dPx(1)-1));
                lead2(3,e)=max(Px1(dPx(1):dPx(2)-1));
                lead3(3,e)=max(Px1(dPx(2):end));
                e=e+1;
            end
        end
    end
    lead1=lead1*-1;
    lead2=lead2*-1;
    lead3=lead3*-1;
    for n2=1:length(lead1(1,:))
        Lead1(n2*3-2:n2*3)=lead1(1:3,n2)';
        Lead2(n2*3-2:n2*3)=lead2(1:3,n2)';
        Lead3(n2*3-2:n2*3)=lead3(1:3,n2)';
    end
    Lead1=smooth(Lead1,10,'moving');
    Lead2=smooth(Lead2,10,'moving');
    Lead3=smooth(Lead3,10,'moving');
    
    Lead1=Lead1-mean(Lead1);
    Lead2=Lead2-mean(Lead2);
    Lead3=Lead3-mean(Lead3);
    fs=1000;
    x=1/fs:1/fs:2;
    L1=[length(Lead1) length(Lead2) length(Lead3)];
    D1=linspace(0,2.4,L1(1));
    D2=linspace(0,2.4,L1(2));
    D3=linspace(0,2.4,L1(3));
    
    Lead1_Calibration=(spline(D1,Lead1,x))/8;
    Lead2_Calibration=(spline(D2,Lead2,x))/8;
    Lead3_Calibration=(spline(D3,Lead3,x))/8;
        %------------------�P�_�W�U-----------------------
        px=[400 1600];

        FLead1_Calibration=abs(Lead1_Calibration-mean(Lead1_Calibration));
        LMAX1=max((FLead1_Calibration(px(1):px(2))));
        xa=find(LMAX1==(FLead1_Calibration(px(1):px(2))));
        x1=xa(1);

        FLead2_Calibration=abs(Lead2_Calibration-mean(Lead2_Calibration));
        LMAX2=max((FLead2_Calibration(px(1):px(2))));
        xb=find(LMAX2==(FLead2_Calibration(px(1):px(2))));
        x2=xb(1);

        FLead3_Calibration=abs(Lead3_Calibration-mean(Lead3_Calibration));
        LMAX3=max((FLead3_Calibration(px(1):px(2))));
        xc=find(LMAX3==(FLead3_Calibration(px(1):px(2))));
        x3=xc(1);

    x1=x1+400;x2=x2+400;x3=x3+400;
%     X=X+500;

    Px=[x1-399 x1+399];
    Px2=[x2-399 x2+399];    
    Px3=[x3-399 x3+399];
    
    % TH=prctile(Lead1_Calibration,50);
    % [pks locs]=findpeaks(Lead1_Calibration,'Threshold',TH);
    %----------------Lead1 ���@�Ӫi+CWT--------------------------
%     SA=Lead1_Calibration(px(1):px(2));
%     SB=Lead2_Calibration(px(1):px(2));
%     SC=Lead3_Calibration(px(1):px(2));
    Lead1_SingleWave=Lead1_Calibration(Px(1):Px(2));
   
    Lead1fn=('Lead1.jpg');
    figure
    plot(Lead1_SingleWave)
    a=figure;
    cwt(Lead1_SingleWave,fs)
    colormap jet
    saveas(a,Lead1fn);
    
    Lead2_SingleWave=Lead2_Calibration(Px2(1):Px2(2));
    figure
    plot(Lead2_SingleWave)
    Lead2fn=('Lead2.jpg');
    b=figure;
    cwt(Lead2_SingleWave,fs)
    colormap jet
    saveas(b,Lead2fn);
    
    Lead3_SingleWave=Lead3_Calibration(Px3(1):Px3(2));
    figure
    plot(Lead3_SingleWave)
    Lead3fn=('Lead3.jpg');
    c=figure;
    cwt(Lead3_SingleWave,fs)
    colormap jet
    saveas(c,Lead3fn);
    
    
    %---------------------------�ĤG����-----------------------------
    CWT_lead1_img=imread(Lead1fn);
    CWT_lead2_img=imread(Lead2fn);
    CWT_lead3_img=imread(Lead3fn);
    
    CWTLeadA_fn={'Lead I';'aVR';'V1';'V4'};
    CWTLeadB_fn={'Lead II';'aVL';'V2';'V5'};
    CWTLeadC_fn={'Lead III';'aVF';'V3';'V6'};
    JPGfile='.jpg';
    close all
    %改存圖座標
    ImgCWT1=CWT_lead1_img(126:692,125:874,1:3);%pink:693 yellow:711
    imshow(ImgCWT1)
    saveas(gcf,[cell2mat(CWTLeadA_fn(n3)) '-' fn JPGfile])
%     savefig([fn '_' cell2mat(CWTLeadA_fn(n3))])
    %改存圖座標
    ImgCWT2=CWT_lead2_img(126:692,125:874,1:3);
    imshow(ImgCWT2)
    saveas(gcf,[cell2mat(CWTLeadB_fn(n3)) '-' fn JPGfile])
%     savefig([fn '_' cell2mat(CWTLeadB_fn(n3))])
    %改存圖座標
    ImgCWT3=CWT_lead3_img(126:692,125:874,1:3);
    imshow(ImgCWT3)
    saveas(gcf,[cell2mat(CWTLeadC_fn(n3)) '-' fn JPGfile])
%     savefig([fn '_' cell2mat(CWTLeadC_fn(n3))])
    ECG_Signal(n3*3-2:n3*3,:)=[Lead1_SingleWave;Lead2_SingleWave;Lead3_SingleWave];
end
for nn=1:12
    ECG_Signal(:,nn)=(ECG_Signal(:,nn)-mean(ECG_Signal(:,nn)));
end
Sigfn=[fn '_12 leads.xlsx'];
ECG_Signal=ECG_Signal';
ECG_Signal(1:13,:)=[];
xlswrite(Sigfn,ECG_Signal)