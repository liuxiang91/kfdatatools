function [ t1 ] = Table1( train, test ,train_int,test_int)
%TABLE1 Summary of this function goes here
%   Detailed explanation goes here

t1={'No of Eyes', size(train,1)-1};

eyeid=train(2:end,1);
pidAll={};
for i=1:size(eyeid,1)
    pid=eyeid{i,1};
    pid=strrep(pid,'AGIS','');
    pid=strrep(pid,'CIGTS','');
    pid=strrep(pid,'L','');
    pid=strrep(pid,'R','');
    pidAll=[pidAll;pid];
end
t1=[t1; {'No of Patients', length(pidAll)}];
t1=[t1; {'Sex',''}];
numMale=0;
numFemale=0;
for i=2:size(train,1)
    if min(train{i,6})==1
        numMale=numMale+1;
    else
        numFemale=numFemale+1;
    end
end
t1=[t1; {'Male', numMale}];
t1=[t1; {'Female', numFemale}];






t1=[t1; {'Race',''}];
White=0;
Black=0;
Other=0;
for i=2:size(train,1)
    if min(train{i,5})==1
        White=White+1;
    elseif min(train{i,5})==2
        Black=Black+1;
    else
        Other=Other+1;
    end
end
t1=[t1; {'White', White}];
t1=[t1; {'Black', Black}];
t1=[t1; {'Other', Other}];



numTotVis=[];
for i=2:size(train,1)
    numTotVis=[numTotVis size(train{i,2},2)];
end
t1=[t1; {'Total No of visits', sum(numTotVis)}];

numTotIOPVis=[];
for i=2:size(train,1)
    iops=train{i,3}(2,:);
    numTotIOPVis=[numTotIOPVis sum(~isnan(iops))];
end
t1=[t1; {'Total No of IOP visits', sum(numTotIOPVis)}];

numTotVFVis=[];
for i=2:size(train,1)
    vfs=train{i,3}(1,:);
    numTotVFVis=[numTotVFVis sum(~isnan(vfs))];
end
t1=[t1; {'Total No of VF visits', sum(numTotVFVis)}];
t1=[t1; {'No of visits per patient', [num2str(mean(numTotVis),'%.2f'),' (',num2str(std(numTotVis),'%.2f'),')']}];
t1=[t1; {'No of IOP visits per patient', [num2str(mean(numTotIOPVis),'%.2f'),' (',num2str(std(numTotIOPVis),'%.2f'),')']}];
t1=[t1; {'No of VF visits per patient', [num2str(mean(numTotVFVis),'%.2f'),' (',num2str(std(numTotVFVis),'%.2f'),')']}];



Interval=[];
for i=2:size(train,1)
    interval=train{i,2}(1,:);
    interval=interval(interval>0);
    intdif=diff(interval);
    Interval=[Interval (mean(intdif))];
end

t1=[t1; {'Visit interval (month)', [num2str(mean(Interval),'%.2f'),' (',num2str(std(Interval),'%.2f'),')']}];




IOPInterval=[];
for i=2:size(train,1)
    interval=~isnan(train{i,3}(2,:)).*train{i,2}(1,:);
    interval=interval(interval>0);
    intdif=diff(interval);
    IOPInterval=[IOPInterval (mean(intdif))];
end

t1=[t1; {'IOP visit interval (month)', [num2str(mean(IOPInterval),'%.2f'),' (',num2str(std(IOPInterval),'%.2f'),')']}];


VFInterval=[];
for i=2:size(train,1)
    interval=~isnan(train{i,3}(1,:)).*train{i,2}(1,:);
    interval=interval(interval>0);
    intdif=diff(interval);
    VFInterval=[VFInterval (mean(intdif))];
end

t1=[t1; {'VF visit interval (month)', [num2str(mean(VFInterval),'%.2f'),' (',num2str(std(VFInterval),'%.2f'),')']}];

FUlength=[];
for i=2:size(train,1)
    FUlength=[FUlength max(train{i,2})-min(train{i,2})];
