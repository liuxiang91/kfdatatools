function [ DATA,raw ] = interpolateDataJapan( data )
%INTERPOLATEDATA Summary of this function goes here
%   Detailed explanation goes here
data=frontBackTrim(data);
numPat=size(data,1)-1;
outPatCount=2;
DATA=cell(1,11);
raw=cell(1,10);
DATA(1,:)={'ID','VisNum','InterpolatedReadings','baseline','age','race','sex', 'SphEq', 'CCT', 'AxLen','DiskHem'};

excludeCount=0;

for i=2:numPat+1
    skip=0;

    try
        time=data{i,2};
        while max(diff(time)==0)>0 %perturb same day visit
            i1=find(diff(time)==0);
            i1=i1(1);
            i2=i1+1;
            r=[data{i,3}(:,i1) data{i,3}(:,i2)];
            for j=1:3
                data{i,3}(j,i1)=mean(r(j,~isnan(r(j,:))),2);
            end
            data{i,10}(1,i1)=data{i,10}(1,i2);
            for j=2:10
                data{i,j}(:,i2)=[];
            end
            time=data{i,2};
            fprintf('%s has same day visits\n',data{i,1});
        end
        data{i,2}=time;
        start=min(time);
        if start==3
            tick=[3, 6:6:max(time)];
        else
            tick=[start, start:6:max(time)];
        end
        T=length(tick);
        temp=nan(9,T);
        fprintf('%s\n',data{i,1});
        for k=1:3 %MD PSD IOP
            readings=data{i,3}(k,:);
            time=data{i,2};
            time=time(~isnan(readings));
            readings=readings(~isnan(readings));
            % exclusion criteria below:
%             if max(diff(time))>24
%                 fprintf('%s has raw readings spaced > 24 mo\n',data{i,1});
%                 skip=1;
%             end
            if length(time)<4 
                fprintf('%s 3rd and last readings spaced < 24 mo\n',data{i,1});
                skip=1;
                excludeCount=excludeCount+1;
                break;
            end
%             if time(end)-time(3)<24
%                 fprintf('%s 3rd and last readings spaced < 24 mo\n',data{i,1});
%                 skip=1;
%             end
            
            if skip==1
                excludeCount=excludeCount+1;
                break;
            end
            
            temp(k,:)=interp1(time,readings,tick,'linear','extrap');
            for l=3:T %compute velocity
                slope=polyfit(tick(l-2:l),temp(k,l-2:l),1);
                temp(k+3,l)=slope(1);
            end
            for m=4:T %compute acceleration
                slope=polyfit(tick(m-1:m),temp(k+3,m-1:m),1);
                temp(k+6,m)=slope(1);
            end
        end
        time=data{i,2};
        age=interp1(time,data{i,4},tick,'linear','extrap');
    catch
        fprintf('%s excluded due to interpolation error\n',data{i,1});
        excludeCount=excludeCount+1;
        continue;
    end
    if skip==1
        continue;
    end
    
    if sum(~isnan(temp(9,:)))<2
        fprintf('%s has too few readings after interpolation\n',data{i,1});
        excludeCount=excludeCount+1;
        continue;
    end
    if sum(~isnan(temp(9,:)))>=2 
        DATA{outPatCount,1}=data{i,1};
        DATA{outPatCount,2}=tick(:,4:end);
        DATA{outPatCount,4}=repmat(mean(temp(1:3,1:2)')',1,T-3);%baseline
        DATA{outPatCount,3}=temp(:,4:end);
        DATA{outPatCount,5}=age(:,4:end);%age
        DATA{outPatCount,6}=ones(1,T-3)*min(data{i,5});%race
        DATA{outPatCount,7}=ones(1,T-3)*min(data{i,6});%sex
        DATA{outPatCount,8}=ones(1,T-3)*min(data{i,7});%SE
        DATA{outPatCount,9}=ones(1,T-3)*min(data{i,8});%CCT
        DATA{outPatCount,10}=ones(1,T-3)*min(data{i,9});%AX
        raw=[raw; data(i,:)];
        
        % put DH: 
        DHtimes=data{i,2}(data{i,10}==1);
        if ~isempty(DHtimes)
            DATA{outPatCount,11}=zeros(1,T-3);
            for DHt=DHtimes
                d=abs(tick(:,4:end)-DHt);
                 DATA{outPatCount,11}(d==min(d))=1;
            end
        else
            DATA{outPatCount,11}=zeros(1,T-3);
        end
        
        if max(isnan(DATA{outPatCount,2}))==1 || ...
                max(max(isnan(DATA{outPatCount,3})))==1 || ...
                max(max(isnan(DATA{outPatCount,4})))==1 || ...
                max(isnan(DATA{outPatCount,5}))==1 || ...
                max(isnan(DATA{outPatCount,6}))==1 || ...
                max(isnan(DATA{outPatCount,7}))==1 ||...
                max(isnan(DATA{outPatCount,7}))==1 ||...
                max(isnan(DATA{outPatCount,8}))==1 ||...
                max(isnan(DATA{outPatCount,9}))==1 ||...
                max(isnan(DATA{outPatCount,10}))==1 ||...
                max(isnan(DATA{outPatCount,11}))==1
            fprintf('check\n');
            
        end
        outPatCount=outPatCount+1;
    end
    
    
    
end
fprintf('Raw input: %d; output: %d; excluded: %d\n', numPat,outPatCount-2, excludeCount);
end