end
t1=[t1; {'Followup Length (year)', [num2str(mean(FUlength)/12,'%.2f'),' (',num2str(std(FUlength./12),'%.2f'),')']}];


ageAll=[];
for i=2:size(train,1)
    ageAll=[ageAll mean(train{i,4})];
end
t1=[t1; {'Age (year)', [num2str(mean(ageAll)/365,'%.2f'),' (',num2str(std(ageAll./365),'%.2f'),')']}];


if size(train_int,2)>8
    
    SE=[];
    for i=2:size(train,1)
        SE=[SE mean(train{i,7})];
    end
    t1=[t1; {'Spherical Equivalent', [num2str(mean(SE),'%.2f'),' (',num2str(std(SE),'%.2f'),')']}];
    
    
    CCT=[];
    for i=2:size(train,1)
        CCT=[CCT mean(train{i,8})];
    end
    t1=[t1; {'CCT', [num2str(mean(CCT),'%.2f'),' (',num2str(std(CCT),'%.2f'),')']}];
    
    
    AL=[];
    for i=2:size(train,1)
        AL=[AL mean(train{i,9})];
    end
    t1=[t1; {'Axial Length', [num2str(mean(AL),'%.2f'),' (',num2str(std(AL),'%.2f'),')']}];
    
    
    DH=[];
    for i=2:size(train,1)
        DH=[DH sum(train{i,10})];
    end
    t1=[t1; {'Disk Hemorrhage per Patient', [num2str(mean(DH),'%.2f'),' (',num2str(std(DH),'%.2f'),')']}];
    
    prog=[];
    firstProg=[];
    for i=2:size(train_int,1)
        prog=[prog sum(train_int{i,12})];
        firstProg=[firstProg find(train_int{i,12},1,'first')];
    end
    t1=[t1; {'Progressions per Patient', [num2str(mean(prog),'%.2f'),' (',num2str(std(prog),'%.2f'),')']}];
    t1=[t1; {'Time to 1st Progresion (Yr)', [num2str(mean(firstProg./2),'%.2f'),' (',num2str(std(firstProg./2),'%.2f'),')']}];
    t1=[t1; {'No of Progressed Patients', num2str(sum(prog>0),'%.2f')}];
else
    t1=[t1; {'Spherical Equivalent', 'NA'}];
    SE=nan;
    CCT=nan;
    AL=nan;
    DH=nan;
    t1=[t1; {'CCT', 'NA'}];
    t1=[t1; {'Axial Length', 'NA'}];
    t1=[t1; {'Disk Hemorrhage per Patient', 'NA'}];
    prog=[];
    firstProg=[];
    for i=2:size(train_int,1)
        prog=[prog sum(train_int{i,8})];
        firstProg=[firstProg find(train_int{i,8},1,'first')];
    end
    t1=[t1; {'Progressions per Patient', [num2str(mean(prog),'%.2f'),' (',num2str(std(prog),'%.2f'),')']}];
    t1=[t1; {'Time to 1st Progresion (Yr)', [num2str(mean(firstProg./2),'%.2f'),' (',num2str(std(firstProg./2),'%.2f'),')']}];
    t1=[t1; {'No of Progressed Patients', num2str(sum(prog>0),'%.2f')}];
    
end



initIOP=[];
for i=2:size(train,1)
    initIOP=[initIOP train{i,3}(2,find(~isnan(train{i,3}(2,:))>0,1,'first'))];
end
t1=[t1; {'Initial IOP', [num2str(mean(initIOP),'%.2f'),' (',num2str(std(initIOP),'%.2f'),')']}];

initMD=[];
for i=2:size(train,1)
    initMD=[initMD train{i,3}(1,find(~isnan(train{i,3}(1,:))>0,1,'first'))];
end
t1=[t1; {'Initial MD', [num2str(mean(initMD),'%.2f'),' (',num2str(std(initMD),'%.2f'),')']}];

initPSD=[];
for i=2:size(train,1)
    initPSD=[initPSD train{i,3}(3,find(~isnan(train{i,3}(3,:))>0,1,'first'))];
end
t1=[t1; {'Initial PSD', [num2str(mean(initPSD),'%.2f'),' (',num2str(std(initPSD),'%.2f'),')']}];




IOP=[];
for i=2:size(train,1)
    readings=train{i,3}(2,:);
    readings=readings(~isnan(readings));
    IOP=[IOP mean(readings)];
end
t1=[t1; {'IOP', [num2str(mean(IOP),'%.2f'),' (',num2str(std(IOP),'%.2f'),')']}];

MD=[];
for i=2:size(train,1)
    readings=train{i,3}(1,:);
    readings=readings(~isnan(readings));
    MD=[MD mean(readings)];
end
t1=[t1; {'MD', [num2str(mean(MD),'%.2f'),' (',num2str(std(MD),'%.2f'),')']}];

PSD=[];
for i=2:size(train,1)
    readings=train{i,3}(3,:);
    readings=readings(~isnan(readings));
    PSD=[PSD mean(readings)];
end
t1=[t1; {'PSD', [num2str(mean(PSD),'%.2f'),' (',num2str(std(PSD),'%.2f'),')']}];




IOPv=[];
for i=2:size(train_int,1)
    readings=train_int{i,3}(5,:);
    readings=readings(~isnan(readings));
    IOPv=[IOPv mean(readings)];
end
t1=[t1; {'IOP velocity', [num2str(mean(IOPv),'%.2f'),' (',num2str(std(IOPv),'%.2f'),')']}];

MDv=[];
for i=2:size(train_int,1)
    readings=train_int{i,3}(4,:);
    readings=readings(~isnan(readings));
    MDv=[MDv mean(readings)];
end
t1=[t1; {'MD velocity', [num2str(mean(MDv),'%.2f'),' (',num2str(std(MDv),'%.2f'),')']}];

PSDv=[];
for i=2:size(train_int,1)
    readings=train_int{i,3}(6,:);
    readings=readings(~isnan(readings));
    PSDv=[PSDv mean(readings)];
end
t1=[t1; {'PSD velocity', [num2str(mean(PSDv),'%.2f'),' (',num2str(std(PSDv),'%.2f'),')']}];


IOPa=[];
for i=2:size(train_int,1)
    readings=train_int{i,3}(8,:);
    readings=readings(~isnan(readings));
    IOPa=[IOPa mean(readings)];
end
t1=[t1; {'IOP acceloration', [num2str(mean(IOPa),'%.2f'),' (',num2str(std(IOPa),'%.2f'),')']}];

MDa=[];
for i=2:size(train_int,1)
    readings=train_int{i,3}(7,:);
    readings=readings(~isnan(readings));
    MDa=[MDa mean(readings)];
end
t1=[t1; {'MD acceloration', [num2str(mean(MDa),'%.2f'),' (',num2str(std(MDa),'%.2f'),')']}];

PSDa=[];
for i=2:size(train_int,1)
    readings=train_int{i,3}(9,:);
    readings=readings(~isnan(readings));
    PSDa=[PSDa mean(readings)];
end
t1=[t1; {'PSD acceloration', [num2str(mean(PSDa),'%.2f'),' (',num2str(std(PSDa),'%.2f'),')']}];









if nargin==1
    return;
else % compute p values
    
    % https://onlinecourses.science.psu.edu/stat200/node/53
    
    
    pval=normcdf(((size(test,1)-1)/(size(train,1)-1)-0.5)/(sqrt(0.25/(size(test,1)+size(train,1)-2))),0,1);
    t2={'No of Eyes', size(test,1)-1, num2str(pval,'%.2f')};
    
    eyeid=test(2:end,1);
    TestpidAll={};
    for i=1:size(eyeid,1)
        pid=eyeid{i,1};
        pid=strrep(pid,'AGIS','');
        pid=strrep(pid,'CIGTS','');
        pid=strrep(pid,'L','');
        pid=strrep(pid,'R','');
        TestpidAll=[TestpidAll;pid];
    end
    
    p=0.5;
    
    pval=normcdf(((size(TestpidAll,1)-1)/(size(pidAll,1)-1)-0.5)/(sqrt(0.25/(size(TestpidAll,1)+size(pidAll,1)-2))),0,1);
    
    t2=[t2; {'No of Patients', length(TestpidAll), num2str(pval,'%.2f')}];
    
    
    
    % https://onlinecourses.science.psu.edu/stat414/node/268
    
    TestnumMale=0;
    TestnumFemale=0;
    for i=2:size(test,1)
        if min(test{i,6})==1
            TestnumMale=TestnumMale+1;
        else
            TestnumFemale=TestnumFemale+1;
        end
    end
    Testnum=TestnumMale+TestnumFemale;
    num=numMale+numFemale;
    p=(numMale+TestnumMale)/(Testnum+num);
    pval=1-normcdf((TestnumMale/Testnum-numMale/num)/sqrt(p*(1-p)*(1/num+1/Testnum)),0,1);
    
    
    
    
    t2=[t2; {'Sex','' ,num2str(pval,'%.2f')}];
    t2=[t2; {'Male', TestnumMale, ''}];
    t2=[t2; {'Female', TestnumFemale,''}];
    
    
    
    
    
    
    
    testWhite=0;
    testBlack=0;
    testOther=0;
    for i=2:size(test,1)
        if min(test{i,5})==1
            testWhite=testWhite+1;
        elseif min(test{i,5})==2
            testBlack=testBlack+1;
        else
            testOther=testOther+1;
        end
    end
    pval1=1-normcdf((testWhite/Testnum-White/num)/sqrt(p*(1-p)*(1/num+1/Testnum)),0,1);
    pval2=1-normcdf((testBlack/Testnum-Black/num)/sqrt(p*(1-p)*(1/num+1/Testnum)),0,1);
    pval3=1-normcdf((testOther/Testnum-Other/num)/sqrt(p*(1-p)*(1/num+1/Testnum)),0,1);
    t2=[t2; {'Race','',num2str(min([pval1,pval2,pval3]),'%.2f')}];
    t2=[t2; {'White', testWhite,''}];
    t2=[t2; {'Black', testBlack,''}];
    t2=[t2; {'Other', testOther,''}];
    
    TestnumTotVis=[];
    for i=2:size(test,1)
        TestnumTotVis=[TestnumTotVis; size(test{i,2},2)];
    end
    
    t2=[t2; {'Total No of visits', sum(TestnumTotVis), ''}];
    
    TestnumTotIOPVis=[];
    for i=2:size(test,1)
        iops=test{i,3}(2,:);
        TestnumTotIOPVis=[TestnumTotIOPVis sum(~isnan(iops))];
    end
    
    t2=[t2; {'Total No of IOP visits', sum(TestnumTotIOPVis), ''}];
    
    TestnumTotVFVis=[];
    for i=2:size(test,1)
        vfs=test{i,3}(1,:);
        TestnumTotVFVis=[TestnumTotVFVis sum(~isnan(vfs))];
    end
    
    t2=[t2; {'Total No of VF visits', sum(TestnumTotVFVis), ''}];
    [~,pval]=ttest2(TestnumTotVis,numTotVis);
    t2=[t2; {'Mean (SD) No of visits per patient', [num2str(mean(TestnumTotVis),'%.2f'),' (',num2str(std(TestnumTotVis),'%.2f'),')'],num2str(pval,'%.2f')}];
    [~,pval]=ttest2(TestnumTotIOPVis,numTotIOPVis);
    t2=[t2; {'Mean (SD) No of IOP visits per patient', [num2str(mean(TestnumTotIOPVis),'%.2f'),' (',num2str(std(TestnumTotIOPVis),'%.2f'),')'],num2str(pval,'%.2f')}];
    [~,pval]=ttest2(TestnumTotVFVis,numTotVFVis);
    t2=[t2; {'Mean (SD) No of VF visits per patient', [num2str(mean(TestnumTotVFVis),'%.2f'),' (',num2str(std(TestnumTotVFVis),'%.2f'),')'],num2str(pval,'%.2f')}];
    
    
    
    TestInterval=[];
    for i=2:size(test,1)
        interval=test{i,2}(1,:);
        interval=interval(interval>0);
        intdif=diff(interval);
        TestInterval=[TestInterval (mean(intdif))];
    end
    [~,pval]=ttest2(TestInterval,Interval);
    t2=[t2; {'Mean (SD) visit interval (month)', [num2str(mean(Interval),'%.2f'),' (',num2str(std(Interval),'%.2f'),')'], num2str(pval,'%.2f')}];
    
    
    
    
    TestIOPInterval=[];
    for i=2:size(test,1)
        interval=~isnan(test{i,3}(2,:)).*test{i,2}(1,:);
        interval=interval(interval>0);
        intdif=diff(interval);
        TestIOPInterval=[TestIOPInterval (mean(intdif))];
    end
    [~,pval]=ttest2(TestIOPInterval,IOPInterval);
    t2=[t2; {'Mean (SD) IOP visit interval (month)', [num2str(mean(TestIOPInterval),'%.2f'),' (',num2str(std(TestIOPInterval),'%.2f'),')'], num2str(pval,'%.2f')}];
    
    
    TestVFInterval=[];
    for i=2:size(test,1)
        interval=~isnan(test{i,3}(1,:)).*test{i,2}(1,:);
        interval=interval(interval>0);
        intdif=diff(interval);
        TestVFInterval=[TestVFInterval (mean(intdif))];
    end
    [~,pval]=ttest2(TestVFInterval,VFInterval);
    t2=[t2; {'Mean (SD) VF visit interval (month)', [num2str(mean(TestVFInterval),'%.2f'),' (',num2str(std(TestVFInterval),'%.2f'),')'], num2str(pval,'%.2f')}];
    
    TestFUlength=[];
    for i=2:size(test,1)
        TestFUlength=[TestFUlength max(test{i,2})-min(test{i,2})];
    end
    [~,pval]=ttest2(TestFUlength,FUlength);
    t2=[t2; {'Followup Length (year)', [num2str(mean(TestFUlength)/12,'%.2f'),' (',num2str(std(TestFUlength./12),'%.2f'),')'], num2str(pval,'%.2f')}];
    
    
    TestageAll=[];
    for i=2:size(test,1)
        TestageAll=[TestageAll mean(test{i,4})];
    end
    [~,pval]=ttest2(TestageAll,ageAll);
    t2=[t2; {'Age (year)', [num2str(mean(TestageAll)/365,'%.2f'),' (',num2str(std(TestageAll./365),'%.2f'),')'], num2str(pval,'%.2f')}];
    
    
    
    
    
    
    if size(test_int,2)>8
        
        TSE=[];
        for i=2:size(test,1)
            TSE=[TSE mean(test{i,7})];
        end
        [~,pval]=ttest2(TSE,SE);
        t2=[t2; {'Spherical Equivalent', [num2str(mean(TSE),'%.2f'),' (',num2str(std(TSE),'%.2f'),')'], num2str(pval,'%.2f')}];
        
        
        TCCT=[];
        for i=2:size(test,1)
            TCCT=[TCCT mean(test{i,8})];
        end
        [~,pval]=ttest2(CCT,TCCT);
        t2=[t2; {'CCT', [num2str(mean(TCCT),'%.2f'),' (',num2str(std(TCCT),'%.2f'),')'], num2str(pval,'%.2f')}];
        
        
        TAL=[];
        for i=2:size(test,1)
            TAL=[TAL mean(test{i,9})];
        end
        [~,pval]=ttest2(AL,TAL);
        t2=[t2; {'Axial Length', [num2str(mean(TAL),'%.2f'),' (',num2str(std(TAL),'%.2f'),')'], num2str(pval,'%.2f')}];
        
        
        TDH=[];
        for i=2:size(test,1)
            TDH=[TDH sum(test{i,10})];
        end
        [~,pval]=ttest2(DH,TDH);
        t2=[t2; {'Disk Hemorrhage Count', [num2str(mean(TDH),'%.2f'),' (',num2str(std(TDH),'%.2f'),')'], num2str(pval,'%.2f')}];
        Tprog=[];
        TfirstProg=[];
        for i=2:size(test_int,1)
            Tprog=[Tprog sum(test_int{i,12})];
            TfirstProg=[TfirstProg find(test_int{i,12},1,'first')];
        end
        [~,pval]=ttest2(prog,Tprog);
        t2=[t2; {'Progressins per Patient', [num2str(mean(Tprog),'%.2f'),' (',num2str(std(Tprog),'%.2f'),')'], num2str(pval,'%.2f')}];
        [~,pval]=ttest2(firstProg,TfirstProg);
        t2=[t2; {'Time to 1st Progresion (Yr)', [num2str(mean(TfirstProg./2),'%.2f'),' (',num2str(std(TfirstProg./2),'%.2f'),')'], num2str(pval,'%.2f')}];
        t2=[t2; {'No of Progressed Patients', num2str(sum(Tprog>0),'%.2f'), ''}];
    else
        t2=[t2; {'Spherical Equivalent', 'NA',''}];
        t2=[t2; {'CCT', 'NA',''}];
        t2=[t2; {'Axial Length', 'NA',''}];
        t2=[t2; {'Disk Hemorrhage per Patient', 'NA',''}];
        Tprog=[];
        TfirstProg=[];
        for i=2:size(test_int,1)
            Tprog=[Tprog sum(test_int{i,8})];
            TfirstProg=[TfirstProg find(test_int{i,8},1,'first')];
        end
        [~,pval]=ttest2(prog,Tprog);
        t2=[t2; {'Progressins per Patient', [num2str(mean(Tprog),'%.2f'),' (',num2str(std(Tprog),'%.2f'),')'], num2str(pval,'%.2f')}];
        [~,pval]=ttest2(firstProg,TfirstProg);
        t2=[t2; {'Time to 1st Progresion (Yr)', [num2str(mean(TfirstProg./2),'%.2f'),' (',num2str(std(TfirstProg./2),'%.2f'),')'], num2str(pval,'%.2f')}];
        t2=[t2; {'No of Progressed Patients', num2str(sum(Tprog>0),'%.2f'), ''}];
        
    end
    
    
    
    
    
    TestinitIOP=[];
    for i=2:size(test,1)
        TestinitIOP=[TestinitIOP test{i,3}(2,find(~isnan(test{i,3}(2,:))>0,1,'first'))];
    end
    [~,pval]=ttest2(TestinitIOP,initIOP);
    t2=[t2; {'Initial IOP', [num2str(mean(TestinitIOP),'%.2f'),' (',num2str(std(TestinitIOP),'%.2f'),')'], num2str(pval,'%.2f')}];
    
    TestinitMD=[];
    for i=2:size(test,1)
        TestinitMD=[TestinitMD test{i,3}(1,find(~isnan(test{i,3}(1,:))>0,1,'first'))];
    end
    [~,pval]=ttest2(TestinitMD,initMD);
    t2=[t2; {'Initial MD', [num2str(mean(TestinitMD),'%.2f'),' (',num2str(std(TestinitMD),'%.2f'),')'], num2str(pval,'%.2f')}];
    
    TestinitPSD=[];
    for i=2:size(test,1)
        TestinitPSD=[TestinitPSD test{i,3}(3,find(~isnan(test{i,3}(3,:))>0,1,'first'))];
    end
    [~,pval]=ttest2(TestinitPSD,initPSD);
    t2=[t2; {'Initial PSD', [num2str(mean(TestinitPSD),'%.2f'),' (',num2str(std(TestinitPSD),'%.2f'),')'], num2str(pval,'%.2f')}];
    
    
    
    
    TestIOP=[];
    for i=2:size(test,1)
        readings=test{i,3}(2,:);
        readings=readings(~isnan(readings));
        TestIOP=[TestIOP mean(readings)];
    end
    [~,pval]=ttest2(TestIOP,IOP);
    t2=[t2; {'IOP', [num2str(mean(TestIOP),'%.2f'),' (',num2str(std(TestIOP),'%.2f'),')'], num2str(pval,'%.2f')}];
    
    TestMD=[];
    for i=2:size(test,1)
        readings=test{i,3}(1,:);
        readings=readings(~isnan(readings));
        TestMD=[TestMD mean(readings)];
    end
    [~,pval]=ttest2(TestMD,MD);
    t2=[t2; {'MD', [num2str(mean(TestMD),'%.2f'),' (',num2str(std(TestMD),'%.2f'),')'], num2str(pval,'%.2f')}];
    
    TestPSD=[];
    for i=2:size(test,1)
        readings=test{i,3}(3,:);
        readings=readings(~isnan(readings));
        TestPSD=[TestPSD mean(readings)];
    end
    [~,pval]=ttest2(TestPSD,PSD);
    t2=[t2; {'PSD', [num2str(mean(TestPSD),'%.2f'),' (',num2str(std(TestPSD),'%.2f'),')'], num2str(pval,'%.2f')}];
    
    
    
    TestIOPv=[];
    for i=2:size(test_int,1)
        readings=test_int{i,3}(5,:);
        readings=readings(~isnan(readings));
        TestIOPv=[TestIOPv mean(readings)];
    end
    [~,pval]=ttest2(TestIOPv,IOPv);
    t2=[t2; {'IOP', [num2str(mean(TestIOPv),'%.2f'),' (',num2str(std(TestIOPv),'%.2f'),')'], num2str(pval,'%.2f')}];
    
    TestMDv=[];
    for i=2:size(test_int,1)
        readings=test_int{i,3}(4,:);
        readings=readings(~isnan(readings));
        TestMDv=[TestMDv mean(readings)];
    end
    [~,pval]=ttest2(TestMDv,MDv);
    t2=[t2; {'MD', [num2str(mean(TestMDv),'%.2f'),' (',num2str(std(TestMDv),'%.2f'),')'], num2str(pval,'%.2f')}];
    
    
    
    TestPSDv=[];
    for i=2:size(test_int,1)
        readings=test_int{i,3}(6,:);
        readings=readings(~isnan(readings));
        TestPSDv=[TestPSDv mean(readings)];
    end
    [~,pval]=ttest2(TestPSDv,PSDv);
    t2=[t2; {'PSD', [num2str(mean(TestPSDv),'%.2f'),' (',num2str(std(TestPSDv),'%.2f'),')'], num2str(pval,'%.2f')}];
    
    
    TestIOPa=[];
    for i=2:size(test_int,1)
        readings=test_int{i,3}(8,:);
        readings=readings(~isnan(readings));
        TestIOPa=[TestIOPa mean(readings)];
    end
    [~,pval]=ttest2(TestIOPa,IOPa);
    t2=[t2; {'IOP', [num2str(mean(TestIOPa),'%.2f'),' (',num2str(std(TestIOPa),'%.2f'),')'], num2str(pval,'%.2f')}];
    
    TestMDa=[];
    for i=2:size(test_int,1)
        readings=test_int{i,3}(7,:);
        readings=readings(~isnan(readings));
        TestMDa=[TestMDa mean(readings)];
    end
    [~,pval]=ttest2(TestMDa,MDa);
    t2=[t2; {'MD', [num2str(mean(TestMDa),'%.2f'),' (',num2str(std(TestMDa),'%.2f'),')'], num2str(pval,'%.2f')}];
    
    
    
    TestPSDa=[];
    for i=2:size(test_int,1)
        readings=test_int{i,3}(9,:);
        readings=readings(~isnan(readings));
        TestPSDa=[TestPSDa mean(readings)];
    end
    [~,pval]=ttest2(TestPSDa,PSDa);
    t2=[t2; {'PSD', [num2str(mean(TestPSDa),'%.2f'),' (',num2str(std(TestPSDa),'%.2f'),')'], num2str(pval,'%.2f')}];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    t1=[t1 t2(:,2:end)];
end

end

